import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.lightColor,
      body: ListView(
        children: const [
          Text('More Screen'),
          Text('Reports'),
          Text('Functions'),
          Text('About'),
          Text('Info'),
          Text('Settings'),
        ],
      ),
    );
  }
}
