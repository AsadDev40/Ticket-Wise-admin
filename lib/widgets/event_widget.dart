import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/event_model.dart';
import 'package:ticket_wise_admin/provider/event_provider.dart';
import 'package:ticket_wise_admin/screens/edit_event_screen.dart';
import 'package:ticket_wise_admin/screens/event_detail_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';
import 'package:ticket_wise_admin/provider/ticket_provider.dart';

class EventListView extends StatelessWidget {
  final List<EventModel> events;

  const EventListView({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final productprovider = Provider.of<EventProvider>(context);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return InkWell(
          onTap: () {
            Utils.navigateTo(
              context,
              EventDetailScreen(
                event: event,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Card(
              color: PrimaryColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Utils.navigateTo(
                                context, EditEventScreen(event: event));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            productprovider.deleteEvent(event.id);
                          },
                        ),
                      ],
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: const BoxDecoration(color: Colors.blue),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: event.eventImageUrls.first,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white), // White text
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, bottom: 1),
                              child: Text(
                                '\$${event.ticketPrice}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0),
                              child: Text(
                                '(${event.eventDate})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FutureBuilder<int>(
                      future:
                          Provider.of<TicketProvider>(context, listen: false)
                              .getSoldTicketsCount(event.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error, color: Colors.red);
                        } else if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${snapshot.data} Sold',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '0 Sold',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
