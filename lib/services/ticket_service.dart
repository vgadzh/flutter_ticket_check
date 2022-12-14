import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_ticket_check/enum/ticket_status.dart';
import 'package:flutter_ticket_check/services/service_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class TicketService {
  Database? _db;

  void dispose() async {
    await close();
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    }
    return db;
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<String?> getDbPath() async {
    String? dbPath;
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      dbPath = join(docsPath.path, dbName);
    } catch (e) {
      print(e.toString());
    }
    return dbPath;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      // final dbPath = join(docsPath.path, dbName);
      final dbPath = "${docsPath.path}/$dbName";
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createTicketTable);
      await db.execute(createTicketHistoryTable);
      // await insertDemoTickets();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> insertDemoTickets() async {
    final String responce =
        await rootBundle.loadString('assets/demo_tickets.json');
    final data = await json.decode(responce);
    final List tickets = data["tickets"];
    await insertTicketsFromList(tickets: tickets);
  }

  Future<void> insertTicketsFromList({required List tickets}) async {
    tickets.forEach((map) async {
      await insertTicket(
        number: map["number"],
        status: map["status"],
        zoneName: map["zone_name"],
        eventName: map["event_name"],
        eventDate: map["event_date"],
      );
    });
  }

  Future<int> deleteAllTickets() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(ticketTable);

    await insertTicketHistoryRecord(
      ticketNumber: 'all',
      text: '???????????????? ???????? ?????????????? ???? ????',
    );

    return deletedCount;
  }

  Future<int> deleteAllTicketHistory() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(ticketHistoryTable);
    return deletedCount;
  }

  Future<int> getTicketCount() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final tickets = await db.query(ticketTable);
    return tickets.length;
  }

  Future<int> getTicketHistoryCount() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final ticketHistoryRecords = await db.query(ticketHistoryTable);
    return ticketHistoryRecords.length;
  }

  Future<Ticket> getTicket({required ticketNumber}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final tickets = await db.query(
      ticketTable,
      limit: 1,
      where: 'number=?',
      whereArgs: [ticketNumber],
    );
    if (tickets.isEmpty) {
      return Ticket(
        id: -1,
        number: '?????? ????????????',
        status: TicketStatus.unknown,
        zoneName: '?????? ????????????',
        eventName: '?????? ????????????',
        eventDate: '?????? ????????????',
      );
    } else {
      final ticket = Ticket.fromRow(tickets.first);
      final status = ticket.status;
      await insertTicketHistoryRecord(
        ticketNumber: ticket.number,
        text: '???????????????????????? ????????????. ????????????: $status',
      );
      return ticket;
    }
  }

  Future<void> insertTicket({
    required String number,
    required String status,
    required String zoneName,
    required String eventName,
    required String eventDate,
  }) async {
    try {
      await _ensureDbIsOpen();
      final db = _getDatabaseOrThrow();
      await db.insert(ticketTable, {
        'number': number,
        'status': status,
        'zone_name': zoneName,
        'event_name': eventName,
        'event_date': eventDate,
      });
      await insertTicketHistoryRecord(
        ticketNumber: number,
        text: '?????????? ???????????????? ?? ???????? ???????????? ???? ????????????????: $status',
      );
    } catch (e) {
      await insertTicketHistoryRecord(
        ticketNumber: number,
        text: '???????????? ???????????????????? ?? ????: ${e.toString()}',
      );
    }
  }

  Future<void> markTicketAsUsed({required Ticket ticket}) async {
    if (ticket.status == TicketStatus.ok) {
      await _ensureDbIsOpen();
      final db = _getDatabaseOrThrow();
      await db.update(
        ticketTable,
        {'status': 'used'},
        where: 'id=?',
        whereArgs: [ticket.id],
      );
      await insertTicketHistoryRecord(
        ticketNumber: ticket.number,
        text: '???????????? ????????????????, ?????????? ?????????????? ?????? ???????????????????????????? (used)',
      );
    }
  }

  Future<void> insertTicketHistoryRecord(
      {required String ticketNumber, required String text}) async {
    DateTime now = DateTime.now();
    final date =
        '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(ticketHistoryTable, {
      'ticket_number': ticketNumber,
      'date': date,
      'text': text,
    });
  }

  Future<Iterable<TicketHistoryRecord>> getTicketHistory(
      {required ticketNumber}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final records = await db.query(ticketHistoryTable,
        where: 'ticket_number=?',
        whereArgs: [ticketNumber],
        orderBy: 'id DESC');
    return records.map((n) => TicketHistoryRecord.fromRow(n));
  }

  Future<Iterable<TicketHistoryRecord>> getAllTicketsHistoryRecords() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final records = await db.query(
      ticketHistoryTable,
      orderBy: 'id DESC',
    );
    return records.map((n) => TicketHistoryRecord.fromRow(n));
  }

  static String getTicketsHistoryCsv(
      {required List<TicketHistoryRecord> ticketHistoryRecords}) {
    String ticketHistoryCsv = TicketHistoryRecord.csvHeader();
    ticketHistoryCsv += '\n';
    ticketHistoryRecords.forEach((element) {
      ticketHistoryCsv += element.toString() + "\n";
    });
    return ticketHistoryCsv;
  }

  static String getTicketStatusDescription({required TicketStatus status}) {
    String description = '?????????????????????? ???????????? ????????????';
    switch (status) {
      case TicketStatus.ok:
        description = '?????????? ??????????';
        break;
      case TicketStatus.used:
        description = '???????????????????????????? ??????????';
        break;
      case TicketStatus.unknown:
        description = '?????????????????????? ??????????';
        break;
    }
    return description;
  }
}

class TicketHistoryRecord {
  final int id;
  final String ticketNumber;
  final String date;
  final String text;
  TicketHistoryRecord(this.ticketNumber, this.id,
      {required this.date, required this.text});
  TicketHistoryRecord.fromRow(Map<String, Object?> map)
      : id = map['id'] as int,
        date = map['date'] as String,
        text = map['text'] as String,
        ticketNumber = map['ticket_number'] as String;

  @override
  String toString() => "$id|$ticketNumber|$date|$text";

  static String csvHeader() => "id|ticket_number|date|text";
}

class Ticket {
  final int id;
  final String number;
  final TicketStatus status;
  final String zoneName;
  final String eventName;
  final String eventDate;

  Ticket({
    required this.id,
    required this.number,
    required this.status,
    required this.zoneName,
    required this.eventName,
    required this.eventDate,
  });

  // Example. Row from DB
  //{id: 1, number: 11, status: ok, zone_name: ?????????? ????????, event_name: ??????????????????????, event_date: 2022-11-11}
  Ticket.fromRow(Map<String, Object?> map)
      : id = map['id'] as int,
        number = map['number'] as String,
        status = (map['status'] as String) == 'ok'
            ? TicketStatus.ok
            : (map['status'] as String) == 'used'
                ? TicketStatus.used
                : TicketStatus.unknown,
        zoneName = map['zone_name'] as String,
        eventName = map['event_name'] as String,
        eventDate = map['event_date'] as String;

  @override
  String toString() =>
      "Ticket | number: $number | status: $status | zone_name: $zoneName | event_name: $eventName | event_date: $eventDate";
}

const dbName = 'tickets.db';
const ticketTable = 'ticket';
const ticketHistoryTable = 'ticket_history';
const createTicketTable = '''
CREATE TABLE IF NOT EXISTS "ticket" (
	"id"	INTEGER,
	"number"	TEXT NOT NULL UNIQUE,
	"status"	TEXT NOT NULL,
	"zone_name"	TEXT NOT NULL,
	"event_name"	TEXT NOT NULL,
	"event_date"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
''';
const createTicketHistoryTable = '''
CREATE TABLE IF NOT EXISTS "ticket_history" (
	"id"	INTEGER,
	"ticket_number"	TEXT NOT NULL,
	"date"	TEXT NOT NULL,
	"text"	TEXT NOT NULL,
	PRIMARY KEY("id")
);
''';
