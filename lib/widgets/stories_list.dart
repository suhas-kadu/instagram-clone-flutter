import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone_flutter/models/search_image.dart';
import 'package:instagram_clone_flutter/secret.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';

class StoriesList extends StatefulWidget {
  const StoriesList({Key? key}) : super(key: key);

  @override
  State<StoriesList> createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  List<SearchImage> images = [];
  bool loading = false;
  Future<void> getImages() async {
    if (this.mounted) {
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
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? circularProgressIndicator
        : Container(
            height: 100,
            alignment: Alignment.center,
            // margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      FadeIn(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 2),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(images[index].imageUrl),
                          ),
                        ),
                      ),
                      Text(images[index].username)
                    ],
                  ),
                );
              },
            ),
          );
  }
}
