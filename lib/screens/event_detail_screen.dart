// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/screens/event_ticket_list.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:video_player/video_player.dart';
import 'package:ticket_wise_admin/Model/event_model.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class EventDetailScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.event.eventvideourl)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: PrimaryColor,
        title: Text(
          widget.event.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.event.eventImageUrls.length +
                      1, // Include the video
                  itemBuilder: (context, index, realIndex) {
                    if (index < widget.event.eventImageUrls.length) {
                      // Display image
                      return CachedNetworkImage(
                        imageUrl: widget.event.eventImageUrls[index],
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    } else {
                      return _videoController.value.isInitialized
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_videoController.value.isPlaying) {
                                    _videoController.pause();
                                  } else {
                                    _videoController.play();
                                  }
                                });
                              },
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            )
                          : const Center(child: CircularProgressIndicator());
                    }
                  },
                  options: CarouselOptions(
                    height: 300,
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoCard(
                          Icons.title, 'Event Title', widget.event.title),
                      buildInfoCard(Icons.calendar_today, 'Event Date',
                          '${widget.event.eventDate} '),
                      buildInfoCard(Icons.alarm, 'Event Start Time',
                          widget.event.startTime.toString()),
                      buildInfoCard(Icons.alarm, 'Event End Time',
                          widget.event.endTime.toString()),
                      buildInfoCard(Icons.attach_money, 'Ticket Price',
                          '\$${widget.event.ticketPrice}'),
                      buildInfoCard(Icons.location_city, 'City',
                          widget.event.city.toString()),
                      buildInfoCard(
                          Icons.location_on, 'Location', widget.event.location),
                      buildInfoCard(Icons.description, 'Description',
                          '${widget.event.description} '),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Utils.navigateTo(context,
                                EventTicketScreen(eventId: widget.event.id));
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: PrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Text(
                                  'Event Tickets',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Positioned bottom action bar
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     color: Colors.white,
          //     // padding: const EdgeInsets.symmetric(vertical: 5.0),
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsets.only(left: 30, right: 30),
          //           child: SizedBox(
          //             width: double.infinity,
          //             child: ElevatedButton.icon(
          //               onPressed: () {
          //                 // Implement call functionality here
          //                 launchUrl('tel:${widget.event.phone}');
          //               },
          //               icon: const Icon(
          //                 Icons.phone,
          //                 color: Colors.white,
          //               ),
          //               label: const Text('Call Seller',
          //                   style: TextStyle(color: Colors.white)),
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: Colors.blue,
          //                 padding: const EdgeInsets.symmetric(vertical: 5.0),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             buildActionIcon(Icons.sms, "SMS", () {
          //               launchUrl('sms:${widget.event.phone}');
          //             }),
          //             buildActionIcon(Icons.chat, "Chat", () {
          //               // Implement chat functionality here
          //             }),
          //             buildActionIcon(FontAwesomeIcons.whatsapp, "WhatsApp",
          //                 () {
          //               launchUrl('https://wa.me/${widget.event.phone}');
          //             }),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

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

  Widget buildActionIcon(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.blue),
        ),
      ],
    );
  }

  // void launchUrl(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
