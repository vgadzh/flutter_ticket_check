import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';
import 'package:flutter_ticket_check/widget/progress_indicator.dart';
import 'package:flutter_ticket_check/widget/ticket_history_card.dart';
import 'package:share_plus/share_plus.dart';

class TicketHistoryScreen extends StatelessWidget {
  final String barcode;
  late final List<TicketHistoryRecord> _ticketHistory;
  TicketHistoryScreen({super.key, required this.barcode});

  Future getTicketHistory({required barcode}) async {
    final ticketService = TicketService();
    final ticketHistory = (barcode != 'all')
        ? await ticketService.getTicketHistory(ticketNumber: barcode)
        : await ticketService.getAllTicketsHistoryRecords();
    _ticketHistory = ticketHistory.toList();

    // await Future.delayed(const Duration(seconds: 10));
  }

  Future<void> shareTicketHistory() async {
    if (_ticketHistory.isNotEmpty) {
      final csv = TicketService.getTicketsHistoryCsv(
          ticketHistoryRecords: _ticketHistory);

      final intList = utf8.encode(csv);

      await Share.shareXFiles([
        XFile.fromData(
          Uint8List.fromList(intList),
          name: 'history.scv',
          mimeType: 'text/csv',
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: (barcode != 'all') ? 'История билета' : 'История',
        actions: [
          IconButton(
            onPressed: shareTicketHistory,
            icon: Icon(
              Icons.share,
              color: Styles.darkColor,
            ),
          ),
        ],
      ),
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
                    text: ticketHistoryRecord.text,
                    ticketNumber: ticketHistoryRecord.ticketNumber,
                  );
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
