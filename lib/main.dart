import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/screen/bottom_bar.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Check',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Styles.primaryColor,
      ),
      home: const BottomBar(),
    );
  }
}
