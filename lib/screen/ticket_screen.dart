import 'package:flutter/material.dart';
import 'package:flutter_ticket_check/screen/ticket_history_screen.dart';
import 'package:flutter_ticket_check/utils/app_styles.dart';
import 'package:flutter_ticket_check/widget/captionDoubleTextLine.dart';

class TicketScreen extends StatelessWidget {
  final String ticketNumber;
  const TicketScreen({super.key, required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.lightColor,
        foregroundColor: Styles.darkColor,
        title: Text(
          'Проверка билета',
          style: Styles.h6.copyWith(color: Styles.darkColor),
        ),
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
                          ticketNumber,
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
                        const Icon(
                          Icons.camera,
                          size: 64,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Event name adsfdghfghjgkjhll;qwerqty",
                                style: Styles.h6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Event Datetime adsfdghfghjgkjhll;qwerqty',
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
                  const CaptionDoubleTextLine(
                      captionText: 'Номер билета:',
                      text: 'adsfdghfghjgkjhll;qwerqtysdfsdf'),
                  const SizedBox(height: 5),
                  const CaptionDoubleTextLine(
                      captionText: 'Категория:',
                      text: 'Синяя зона adsfdgh fghjg kjhl l;qwerqtysdfsdf'),
                  const SizedBox(height: 5),
                  const CaptionDoubleTextLine(
                      captionText: 'Статус:', text: 'Проход разрешен'),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TicketHistoryScreen(
                                  ticketNumber: ticketNumber))));
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
