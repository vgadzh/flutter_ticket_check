import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/screen/admin_db_screen.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.lightColor,
      body: ListView(
        children: [
          const Text('More Screen'),
          const Text('Reports'),
          const Text('Functions'),
          const Text('About'),
          const Text('Info'),
          const Text('Settings'),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const AdminDbScreen())));
            },
            child: const Text('Admin DB'),
          ),
        ],
      ),
    );
  }
}
