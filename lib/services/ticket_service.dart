import 'package:flutter_ticket_check/enum/ticket_status.dart';
import 'package:flutter_ticket_check/services/service_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class TicketService {
  Database? _db;

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

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
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
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.execute(insertDemoTicketsQuery);
  }

  Future<int> deleteAllTickets() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(ticketTable);
    return deletedCount;
  }

  Future<int> deleteAllTicketHistory() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(ticketHistoryTable);
    return deletedCount;
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
        number: 'Нет данных',
        status: TicketStatus.unknown,
        zoneName: 'Нет данных',
        eventName: 'Нет данных',
        eventDate: 'Нет данных',
      );
    } else {
      return Ticket.fromRow(tickets.first);
    }
  }

  Future<String> getDbInfo() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      'sqlite_master',
      columns: ['type', 'name'],
      where: 'type=?',
      whereArgs: ['table'],
    );
    return result.toString();
  }

  static String getTicketStatusDescription({required TicketStatus status}) {
    String description = 'Неизвестный статус билета';
    switch (status) {
      case TicketStatus.ok:
        description = 'Новый билет';
        break;
      case TicketStatus.used:
        description = 'Использованный билет';
        break;
      case TicketStatus.unknown:
        description = 'Неизвестный билет';
        break;
    }
    return description;
  }
}

class Ticket {
  final String number;
  final TicketStatus status;
  final String zoneName;
  final String eventName;
  final String eventDate;

  Ticket({
    required this.number,
    required this.status,
    required this.zoneName,
    required this.eventName,
    required this.eventDate,
  });

  // Example. Row from DB
  //{id: 1, number: 11, status: ok, zone_name: Синяя зона, event_name: Октоберфест, event_date: 2022-11-11}
  Ticket.fromRow(Map<String, Object?> map)
      : number = map['number'] as String,
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

const insertDemoTicketsQuery = '''
INSERT INTO "main"."ticket"
("number", "status", "zone_name", "event_name", "event_date")
VALUES 
('11', 'ok', 'Синяя зона', 'Октоберфест', '2022-11-11'),
('22', 'used', 'Синяя зона', 'Октоберфест', '2022-11-11'),
('33', 'ok', 'Синяя зона', 'Октоберфест', '2022-11-11');
''';
