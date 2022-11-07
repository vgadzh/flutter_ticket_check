import 'package:flutter_ticket_check/services/ticket_service.dart';

class AdminService {
  static clearDb() async {
    final ticketService = TicketService();
    //delete tickets
    await ticketService.deleteAllTickets();
    //delete ticket history
    await ticketService.deleteAllTicketHistory();
  }
}
