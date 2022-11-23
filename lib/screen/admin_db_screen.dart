import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ticket_check/screen/text_info_screen.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/utils/show_dialog_ok.dart';
import 'package:flutter_ticket_check/widget/header_text_button_card.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AdminDbScreen extends StatefulWidget {
  const AdminDbScreen({super.key});

  @override
  State<AdminDbScreen> createState() => _AdminDbScreenState();
}

class _AdminDbScreenState extends State<AdminDbScreen> {
  late final TicketService _ticketService;

  @override
  void initState() {
    _ticketService = TicketService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Admin DB'),
      backgroundColor: Styles.lightColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Attention
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Styles.shadeColor,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: 64,
                  color: Styles.tretiaryColor,
                ),
                const SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Внимание!',
                      style: Styles.h6,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      child: Text(
                        'Действия на этой странице \nмогут привести к потере \nили порче данных. ',
                        style: Styles.subtitleTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Admin functions
          //Show DB tables
          HeaderTextButtonCard(
            header: 'Структура БД',
            text: 'Будут показаны таблицы в базе данных',
            textButton: 'Показать структуру БД',
            onPressed: () async {
              final ticketCount = await _ticketService.getTicketCount();
              final ticketHistoryRecordCount =
                  await _ticketService.getTicketHistoryCount();
              final text = await _ticketService.getDbInfo();
              final message =
                  'tickets: $ticketCount\nticketHistory: $ticketHistoryRecordCount\n$text';
              if (!mounted) return;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => TextInfoScreen(text: message))));
            },
          ),
          const SizedBox(height: 20),
          // Clean ticket DB
          HeaderTextButtonCard(
            header: 'Очистка БД',
            text:
                'Удаление всех билетов и истории сканирования билетов из базы данных',
            textButton: 'Очистить БД',
            onPressed: () async {
              //delete tickets
              final deletedTickets = await _ticketService.deleteAllTickets();
              //delete ticket history
              final deletedHistoryRecords =
                  await _ticketService.deleteAllTicketHistory();
              final message =
                  'Удалено билетов: $deletedTickets, записей истории: $deletedHistoryRecords';
              if (!mounted) return;
              showDialogOk(
                  context: context,
                  title: 'База данных очищена',
                  text: message);
            },
          ),
          const SizedBox(height: 20),
          // Fill DB with demo data
          HeaderTextButtonCard(
            header: 'Демо данные',
            text:
                'В базу данных будут добавлены несколько билетов с разными статусами для демонстрации работы приложения.',
            textButton: 'Загрузить демо данные',
            onPressed: () async {
              try {
                await _ticketService.insertDemoTickets();
                if (!mounted) return;
                showDialogOk(
                    context: context,
                    title: 'Демо данные',
                    text: 'Демо билеты успешно добавлены в базу данных');
              } catch (e) {
                showDialogOk(
                    context: context,
                    title: 'Ошибка загрузки демо данных',
                    text: e.toString());
              }
            },
          ),
          const SizedBox(height: 20),
          HeaderTextButtonCard(
            header: 'Файл билетов JSON',
            text:
                'Экспортировать файл билетов JSON с примером заполнения. Этот файл можно использовать для импорта билетов',
            textButton: 'Экспорт JSON',
            onPressed: () async {
              final data = await rootBundle.load('assets/demo_tickets.json');
              final buffer = data.buffer;
              await Share.shareXFiles([
                XFile.fromData(
                  buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
                  name: 'tickets.json',
                  mimeType: 'application/json',
                ),
              ]);
            },
          ),
          // const SizedBox(height: 20),
          // HeaderTextButtonCard(
          //   header: 'Файл базы данных',
          //   text:
          //       'Экспортировать файл базы данных Sqlite DB для проверки работы приложения и диагностики проблем',
          //   textButton: 'Экспорт DB',
          //   onPressed: () async {
          //     final ticketService = TicketService();
          //     final dbPath = await ticketService.getDbPath();
          //     print(dbPath);
          //     if (dbPath != null) {
          //       final file = File(dbPath);

          //       final bytes = await file.readAsBytes();
          //       await Share.shareXFiles([
          //         XFile.fromData(
          //           bytes,
          //           name: 'tickets.db',
          //         ),
          //       ]);
          //     }

          //     // ticketService.dispose();

          //     if (dbPath != null) {}
          //   },
          // ),
        ],
      ),
    );
  }
}
