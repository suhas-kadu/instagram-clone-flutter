import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';
import 'package:instagram_clone_flutter/views/profile_screen.dart';
import 'package:instagram_clone_flutter/views/search_feed_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool showUsers = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Padding(
              padding:
                  const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: "Search for users",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder()),
                  onChanged: (String s) {
                    if (s.isEmpty) {
                      setState(() {
                        showUsers = false;
                      });
                    }
                  },
                  onFieldSubmitted: (String s) {
                    setState(() {
                      showUsers = true;
                    });

                    print(s);
                  },
                ),
              ),
            ),
            bottom: const TabBar(
                padding: EdgeInsets.symmetric(horizontal: 24),
                indicatorSize: TabBarIndicatorSize.tab,
                isScrollable: true,
                tabs: [
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    text: "Art",
                  ),
                  Tab(
                    text: "Design",
                  ),
                  Tab(
                    text: "Wildlife",
                  ),
                  Tab(
                    text: "Sports",
                  ),
                  Tab(
                    text: "Shopping",
                  ),
                ]),
          ),
          body: showUsers
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .where(
                        'username',
                        isGreaterThanOrEqualTo: _searchController.text,
                      )
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgressIndicator;
                    }

                    return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                        uid: (snapshot.data! as dynamic)
                                            .docs[index]['uid']))),
                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      (snapshot.data as dynamic).docs[index]
                                          ["photoUrl"]),
                                ),
                                title: Text((snapshot.data as dynamic)
                                    .docs[index]["username"])));
                      },
                    );
                  })
              : TabBarView(
                  children: [
                    SearchFeedScreen(keyword: "art"),
                    SearchFeedScreen(keyword: "Design"),
                    SearchFeedScreen(keyword: "wildlife"),
                    SearchFeedScreen(keyword: "sports"),
                    SearchFeedScreen(keyword: "shopping"),
                  ],
                )),
    );
  }
}
