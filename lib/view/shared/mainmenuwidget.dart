import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/serverconfig.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/customerscreen.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/ownerscreen.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/profilescreen.dart';
import 'package:lab_asg_2_homestay_raya/view/shared/EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  File? _image;
  var pathAsset = "assets/images/profile_icon.jpg";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      backgroundColor: Colors.brown[50],
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email.toString()),
            accountName: Text(widget.user.name.toString()),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      "${ServerConfig.SERVER}/homestayraya/assets/images/profileImages/${widget.user.id}.png",
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported,
                    size: 128,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('All Homestays'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: CustomerScreen(user: widget.user),
                      enterPage: CustomerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('My Homestay'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: CustomerScreen(user: widget.user),
                      enterPage: OwnerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: CustomerScreen(user: widget.user),
                      enterPage: ProfileScreen(user: widget.user)));
            },
          )
        ],
      ),
    );
  }
}
