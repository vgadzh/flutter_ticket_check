import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/screen/admin_db_screen.dart';
import 'package:flutter_ticket_check/screen/ticket_screen.dart';
import 'package:flutter_ticket_check/services/scanner_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future<void> barcodeScan(BuildContext context) async {
    final String barcode = await ScannerService.getBarcode();
    if (barcode != '-1') {
      if (!mounted) return;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => TicketScreen(
                    barcode: barcode,
                    markTicketAsUsed: false,
                  ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.lightColor,
      body: ListView(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const AdminDbScreen())));
            },
            child: Text('Администратор БД',
                style: Styles.bodyTextStyle1.copyWith(
                  color: Styles.primaryColor,
                )),
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.primaryColor,
              ),
              onPressed: (() => barcodeScan(context)),
              child: Text(
                textAlign: TextAlign.center,
                'Проверка без гашения',
                style: Styles.bodyTextStyle1.copyWith(color: Styles.lightColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
