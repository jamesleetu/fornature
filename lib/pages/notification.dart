import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fornature/components/notification_stream_wrapper.dart';
import 'package:fornature/models/notification.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/widgets/notification_items.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

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
        title: Text('알림'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () => deleteAllItems(),
              child: Text(
                '지우기',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          getActivities(),
        ],
      ),
    );
  }

  getActivities() {
    return ActivityStreamWrapper(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        stream: notificationRef
            .doc(currentUserId())
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, DocumentSnapshot snapshot) {
          ActivityModel activities = ActivityModel.fromJson(snapshot.data());
          return ActivityItems(
            activity: activities,
          );
        });
  }

  deleteAllItems() async {
// delete all notifications associated with the authenticated user
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .get();
    notificationsSnap.docs.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
}
