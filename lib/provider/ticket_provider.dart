import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/ticket_model.dart';

class TicketProvider with ChangeNotifier {
  final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  // List to hold orders
  List<TicketModel> _tickets = [];

  // Getter to retrieve the orders list
  List<TicketModel> get tickets => _tickets;

  // Function to add a new order to Firestore and local list
  Future<void> addTicket(TicketModel newOrder) async {
    try {
      DocumentReference docRef = await ticketCollection.add(newOrder.toJson());

      TicketModel updatTicket = newOrder.copyWith(tickeId: docRef.id);

      _tickets.add(updatTicket);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchTicketsByEventId(String eventId) async {
    try {
      QuerySnapshot snapshot = await ticketCollection
          .where('eventId', isEqualTo: eventId)
          // .orderBy('createdAt', descending: true)
          .get();

      _tickets = snapshot.docs
          .map(
              (doc) => TicketModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSoldTicketsCount(String eventId) async {
    try {
      // Get the tickets for the specific event
      QuerySnapshot snapshot =
          await ticketCollection.where('eventId', isEqualTo: eventId).get();

      return snapshot.docs.length;
    } catch (e) {
      rethrow;
    }
  }

  // Function to fetch all orders from Firestore for a specific user
  Future<void> fetchTickets() async {
    try {
      QuerySnapshot snapshot =
          await ticketCollection.orderBy('createdAt', descending: true).get();
      print('snapshot: ${snapshot.docs.first.id}');

      _tickets = snapshot.docs
          .map(
              (doc) => TicketModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Function to remove an order from Firestore and local list
  Future<void> removeTicket(String ticketId) async {
    try {
      await ticketCollection.doc(ticketId).delete();
      _tickets.removeWhere((ticket) => ticket.ticketId == ticketId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Function to update the status of an order in Firestore and locally
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderIndex =
        _tickets.indexWhere((order) => order.ticketId == orderId);
    if (orderIndex != -1) {
      try {
        await ticketCollection.doc(orderId).update({'status': newStatus});
        _tickets[orderIndex] = _tickets[orderIndex].copyWith(status: newStatus);
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }
}
