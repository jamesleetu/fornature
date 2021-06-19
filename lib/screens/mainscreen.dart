import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fornature/components/fab_container.dart';
import 'package:fornature/pages/base_map.dart';
import 'package:fornature/pages/profile.dart';
import 'package:fornature/pages/search.dart';
import 'package:fornature/pages/feeds.dart';

import 'package:fornature/utils/firebase.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Map',
      'icon': CupertinoIcons.map,
      'page': BaseMapPage(),
      'index': 0,
    },
    {
      'title': 'Community',
      'icon': CupertinoIcons.person_2_fill,
      'page': Timeline(),
      'index': 1,
    },
    {
      'title': 'unsee',
      'icon': Feather.plus_circle,
      'page': Text('nes'),
      'index': 2,
    },
    {
      'title': 'Search',
      'icon': CupertinoIcons.search,
      'page': Search(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': CupertinoIcons.person,
      'page': Profile(profileId: firebaseAuth.currentUser.uid),
      'index': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_page]['page'],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            for (Map item in pages)
              item['index'] == 2
                  ? buildFab()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: IconButton(
                        icon: Icon(
                          item['icon'],
                          color: item['index'] != _page
                              ? Colors.grey
                              : Theme.of(context).accentColor,
                          size: 25.0,
                        ),
                        onPressed: () => navigationTapped(item['index']),
                      ),
                    ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  buildFab() {
    return Container(
      color: Colors.white,
      height: 45.0,
      width: 45.0,
      // ignore: missing_required_param
      child: FabContainer(
        icon: Feather.plus,
        mini: true,
      ),
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}
