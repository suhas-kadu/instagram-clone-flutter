import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone_flutter/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";

  int _page = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void onIconTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        onPageChanged: onPageChanged,
        // scrollBehavior: ScrollBehavior(),
        scrollDirection: Axis.horizontal,
      controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: screens.length,
        itemBuilder: (context, index) {
        return screens[_page];
      }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0.0,
        onTap: onIconTapped,
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
              tooltip: "Home",
              icon: FaIcon(
                FontAwesomeIcons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              tooltip: "Search",
              icon: FaIcon(
                FontAwesomeIcons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
            tooltip: "Add a Post",
            icon: FaIcon(
              FontAwesomeIcons.plusSquare,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
              tooltip: "Notifications",
              icon: FaIcon(
                FontAwesomeIcons.bell,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBackgroundColor),
          BottomNavigationBarItem(
              tooltip: "Profile",
              icon: FaIcon(
                FontAwesomeIcons.userCircle,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBackgroundColor),
        ],
      ),
    );
  }
}
