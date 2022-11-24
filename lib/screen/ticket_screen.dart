import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/enum/ticket_status.dart';
import 'package:flutter_ticket_check/screen/ticket_history_screen.dart';
import 'package:flutter_ticket_check/services/ticket_service.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/caption_double_text_line.dart';
import 'package:flutter_ticket_check/widget/my_app_bar.dart';
import 'package:flutter_ticket_check/widget/progress_indicator.dart';

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
  final String barcode;
  final bool markTicketAsUsed;
  late final Ticket? _ticket;
  TicketScreen(
      {super.key, required this.barcode, required this.markTicketAsUsed});

  Future<Ticket> getTicket(BuildContext context) async {
    final ticketService = TicketService();
    final ticket = await ticketService.getTicket(ticketNumber: barcode);
    if (markTicketAsUsed) await ticketService.markTicketAsUsed(ticket: ticket);
    _ticket = ticket;
    return ticket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          title: markTicketAsUsed
              ? 'Проверка билета с гашением'
              : 'Проверка без гашения'),
      backgroundColor: Styles.lightColor,
      body: FutureBuilder(
        future: getTicket(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Scanning results card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
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
                                (_ticket!.status == TicketStatus.ok)
                                    ? ticketOkIcon
                                    : (_ticket!.status == TicketStatus.used)
                                        ? ticketUsedIcon
                                        : ticketUnknownIcon,
                                const SizedBox(width: 15),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _ticket!.eventName,
                                        style: Styles.h6,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _ticket!.eventDate,
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
                              captionText: 'Номер билета:',
                              text: _ticket!.number),
                          const SizedBox(height: 5),
                          CaptionDoubleTextLine(
                              captionText: 'Категория:',
                              text: _ticket!.zoneName),
                          const SizedBox(height: 5),
                          CaptionDoubleTextLine(
                              captionText: 'Статус:',
                              text: TicketService.getTicketStatusDescription(
                                  status: _ticket!.status)),
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
                                      builder: ((context) =>
                                          TicketHistoryScreen(
                                              barcode: barcode))));
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
              );

            default:
              return const MyProgressIndicator();
          }
        },
      ),
    );
  }
}
