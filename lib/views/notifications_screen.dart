import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:instagram_clone_flutter/models/search_image.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone_flutter/secret.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<SearchImage> images = [];
  bool loading = false;

  Future<void> getImages() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    String url =
        "https://api.unsplash.com/search/photos?page=1&query=person&client_id=$unsplashApiKey";

    var response = await http.get(Uri.parse(url));
    // print(response.body);
    var jsonData = jsonDecode(response.body);
    print(jsonData["results"][0]);

    var imageList = jsonData["results"];

    imageList.forEach((image) {
      if (image["links"]["download"] != null &&
          image["urls"]["regular"] != null &&
          image["likes"] != null &&
          image["user"]["username"] != null) {
        SearchImage searchImage = SearchImage(
            description: image["description"] ?? "desc",
            downloadUrl: image["links"]["download"],
            imageUrl: image["urls"]["regular"],
            likes: image["likes"].toString(),
            username: image["user"]["username"]);

        // setState(() {
        images.add(searchImage);
        // });
        print(images[0].imageUrl);
      }
    });
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

//   void loadImages() async {
//     await getImages();
//     if (this.mounted) {
//   setState(() {
//     loading = false;
//   });
// }
  // }

  @override
  void initState() {
    getImages();
    super.initState();
    // loadImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text("Activity"),
        ),
        body: loading
            ? circularProgressIndicator
            : ListView.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: FadeIn(
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(images[index].imageUrl))),
                    title: Text(images[index].username),
                    subtitle: const Text("Liked your post"),
                    trailing: Image.network(
                      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NDN8fHBlcnNvbnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ));
  }
}
