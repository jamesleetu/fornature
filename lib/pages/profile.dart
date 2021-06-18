import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fornature/auth/register/register.dart';
import 'package:fornature/components/stream_grid_wrapper.dart';
import 'package:fornature/models/post.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/screens/edit_profile.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/widgets/post_tiles.dart';

class Profile extends StatefulWidget {
  final profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;
  bool isLoading = false;
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  int visitCount = 0;
  bool isFollowing = false;
  bool isVisited = false;
  UserModel users;
  final DateTime timestamp = DateTime.now();
  ScrollController controller = ScrollController();

  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
    checkIfVisited();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  checkIfVisited() async {
    DocumentSnapshot doc = await visithistoryRef.doc(widget.profileId).get();
    setState(() {
      isVisited = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('프로필'),
        actions: [
          widget.profileId == firebaseAuth.currentUser.uid
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: GestureDetector(
                      onTap: () {
                        firebaseAuth.signOut();
                        Navigator.of(context).push(
                            CupertinoPageRoute(builder: (_) => Register()));
                      },
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            pinned: true,
            floating: false,
            toolbarHeight: 5.0,
            collapsedHeight: 6.0,
            expandedHeight: 210.0,
            flexibleSpace: FlexibleSpaceBar(
              background: StreamBuilder(
                stream: usersRef.doc(widget.profileId).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  /* profile pic */
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(snapshot.data.data());
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user?.photoUrl),
                                radius: 50.0,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            /* username */
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.0),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user?.username,
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w900),
                                          maxLines: null,
                                        ),
                                        SizedBox(height: 5.0),
                                        /* bio */
                                        Text(
                                          user?.bio,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: null,
                                        ),
                                        SizedBox(height: 5.0),
                                        /* email account */
                                        Text(
                                          user?.email,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        /* POSTS, FOLLOWERS, FOLLOWING */
                        SizedBox(height: 15.0),
                        Center(
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width - 15.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  width: 50.0,
                                  child: StreamBuilder(
                                    stream: postRef
                                        .where('ownerId',
                                            isEqualTo: widget.profileId)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        QuerySnapshot snap = snapshot.data;
                                        List<DocumentSnapshot> docs = snap.docs;
                                        return buildCount(
                                            "게시물", docs?.length ?? 0);
                                      } else {
                                        return buildCount("게시물", 0);
                                      }
                                    },
                                  ),
                                ),
                                /* line between posts and followers */
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: 50.0,
                                  child: StreamBuilder(
                                    stream: followersRef
                                        .doc(widget.profileId)
                                        .collection('userFollowers')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        QuerySnapshot snap = snapshot.data;
                                        List<DocumentSnapshot> docs = snap.docs;
                                        return buildCount(
                                            "팔로워", docs?.length ?? 0);
                                      } else {
                                        return buildCount("팔로워", 0);
                                      }
                                    },
                                  ),
                                ),
                                /* line between followers and following */
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: 50.0,
                                  child: StreamBuilder(
                                    stream: followingRef
                                        .doc(widget.profileId)
                                        .collection('userFollowing')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        QuerySnapshot snap = snapshot.data;
                                        List<DocumentSnapshot> docs = snap.docs;
                                        return buildCount(
                                            "팔로잉", docs?.length ?? 0);
                                      } else {
                                        return buildCount("팔로잉", 0);
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 0.3,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: 50.0,
                                  child: StreamBuilder(
                                    stream: visithistoryRef
                                        .doc(widget.profileId)
                                        .collection('visithistory')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        QuerySnapshot snap = snapshot.data;
                                        List<DocumentSnapshot> docs = snap.docs;
                                        return buildCount(
                                            "방문기록", docs?.length ?? 0);
                                      } else {
                                        return buildCount("방문기록", 0);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 3.0),
                        buildProfileButton(user),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index > 0) return null;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            '모든 게시물',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    buildGridPost()
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  buildCount(String label, int count) {
    return Column(
      children: <Widget>[
        /* count text style */
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 4.0),
        /* category text style */
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  buildProfileButton(user) {
    //if isMe then display "edit profile"
    bool isMe = widget.profileId == firebaseAuth.currentUser.uid;
    if (isMe) {
      return buildButton(
          text: "프로필 편집",
          function: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => EditProfile(
                  user: user,
                ),
              ),
            );
          });
      //if you are already following the user then "unfollow"
    } else if (isFollowing) {
      return buildButton(
        text: "팔로우 취소",
        function: handleUnfollow,
      );
      //if you are not following the user then "follow"
    } else if (!isFollowing) {
      return buildButton(
        text: "팔로우",
        function: handleFollow,
      );
    }
  }

/* Edit Profile Button */
  buildButton({String text, Function function}) {
    return Center(
      child: GestureDetector(
        onTap: function,
        child: Container(
          height: 30.0,
          width: MediaQuery.of(context).size.width - 15.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            border: Border.all(width: 0.3, color: Colors.black),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  handleUnfollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data());
    setState(() {
      isFollowing = false;
    });
    //remove follower
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove following
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //remove from notifications feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollow() async {
    DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
    users = UserModel.fromJson(doc.data());
    setState(() {
      isFollowing = true;
    });
    //updates the followers collection of the followed user
    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId())
        .set({});
    //updates the following collection of the currentUser
    followingRef
        .doc(currentUserId())
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
    //update the notification feeds
    notificationRef
        .doc(widget.profileId)
        .collection('notifications')
        .doc(currentUserId())
        .set({
      "type": "follow",
      "ownerId": widget.profileId,
      "username": users.username,
      "userId": users.id,
      "userDp": users.photoUrl,
      "timestamp": timestamp,
    });
  }

  buildGridPost() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: StreamGridWrapper(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        stream: postRef
            .where('ownerId', isEqualTo: widget.profileId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, DocumentSnapshot snapshot) {
          PostModel posts = PostModel.fromJson(snapshot.data());
          return PostTile(
            post: posts,
          );
        },
      ),
    );
  }
}
