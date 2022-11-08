import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_ticket_check/screen/ticket_screen.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String _scanBarcode = 'Unknown';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Scan result: $_scanBarcode\n'),
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
                'Scan Very very very very sdfsafsdf long text',
                style: Styles.bodyTextStyle1.copyWith(color: Styles.lightColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> barcodeScan(BuildContext context) async {
    String barcodeScanRes;

    // try {
    //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
    //     '#ff6666',
    //     'Cancel',
    //     true,
    //     ScanMode.QR,
    //   );
    //   print('Code: $barcodeScanRes');
    // } on PlatformException {
    //   barcodeScanRes = 'Failed to get platform version';
    // }
    final ticketService = TicketService();
    final Ticket ticket = await ticketService.getTicket(ticketNumber: '11');

    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => TicketScreen(
                  ticket: ticket,
                  barcode: '111',
                ))));
    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }
}
