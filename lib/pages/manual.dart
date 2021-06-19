import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fornature/screens/view_manual.dart';

class Manual extends StatefulWidget {
  @override
  _ManualState createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Feather.x),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('매뉴얼'),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ViewManual1(),
                ),
              ),
              child: Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Text(
                          '환경부 x 국가환경교육센터',
                          style: TextStyle(
                            fontFamily: 'StrongArmy',
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Text(
                        '제로웨이스트 챌린지 매뉴얼',
                        style: TextStyle(
                          fontFamily: 'StrongArmy',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ViewManual2(),
                ),
              ),
              child: Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Text(
                          '환경부',
                          style: TextStyle(
                            fontFamily: 'StrongArmy',
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Text(
                        '플라스틱 다이어트 매뉴얼',
                        style: TextStyle(
                          fontFamily: 'StrongArmy',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ViewManual3(),
                ),
              ),
              child: Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Text(
                          '숲과나눔 x 쓰레기덕질',
                          style: TextStyle(
                            fontFamily: 'StrongArmy',
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Text(
                        '컵줍깅 매뉴얼',
                        style: TextStyle(
                          fontFamily: 'StrongArmy',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ViewManual4(),
                ),
              ),
              child: Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8.0),
                        child: Text(
                          '현대제철과 함께하는',
                          style: TextStyle(
                            fontFamily: 'StrongArmy',
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Text(
                        '#제로웨이스트챌린지',
                        style: TextStyle(
                          fontFamily: 'StrongArmy',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
