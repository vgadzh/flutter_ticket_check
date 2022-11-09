import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.lightColor,
      body: ListView(
        children: [
          Text(
            'Home Screen (i)',
            style: Styles.h5,
          ),
          const Text('Date'),
          const Text('Events'),
          const Text('Zones'),
          const Text('Tickets'),
        ],
      ),
    );
  }
}
