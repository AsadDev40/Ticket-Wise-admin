// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_wise_admin/Model/ticket_model.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class TicketDetailScreen extends StatefulWidget {
  final TicketModel ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ticket Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CachedNetworkImage(
                    imageUrl: widget.ticket.qrimage.toString(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                        child: Text(
                            'Network Error Please Check your Internet Connection')),
                  ),

                  const SizedBox(height: 16.0),

                  buildInfoCard(
                    Icons.person,
                    'Name',
                    widget.ticket.customername,
                  ),
                  buildInfoCard(
                    Icons.title,
                    'Event Title',
                    widget.ticket.eventTitle,
                  ),
                  buildInfoCard(
                    Icons.call,
                    'Phone Number',
                    widget.ticket.customerphone,
                  ),
                  buildInfoCard(
                    Icons.badge,
                    'Ticket Id',
                    widget.ticket.ticketId,
                  ),
                  buildInfoCard(
                    Icons.calendar_today,
                    'Ticket Purchase Date',
                    DateFormat('yyyy-MM-dd').format(widget.ticket.createdAt),
                  ),
                  buildInfoCard(
                    Icons.alarm,
                    'Event Start Time',
                    widget.ticket.starttime.toString(),
                  ),
                  buildInfoCard(
                    Icons.alarm,
                    'Event End Time',
                    widget.ticket.endtime.toString(),
                  ),
                  buildInfoCard(
                    Icons.location_city,
                    'City',
                    widget.ticket.city.toString(),
                  ),
                  buildInfoCard(
                    Icons.location_on,
                    'Location',
                    widget.ticket.location.toString(),
                  ),
                  buildInfoCard(
                    Icons.attach_money,
                    'Total Price',
                    '\$${widget.ticket.price}',
                  ),

                  const SizedBox(height: 16.0),

                  // Rating Section (only if not submitted and order is delivered)
                  // if (!_isRatingSubmitted &&
                  //     widget.ticket.status == 'Delivered')
                  //   buildRatingSection(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build info cards
  Widget buildInfoCard(IconData icon, String label, String value) {
    return Card(
      color: PrimaryColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          label,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
