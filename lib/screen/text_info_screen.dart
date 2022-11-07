import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';

class TextInfoScreen extends StatelessWidget {
  final String text;
  const TextInfoScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Инфо'),
      backgroundColor: Styles.lightColor,
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(
          text,
          style: Styles.subtitleTextStyle,
        ),
      ]),
    );
  }
}
