import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class KakaoAPI extends StatefulWidget {
  @override
  _KakaoAPIState createState() => _KakaoAPIState();
}

class _KakaoAPIState extends State<KakaoAPI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Feather.x),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          title: Text('Kakao API'),
          centerTitle: true,
        ),
        body: Center(
          child: Text("KAKAO API"),
        ));
  }
}
