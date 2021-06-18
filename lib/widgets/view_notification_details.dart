/* 알림 누르면 해당하는 유저의 프로필 / 게시물 보여주는 기능*/
/* 유저 프로필 보여주는 기능에서 오류 발생 */

/*
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fornature/models/notification.dart';
import 'package:fornature/pages/profile.dart';
import 'package:fornature/widgets/indicators.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewActivityDetails extends StatefulWidget {
  final ActivityModel activity;

  ViewActivityDetails({this.activity});

  @override
  _ViewActivityDetailsState createState() => _ViewActivityDetailsState();
}

class _ViewActivityDetailsState extends State<ViewActivityDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.keyboard_backspace),
        ),
      ),
      body: ListView(
        children: [
          buildImage(context),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          Profile(profileId: widget.activity.userId),
                    ));
              },
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(widget.activity.userDp),
              ),
            ),
            title: Text(
              widget.activity.username,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Row(
              children: [
                Icon(Feather.clock, size: 13.0),
                SizedBox(width: 3.0),
                Text(
                  timeago.format(widget.activity.timestamp.toDate(),
                      locale: 'ko'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              widget.activity?.commentData ?? "",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          imageUrl: widget.activity.mediaUrl,
          placeholder: (context, url) {
            return circularProgress(context);
          },
          errorWidget: (context, url, error) {
            return Icon(Icons.error);
          },
          height: 400.0,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
*/