import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone_flutter/models/search_image.dart';
import 'package:instagram_clone_flutter/secret.dart';
import 'package:instagram_clone_flutter/widgets/story.dart';

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
    if (mounted) {
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
        ? const Center(child: LinearProgressIndicator())
        : Container(
            height: 100,
            alignment: Alignment.center,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return Story(
                  imageUrl: images[index].imageUrl,
                  username: images[index].username,
                );
              },
            ),
          );
  }
}
