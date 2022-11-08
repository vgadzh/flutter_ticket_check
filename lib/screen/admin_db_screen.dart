import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/screen/text_info_screen.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/header_text_button_card.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';

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
              final text = await _ticketService.getDbInfo();
              if (!mounted) return;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => TextInfoScreen(text: text))));
            },
          ),
          const SizedBox(height: 20),
          // Clean ticket DB
          HeaderTextButtonCard(
            header: 'Очистка БД',
            text:
                'Удаление всех билетов и истории сканирования билетов их базы данных',
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
              showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: Text(
                        'База данных очищена',
                        style: Styles.bodyTextStyle1
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      content: Text(message, style: Styles.subtitleTextStyle),
                      actions: [
                        TextButton(
                          onPressed: (() {
                            Navigator.of(context).pop();
                          }),
                          child: Text(
                            'Ok',
                            style: Styles.bodyTextStyle1.copyWith(
                              color: Styles.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }));
            },
          ),
          const SizedBox(height: 20),
          // Fill DB with demo data
          HeaderTextButtonCard(
            header: 'Демо данные',
            text:
                'В базу данных будут добавлены несколько билетов с разными статусами для демонстрации работы приложения. Дата события текущая - сегодня.',
            textButton: 'Загрузить демо данные',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
