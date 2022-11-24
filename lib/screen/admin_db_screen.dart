import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/utils/show_dialog_ok.dart';
import 'package:flutter_ticket_check/widget/header_text_button_card.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';
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
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Styles.iconsColor,
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
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
            header: 'Содержимое БД',
            text:
                'Проверка количества билетов и количества записей истории изменения статуса билетов',
            textButton: 'Показать содержимое БД',
            onPressed: () async {
              final ticketCount = await _ticketService.getTicketCount();
              final ticketHistoryRecordCount =
                  await _ticketService.getTicketHistoryCount();
              final message =
                  'Билетов: $ticketCount\nЗаписей истории: $ticketHistoryRecordCount';
              if (!mounted) return;
              showDialogOk(
                  context: context, title: 'Содержимое БД', text: message);
            },
          ),
          const SizedBox(height: 20),
          // Clean ticket DB
          HeaderTextButtonCard(
            header: 'Удаление билетов',
            text: 'Внимание! Все билеты будут удалены из базы данных',
            textButton: 'Удалить билеты',
            onPressed: () async {
              //delete tickets
              final deletedTickets = await _ticketService.deleteAllTickets();
              final message = 'Удалено билетов: $deletedTickets';
              if (!mounted) return;
              showDialogOk(
                  context: context,
                  title: 'База данных очищена',
                  text: message);
            },
          ),
          const SizedBox(height: 20),
          // Clean ticket DB
          HeaderTextButtonCard(
            header: 'Удаление истории',
            text:
                'Внимание! Вся история сканирования и изменения статусов билетов будет удалена из базы данных',
            textButton: 'Удалить историю',
            onPressed: () async {
              final deletedCount =
                  await _ticketService.deleteAllTicketHistory();
              final message = 'Удалено записей истории: $deletedCount';
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
            header: 'Экспорт шаблона JSON',
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
          const SizedBox(height: 20),
          HeaderTextButtonCard(
            header: 'Импорт из JSON',
            text: 'Импорт билетов из файла JSON',
            textButton: 'Импорт из JSON',
            onPressed: () async {
              try {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  final path = result.files.single.path;
                  if (path != null) {
                    final File file = File(path);
                    final source = file.readAsStringSync();
                    final data = json.decode(source);
                    final List tickets = data['tickets'];
                    final ticketService = TicketService();
                    final ticketCountBefore =
                        await ticketService.getTicketCount();
                    await ticketService.insertTicketsFromList(tickets: tickets);
                    final ticketCountAfter =
                        await ticketService.getTicketCount();

                    final message =
                        "JSON файл содержит: ${tickets.length} билетов,\nдобавлено в базу данных: ${ticketCountAfter - ticketCountBefore} билетов";
                    showDialogOk(
                        context: context,
                        title: 'Загрузка JSON файла',
                        text: message);
                  }
                }
              } catch (e) {
                showDialogOk(
                    context: context,
                    title: 'Ошибка обработки JSON файла',
                    text: e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}
