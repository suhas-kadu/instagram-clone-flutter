import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/models/user.dart' as model;
import 'package:instagram_clone_flutter/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUsername();
  }

// void getUsername() async {
//   DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

//   print("snap ${snap.data()}");

// setState(() {
//   username = (snap.data() as Map<String, dynamic>)['username'];
// });

// }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    print("myuser : ${user.username}");
    return CircularProgressIndicator.adaptive() : Scaffold(
      body: Center(child: Text(user.username)),
    );
  }
}
