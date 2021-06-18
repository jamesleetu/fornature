import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fornature/components/custom_card.dart';
import 'package:fornature/components/custom_image.dart';
import 'package:fornature/models/post.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/pages/profile.dart';
import 'package:fornature/screens/comment.dart';
import 'package:fornature/screens/view_image.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPost extends StatelessWidget {
  final PostModel post;

  UserPost({this.post});
  final DateTime timestamp = DateTime.now();

  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: null,
      borderRadius: BorderRadius.circular(10.0),
      child: OpenContainer(
        openBuilder: (BuildContext context, VoidCallback _) {
          return Comments(post: post);
        },
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onClosed: (v) {},
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    child: CustomImage(
                      imageUrl: post?.mediaUrl ?? '',
                      height: MediaQuery.of(context).size.width - 10.0,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 35.0,
                            height: 35.0,
                            child: buildLikeButton(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (_) => Comments(post: post),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, top: 3.0),
                              child: Icon(
                                CupertinoIcons.chat_bubble,
                                size: 20.0,
                              ),
                            ),
                          ),
                          Flexible(
                            child: StreamBuilder(
                              stream: likesRef
                                  .where('postId', isEqualTo: post.postId)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  QuerySnapshot snap = snapshot.data;
                                  List<DocumentSnapshot> docs = snap.docs;
                                  return buildLikesCount(
                                      context, docs?.length ?? 0);
                                } else {
                                  return buildLikesCount(context, 0);
                                }
                              },
                            ),
                          ),
                          StreamBuilder(
                            stream: commentRef
                                .doc(post.postId)
                                .collection("comments")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                QuerySnapshot snap = snapshot.data;
                                List<DocumentSnapshot> docs = snap.docs;
                                return buildCommentsCount(
                                    context, docs?.length ?? 0);
                              } else {
                                return buildCommentsCount(context, 0);
                              }
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: post.description != null &&
                            post.description.toString().isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            '${post.description}',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 3.0, bottom: 20.0),
                        child: Text(
                            timeago.format(post.timestamp.toDate(),
                                locale: 'ko'),
                            style: TextStyle(fontSize: 9.0)),
                      ),
                    ],
                  )
                ],
              ),
              buildUser(context),
            ],
          );
        },
      ),
    );
  }

  buildLikeButton() {
    return StreamBuilder(
      stream: likesRef
          .where('postId', isEqualTo: post.postId)
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
                  'postId': post.postId,
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
                    size: 22.0,
                  )
                : Icon(
                    CupertinoIcons.heart_fill,
                    color: Colors.red,
                    size: 22.0,
                  ),
          );
        }
        return Container();
      },
    );
  }

  addLikesToNotification() async {
    bool isNotMe = currentUserId() != post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data());
      notificationRef
          .doc(post.ownerId)
          .collection('notifications')
          .doc(post.postId)
          .set({
        "type": "like",
        "username": user.username,
        "userId": currentUserId(),
        "userDp": user.photoUrl,
        "postId": post.postId,
        "mediaUrl": post.mediaUrl,
        "timestamp": timestamp,
      });
    }
  }

  removeLikeFromNotification() async {
    bool isNotMe = currentUserId() != post.ownerId;

    if (isNotMe) {
      DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
      user = UserModel.fromJson(doc.data());
      notificationRef
          .doc(post.ownerId)
          .collection('notifications')
          .doc(post.postId)
          .get()
          .then((doc) => {
                if (doc.exists) {doc.reference.delete()}
              });
    }
  }

  buildLikesCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        '좋아요 $count개',
        style: TextStyle(
          fontSize: 12.0,
        ),
      ),
    );
  }

  buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        '댓글 $count개',
        style: TextStyle(
          fontSize: 12.0,
        ),
      ),
    );
  }

  buildUser(BuildContext context) {
    bool isMe = currentUserId() == post.ownerId;
    return StreamBuilder(
      stream: usersRef.doc(post.ownerId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot snap = snapshot.data;
          UserModel user = UserModel.fromJson(snap.data());
          return Visibility(
            visible: !isMe,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: GestureDetector(
                  onTap: () => showProfile(context, profileId: user?.id),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        user.photoUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Color(0xff4D4D4D),
                                backgroundImage:
                                    CachedNetworkImageProvider(user.photoUrl),
                              )
                            : CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Color(0xff4D4D4D),
                              ),
                        SizedBox(width: 10.0),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${post.username}',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              '${post.location == null ? '' : post.location}',
                              style: TextStyle(
                                fontSize: 9.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => Profile(profileId: profileId),
      ),
    );
  }
}
