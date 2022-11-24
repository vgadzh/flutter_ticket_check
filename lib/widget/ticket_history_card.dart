import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class TicketHistoryCard extends StatelessWidget {
  final String date;
  final String text;
  final String ticketNumber;
  const TicketHistoryCard(
      {super.key,
      required this.date,
      required this.text,
      required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Styles.shadeColor,
            boxShadow: [
              BoxShadow(
                color: Styles.iconsColor,
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ]),
        padding: const EdgeInsets.all(10),
        // height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: Styles.subtitleTextStyle2,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "Билет:$ticketNumber\n$text",
                    style: Styles.subtitleTextStyle,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
