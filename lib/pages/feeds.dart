import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fornature/components/stream_builder_wrapper.dart';
import 'package:fornature/models/post.dart';
import 'package:fornature/pages/notification.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/widgets/userpost.dart';

class Timeline extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          '초행길',
        ),
        centerTitle: true,
        actions: [
          // notifications
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => Activities()));
                },
                child: Icon(
                  CupertinoIcons.bell,
                  size: 22.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          StreamBuilderWrapper(
            shrinkWrap: true,
            stream: postRef.orderBy('timestamp', descending: true).snapshots(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, DocumentSnapshot snapshot) {
              internetChecker();
              PostModel posts = PostModel.fromJson(snapshot.data());
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: UserPost(post: posts),
              );
            },
          ),
        ],
      ),
    );
  }

  internetChecker() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == false) {
      showInSnackBar('No Internet Connecton');
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
