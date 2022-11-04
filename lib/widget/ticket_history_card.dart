import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class TicketHistoryCard extends StatelessWidget {
  final String dateTime;
  final String text;
  const TicketHistoryCard(
      {super.key, required this.dateTime, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  dateTime,
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
