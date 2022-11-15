import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class TicketHistoryCard extends StatelessWidget {
  final String date;
  final String text;
  const TicketHistoryCard({super.key, required this.date, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Styles.shadeColor,
        ),
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
                    text,
                    style: Styles.subtitleTextStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
