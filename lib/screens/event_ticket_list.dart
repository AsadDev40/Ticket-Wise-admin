import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/Model/ticket_model.dart';
import 'package:ticket_wise_admin/provider/ticket_provider.dart';
import 'package:ticket_wise_admin/screens/ticket_detail_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class EventTicketScreen extends StatefulWidget {
  final String eventId; // Add eventId as a parameter

  const EventTicketScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventTicketScreenState createState() => _EventTicketScreenState();
}

class _EventTicketScreenState extends State<EventTicketScreen> {
  Future<void>? _fetchTicketsFuture;

  @override
  void initState() {
    super.initState();

    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    _fetchTicketsFuture = ticketProvider.fetchTicketsByEventId(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PrimaryColor,
        title: const Text(
          'Event Tickets',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _fetchTicketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ticketProvider = Provider.of<TicketProvider>(context);

            // Calculate the total revenue and number of tickets sold
            double totalRevenue = 0.0;
            int totalTicketsSold = 0;

            for (var ticket in ticketProvider.tickets) {
              totalRevenue += ticket.price;
              totalTicketsSold += 1;
            }

            return Column(
              children: [
                // Summary card displaying total tickets and revenue
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: PrimaryColor,
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Event Summary',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tickets Sold:',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  '$totalTicketsSold',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Revenue:',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  '\$${totalRevenue.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Center(
                  child: Text(
                    'Tickets',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: PrimaryColor),
                  ),
                ),
                Expanded(
                  child: ticketProvider.tickets.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: ticketProvider.tickets.length,
                          itemBuilder: (context, index) {
                            final ticket = ticketProvider.tickets[index];
                            return buildTicketCard(ticket, context);
                          },
                        )
                      : const Center(
                          child: Text('No tickets found'),
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget buildTicketCard(TicketModel ticket, BuildContext context) {
  return Card(
    color: PrimaryColor,
    margin: const EdgeInsets.only(bottom: 16.0),
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    CachedNetworkImageProvider(ticket.eventimage.toString()),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.eventTitle,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(ticket.createdAt),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${ticket.price}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 128, // Fixed width for button
                height: 35, // Fixed height for button
                child: ElevatedButton(
                  onPressed: () {
                    Utils.navigateTo(
                        context, TicketDetailScreen(ticket: ticket));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                        fontSize: 13,
                        color: PrimaryColor), // Consistent font size
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
