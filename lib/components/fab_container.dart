import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fornature/pages/kakao.dart';
import 'package:fornature/pages/qrcode.dart';
import 'package:fornature/posts/create_post.dart';

class FabContainer extends StatelessWidget {
  final Widget page;
  final IconData icon;
  final bool mini;

  FabContainer({@required this.page, @required this.icon, this.mini = false});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return page;
      },
      closedElevation: 4.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(56 / 2),
        ),
      ),
      closedColor: Colors.white,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            chooseUpload(context);
          },
          mini: mini,
        );
      },
    );
  }

  chooseUpload(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
                child: Text(
                  '선택하기',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  CupertinoIcons.money_dollar_circle,
                  size: 25.0,
                ),
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Text('카카오페이로 결제'),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => KakaoAPI()));
                },
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.qrcode_viewfinder,
                  size: 25.0,
                ),
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Text('QR 코드 스캔'),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (_) => QrcodeScanner()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
