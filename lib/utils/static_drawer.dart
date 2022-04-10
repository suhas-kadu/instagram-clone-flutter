import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_flutter/resources/auth_methods.dart';
import 'package:instagram_clone_flutter/views/login_screen.dart';

class StaticDrawer extends StatelessWidget {
  const StaticDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const ListTile(
            leading: Icon(
              Icons.settings,
              size: 28,
            ),
            title: Text("Settings"),
          ),
          const ListTile(
            leading: Icon(
              Icons.archive,
              size: 28,
            ),
            title: Text("Archive"),
          ),
          const ListTile(
            leading: Icon(
              Icons.history,
              size: 28,
            ),
            title: Text("Your Activity"),
          ),
          const ListTile(
            leading: Icon(
              Icons.qr_code,
              size: 28,
            ),
            title: Text("QR code"),
          ),
          const ListTile(
            leading: Icon(
              Icons.bookmark_outline,
              size: 28,
            ),
            title: Text("Save"),
          ),
          const ListTile(
            leading: Icon(
              Icons.list,
              size: 28,
            ),
            title: Text("Close Friends"),
            trailing: Icon(
              Icons.star,
              size: 24,
              color: Colors.orangeAccent,
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.star_border,
              size: 28,
            ),
            title: Text("Favorites"),
          ),
          const ListTile(
            leading: Icon(
              FontAwesomeIcons.userPlus,
              size: 20,
            ),
            title: Text("Discover People"),
          ),
          ListTile(
            onTap: () async {
              await AuthMethods().signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            leading: const Icon(
              Icons.logout,
              size: 28,
            ),
            title: const Text("Sign out"),
          ),
        ],
      ),
    );
  }
}
