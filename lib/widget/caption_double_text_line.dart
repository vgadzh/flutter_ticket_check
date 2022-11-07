import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class CaptionDoubleTextLine extends StatelessWidget {
  final String captionText;
  final String text;
  const CaptionDoubleTextLine(
      {super.key, required this.captionText, required this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Text(
            captionText,
            style:
                Styles.subtitleTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: Styles.subtitleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
