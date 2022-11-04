import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/ticket_history_card.dart';

class TicketHistoryScreen extends StatelessWidget {
  final String ticketNumber;
  const TicketHistoryScreen({super.key, required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.lightColor,
        foregroundColor: Styles.darkColor,
        title: Text(
          'История билета',
          style: Styles.h6.copyWith(color: Styles.darkColor),
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(ticketNumber),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:45',
          text: 'Проверка билета. Статус: FAIL, проход запрещен',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Проверка билета. Статус: FAIL, проход запрещен',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:00',
          text: 'Проверка билета. Статус: ОК, проход разрешен',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 08:00:00',
          text: 'Билет загружен в приложение',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text:
              'Длинная строка в истории на несколько строк. Разрешено 3 строки, все что не влезет будет скрыто за многотичием. И еще пару слов',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Сообщение',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Сообщение',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Сообщение',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Сообщение',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Сообщение',
        ),
        const SizedBox(height: 15),
        const TicketHistoryCard(
          dateTime: '2022-11-09 12:03:15',
          text: 'Сообщение',
        ),
      ]),
    );
  }
}
