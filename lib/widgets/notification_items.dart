import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fornature/models/notification.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fornature/widgets/indicators.dart';

class ActivityItems extends StatefulWidget {
  final ActivityModel activity;

  ActivityItems({this.activity});

  @override
  _ActivityItemsState createState() => _ActivityItemsState();
}

class _ActivityItemsState extends State<ActivityItems> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey("${widget.activity}"),
      background: stackBehindDismiss(),
      direction: DismissDirection.endToStart,
      onDismissed: (v) {
        delete();
      },
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            // onTap: () {
            //   Navigator.of(context).push(CupertinoPageRoute(
            //     builder: (_) => ViewActivityDetails(activity: widget.activity),
            //   ));
            // },
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(widget.activity.userDp),
            ),
            title: RichText(
              overflow: TextOverflow.clip,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
                children: [
                  TextSpan(
                    text: '${widget.activity.username} ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  TextSpan(
                    text: buildTextConfiguration(),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            subtitle: Text(
              timeago.format(widget.activity.timestamp.toDate(), locale: 'ko'),
              textScaleFactor: 0.9,
            ),
            trailing: previewConfiguration(),
          ),
          Divider(height: 5.0),
        ],
      ),
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(
        CupertinoIcons.delete,
        color: Colors.white,
      ),
    );
  }

  delete() {
    notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .doc(widget.activity.postId) // 값이 안 맞는 경우가 생김.. 이 경우 delete 못 함
        .get()
        .then((doc) => {
              if (doc.exists)
                {
                  doc.reference.delete(),
                }
            });
  }

  previewConfiguration() {
    if (widget.activity.type == "like" || widget.activity.type == "comment") {
      return buildPreviewImage();
    } else {
      return Text('');
    }
  }

  buildTextConfiguration() {
    if (widget.activity.type == "like") {
      return "님이 회원님의 사진을 좋아합니다.";
    } else if (widget.activity.type == "follow") {
      return "님이 회원님을 팔로우합니다.";
    } else if (widget.activity.type == "comment") {
      return "님이 댓글을 남겼습니다. \"${widget.activity.commentData}\"";
    } else {
      return "오류: 알 수 없는 활동 '${widget.activity.type}'";
    }
  }

  buildPreviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: CachedNetworkImage(
        imageUrl: widget.activity.mediaUrl,
        placeholder: (context, url) {
          return circularProgress(context);
        },
        errorWidget: (context, url, error) {
          return Icon(Icons.error);
        },
        height: 45.0,
        fit: BoxFit.cover,
        width: 45.0,
      ),
    );
  }
}
