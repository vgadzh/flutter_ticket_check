import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
      alignment: Alignment.center,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Scan result: $_scanBarcode\n'),
          SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: (() => barcodeScan()),
              child: const Text('Scan'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> barcodeScan() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      print('Code: $barcodeScanRes');
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
