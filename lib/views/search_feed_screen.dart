import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone_flutter/models/search_image.dart';
import 'package:instagram_clone_flutter/secret.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchFeedScreen extends StatefulWidget {
  final String keyword;
  SearchFeedScreen({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchFeedScreen> createState() => _SearchFeedScreenState();
}

class _SearchFeedScreenState extends State<SearchFeedScreen> {
  List<SearchImage> images = [];
  bool loading = true;
  bool showPost = false;

  String loadImageUrl = "";
  String username = "";

  Future<void> getImages() async {
    String url =
        "https://api.unsplash.com/search/photos?page=1&query=${widget.keyword}&client_id=$unsplashApiKey";

    var response = await http.get(Uri.parse(url));
    // print(response.body);
    var jsonData = jsonDecode(response.body);
    print(jsonData["results"][0]);

    var imageList = jsonData["results"];

    imageList.forEach((image) {
      SearchImage searchImage = SearchImage(
          description: image["description"] ?? image["alt_description"],
          downloadUrl: image["links"]["download"],
          imageUrl: image["urls"]["regular"],
          likes: image["likes"].toString(),
          username: image["user"]["username"]);

      setState(() {
        images.add(searchImage);
      });
    });

    print(images[0].imageUrl);
  }

  void loadImages() async {
    await getImages();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? circularProgressIndicator
        : Stack(
            alignment: Alignment.center,
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        loadImageUrl = images[index].imageUrl;
                        username = images[index].username;
                        showPost = true;
                      });
                    },
                    onLongPressEnd: (x) {
                      setState(() {
                        showPost = false;
                      });
                    },
                    child: CachedNetworkImage(
                      // height: MediaQuery.of(context).size.height / 2,
                      // width: MediaQuery.of(context).size.width / 3,
                      fit: BoxFit.fill,
                      imageUrl: images[index].imageUrl,
                    ),
                  );
                },
              ),
              showPost
                  ? FadeIn(
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: MediaQuery.of(context).size.width - 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 48,
                              child: ListTile(
                                leading:
                                    const FaIcon(FontAwesomeIcons.userCircle),
                                title: Text(username),
                              ),
                            ),
                            FadeInImage(
                              fadeInCurve: Curves.easeOut,
                              image: NetworkImage(
                                loadImageUrl,
                              ),
                              placeholder: MemoryImage(kTransparentImage),
                              height:
                                  MediaQuery.of(context).size.height * 0.65 -
                                      100,
                              width: MediaQuery.of(context).size.width - 32,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 48,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite_outline,
                                      size: 26,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const FaIcon(
                                      FontAwesomeIcons.userCircle,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Transform.rotate(
                                        angle: -pi / 4,
                                        child: const Icon(
                                          Icons.send,
                                          size: 26,
                                        ),
                                      )),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_vert,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          );
  }
}
