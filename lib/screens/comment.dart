import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fornature/components/stream_comments_wrapper.dart';
import 'package:fornature/models/comments.dart';
import 'package:fornature/models/post.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/widgets/cached_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final PostModel post;

  Comments({this.post});

  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  UserModel user;

  final DateTime timestamp = DateTime.now();
  TextEditingController commentsTEC = TextEditingController();

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_backspace,
          ),
        ),
        centerTitle: true,
        title: Text('댓글'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: buildFullPost(),
                  ),
                  Divider(thickness: 0.5),
                  buildComments(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                constraints: BoxConstraints(
                  maxHeight: 190.0,
                ),
                // write comment section
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 10.0),
                      child: Container(
                        height: 35.0,
                        width: MediaQuery.of(context).size.width - 60,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Center(
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              controller: commentsTEC,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              onEditingComplete: addComments,
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 5.0, bottom: 13.5),
                                hintText: "댓글 달기...",
                                hintStyle: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: addComments,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          CupertinoIcons.check_mark,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildFullPost() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // photo
        Container(
          height: MediaQuery.of(context).size.width - 150.0,
          width: MediaQuery.of(context).size.width - 20.0,
          child: cachedNetworkImage(widget.post.mediaUrl),
        ),
        // description
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 35.0,
              height: 35.0,
              child: buildLikeButton(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.post.description,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 10.0),
              child: Text(
                  timeago.format(widget.post.timestamp.toDate(), locale: 'ko'),
                  style: TextStyle(fontSize: 9.0)),
            ),
          ],
        ),
      ],
    );
  }

  addComments() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    user = UserModel.fromJson(doc.data());
    commentRef.doc(widget.post.postId).collection("comments").add({
      "username": user.username,
      "comment": commentsTEC.text,
      "timestamp": timestamp,
      "userDp": user.photoUrl,
      "userId": user.id,
    });

    bool isNotMe = widget.post.ownerId != currentUserId();
    if (isNotMe) {
      notificationRef.doc(widget.post.ownerId).collection('notifications').add({
        "type": "comment",
        "commentData": commentsTEC.text,
        "username": user.username,
        "userId": user.id,
        "userDp": user.photoUrl,
        "postId": widget.post.postId,
        "mediaUrl": widget.post.mediaUrl,
        "timestamp": timestamp,
      });
    }
    commentsTEC.clear();
  }

  buildComments() {
    return CommentsStreamWrapper(
      shrinkWrap: true,
      stream: commentRef
          .doc(widget.post.postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        CommentModel comments = CommentModel.fromJson(snapshot.data());
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0, bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 14.0,
                backgroundImage: NetworkImage(comments.userDp),
              ),
              SizedBox(width: 8.0),
              Text(
                comments.username,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 8.0),
              Text(
                comments.comment,
              ),
              Spacer(),
              Text(
                timeago.format(comments.timestamp.toDate(), locale: 'ko'),
                style: TextStyle(fontSize: 9.0),
              ),
            ],
          ),
        );
      },
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: likesRef
          .where('postId', isEqualTo: widget.post.postId)
          .where('userId', isEqualTo: currentUserId())
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> docs = snapshot?.data?.docs ?? [];
          return IconButton(
            onPressed: () {
              if (docs.isEmpty) {
                likesRef.add({
                  'userId': currentUserId(),
                  'postId': widget.post.postId,
                  'dateCreated': Timestamp.now(),
                });
                addLikesToNotification();
              } else {
                likesRef.doc(docs[0].id).delete();

                removeLikeFromNotification();
              }
            },
            icon: docs.isEmpty
                ? Icon(
                    CupertinoIcons.heart,
                  )
                : Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                  ),
          );
        }
        return Container();
      },
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: Text(
        '$count likes',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }

  addLikesToNotification() async {
    bool isNotMe = currentUserId() != widget.post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data());
      notificationRef
          .doc(widget.post.ownerId)
          .collection('notifications')
          .doc(widget.post.postId)
          .set({
        "type": "like",
        "username": user.username,
        "userId": currentUserId(),
        "userDp": user.photoUrl,
        "postId": widget.post.postId,
        "mediaUrl": widget.post.mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromNotification() async {
    bool isNotMe = currentUserId() != widget.post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data());
      notificationRef
          .doc(widget.post.ownerId)
          .collection('notifications')
          .doc(widget.post.postId)
          .get()
          .then((doc) => {
                if (doc.exists) {doc.reference.delete()}
              });
    }
  }
}
