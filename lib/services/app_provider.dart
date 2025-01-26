import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/provider/auth_provider.dart';
import 'package:ticket_wise_admin/provider/category_provider.dart';
import 'package:ticket_wise_admin/provider/city_provider.dart';
import 'package:ticket_wise_admin/provider/date_picker_provider.dart';
import 'package:ticket_wise_admin/provider/file_upload_provider.dart';
import 'package:ticket_wise_admin/provider/image_picker_provider.dart';
import 'package:ticket_wise_admin/provider/ticket_provider.dart';
import 'package:ticket_wise_admin/provider/event_provider.dart';
import 'package:ticket_wise_admin/provider/video_picker_provider.dart';
import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
          ChangeNotifierProvider(create: (context) => VideoPickerProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => FileUploadProvider()),
          ChangeNotifierProvider(create: (context) => EventProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => TicketProvider()),
          ChangeNotifierProvider(create: (context) => CityProvider()),
          ChangeNotifierProvider(create: (context) => DatePickerProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child: child,
      );
}
