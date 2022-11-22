import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

Future<T?> showDialogOk<T>({
  required BuildContext context,
  required String title,
  required String text,
}) {
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text(
            title,
            style: Styles.bodyTextStyle1.copyWith(fontWeight: FontWeight.w500),
          ),
          content: Text(text, style: Styles.subtitleTextStyle),
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
}
