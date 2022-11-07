import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class HeaderTextButtonCard extends StatelessWidget {
  final String header;
  final String text;
  final String textButton;

  final Function() onPressed;

  const HeaderTextButtonCard({
    super.key,
    required this.header,
    required this.text,
    required this.textButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Styles.lightColor,
        boxShadow: [
          BoxShadow(
            color: Styles.shadeColor,
            blurRadius: 3,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style:
                  Styles.bodyTextStyle1.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: Styles.subtitleTextStyle,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: onPressed,
                    child: Text(
                      textButton,
                      style: Styles.subtitleTextStyle
                          .copyWith(color: Styles.primaryColor),
                    )),
              ],
            ),
          ]),
    );
  }
}
