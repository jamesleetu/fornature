import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/services/services.dart';
import 'package:fornature/utils/firebase.dart';

class UserService extends Service {
  String currentUid() {
    return firebaseAuth.currentUser.uid;
  }

  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

  updateProfile({File image, String username, String bio}) async {
    DocumentSnapshot doc = await usersRef.doc(currentUid()).get();
    var users = UserModel.fromJson(doc.data());
    users?.username = username;
    users?.bio = bio;
    if (image != null) {
      users?.photoUrl = await uploadImage(profilePic, image);
    }
    await usersRef.doc(currentUid()).update({
      'username': username,
      'bio': bio,
      "photoUrl": users?.photoUrl ?? '',
    });

    return true;
  }
}
