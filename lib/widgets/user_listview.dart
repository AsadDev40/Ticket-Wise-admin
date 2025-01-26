import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticket_wise_admin/Model/user_model.dart';
import 'package:ticket_wise_admin/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:ticket_wise_admin/screens/user_detail_screen.dart';
import 'package:ticket_wise_admin/utils/utils.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';

class UserviewList extends StatelessWidget {
  final List<UserModel> users;

  const UserviewList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<AuthProvider>(context);
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
          onTap: () {
            Utils.navigateTo(context, UserDetailScreen(user: user));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Card(
                  color: PrimaryColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            userprovider.deleteUserDatatoFirestore(user.uid);
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
                          imageUrl: user.profileImage.toString(),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    title: Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
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
                                user.email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
