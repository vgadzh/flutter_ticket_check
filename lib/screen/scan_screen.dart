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
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
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
            padding: const EdgeInsets.all(20),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Режим проверки и гашения билета',
                  style: Styles.h6,
                ),
                const SizedBox(height: 20),
                Text(
                  'В этом режиме производится проверка билета при входе гостя на мероприятие.\nСтатусы билета:',
                  style: Styles.bodyTextStyle1,
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    // status ok
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 32,
                          color: Styles.secondaryColor,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            'Новый билет со статусом ОК. Гость может пройти на мероприятие, билет будет помечен как использованный в базе данных.',
                            style: Styles.bodyTextStyle1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // status used
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.cancel_outlined,
                          size: 32,
                          color: Styles.accentColor,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Использованный билет. Проход по нему уже был выполнен. Повторный проход запрещен',
                            style: Styles.bodyTextStyle1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // status unknown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.contact_support_outlined,
                          size: 32,
                          color: Styles.iconsColor,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'Неизвестный билет. По этому билету в базе данных нет информации.',
                            style: Styles.bodyTextStyle1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
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
                'Сканировать и погасить билет',
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
