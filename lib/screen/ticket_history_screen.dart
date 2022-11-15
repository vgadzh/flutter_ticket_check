import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';

import 'package:flutter_ticket_check/widget/my_app_bar.dart';
import 'package:flutter_ticket_check/widget/progress_indicator.dart';
import 'package:flutter_ticket_check/widget/ticket_history_card.dart';

class TicketHistoryScreen extends StatelessWidget {
  final String barcode;
  List<TicketHistoryRecord> _ticketHistory = [];
  TicketHistoryScreen({super.key, required this.barcode});

  Future getTicketHistory({required barcode}) async {
    final ticketService = TicketService();
    final ticketHistory =
        await ticketService.getTicketHistory(tickerNumber: barcode);
    _ticketHistory = ticketHistory.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'История билета'),
      body: FutureBuilder(
        future: getTicketHistory(barcode: barcode),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ListView.builder(
                itemCount: _ticketHistory.length,
                itemBuilder: (context, index) {
                  final ticketHistoryRecord = _ticketHistory[index];
                  return TicketHistoryCard(
                      date: ticketHistoryRecord.date,
                      text: ticketHistoryRecord.text);
                },
              );
            default:
              return const MyProgressIndicator();
          }
        },
      ),
    );
  }
}
