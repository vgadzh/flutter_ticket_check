import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/enum/ticket_status.dart';
import 'package:flutter_ticket_check/screen/ticket_history_screen.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/caption_double_text_line.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';

Icon ticketOkIcon = Icon(
  Icons.check_circle_outline,
  size: 64,
  color: Styles.secondaryColor,
);
Icon ticketUsedIcon = Icon(
  Icons.cancel_outlined,
  size: 64,
  color: Styles.accentColor,
);
Icon ticketUnknownIcon = Icon(
  Icons.contact_support_outlined,
  size: 64,
  color: Styles.iconsColor,
);

class TicketScreen extends StatelessWidget {
  final Ticket ticket;
  final String barcode;
  const TicketScreen({super.key, required this.ticket, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Проверка билета',
      ),
      backgroundColor: Styles.lightColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Scanning results card
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Styles.shadeColor,
              ),
              padding: const EdgeInsets.all(15),
              height: 72,
              child: Row(
                children: [
                  Icon(
                    Icons.camera,
                    size: 32,
                    color: Styles.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Результат сканирования',
                          style: Styles.bodyTextStyle1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          barcode,
                          style: Styles.subtitleTextStyle
                              .copyWith(color: Styles.iconsColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Ticket card
            Container(
              height: 200,
              width: double.infinity,
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // Icon - Event/date line
                  Flexible(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (ticket.status == TicketStatus.ok)
                            ? ticketOkIcon
                            : (ticket.status == TicketStatus.used)
                                ? ticketUsedIcon
                                : ticketUnknownIcon,
                        const SizedBox(width: 15),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket.eventName,
                                style: Styles.h6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                ticket.eventDate,
                                style: Styles.bodyTextStyle1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(thickness: 2, color: Styles.shadeColor),
                  CaptionDoubleTextLine(
                      captionText: 'Номер билета:', text: ticket.number),
                  const SizedBox(height: 5),
                  CaptionDoubleTextLine(
                      captionText: 'Категория:', text: ticket.zoneName),
                  const SizedBox(height: 5),
                  CaptionDoubleTextLine(
                      captionText: 'Статус:',
                      text: TicketService.getTicketStatusDescription(
                          status: ticket.status)),
                ],
              ),
            ),
            // History button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TicketHistoryScreen(
                                  ticketNumber: ticket.number))));
                    },
                    child: Text(
                      'История билета',
                      style: Styles.subtitleTextStyle
                          .copyWith(color: Styles.primaryColor),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
