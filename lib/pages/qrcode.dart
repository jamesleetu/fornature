import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QrcodeScanner extends StatefulWidget {
  @override
  _QrcodeScannerState createState() => _QrcodeScannerState();
}

class _QrcodeScannerState extends State<QrcodeScanner> {
  Uint8List bytes = Uint8List(0);
  UserModel users;
  bool isvisitHistory = false;

  TextEditingController _outputController;
  currentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  @override
  initState() {
    super.initState();
    checkIfvisithistory();
  }

  checkIfvisithistory() async {
    DocumentSnapshot doc = await visithistoryRef
        .doc(currentUserId())
        .collection('visithistory')
        .doc(currentUserId())
        .get();
    setState(() {
      isvisitHistory = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Feather.x),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('QR 코드 스캔'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                  "매장에 비치된 QR코드를 스캔하여\n    자신의 방문을 기록해보세요!",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 50),
                this._buttonGroup(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buttonGroup(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: () async {
              bool snackbarflag = await _scan();
              SnackBar snackBar;
              if (snackbarflag == true) {
                snackBar = new SnackBar(
                    content: new Text('제로웨이스트 매장을 방문하여,\n방문 기록이 1회 추가되었습니다.'));
                Scaffold.of(context).showSnackBar(snackBar);
                handlevisithistory();
              } else {
                snackBar = new SnackBar(
                    content: new Text('해당 QR 코드가 아닙니다.\n다시 시도해주세요.'));
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            child: Container(
              width: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.0),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/qr.png'),
                    Divider(height: 10),
                    Text(
                      "방문 기록하기",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _scan() async {
    await Permission.camera.request();
    try {
      String barcode = await scanner.scan();
      if (barcode == null) {
        print('nothing return.');
        return false;
      } else {
        this._outputController.text = barcode;
        if (this._outputController.text == "chgodrlf") return true;
      }
      return false;
    } on FormatException {
      return false;
    }
  }

  handlevisithistory() async {
    var count;

    if (isvisitHistory == false) {
      count = 1;
      this.isvisitHistory = true;
    } else {
      await visithistoryRef
          .doc(currentUserId())
          .collection('visithistory')
          .doc(currentUserId())
          .get()
          .then((DocumentSnapshot ds) {
        count = ds.get('Count') + 1;
      });
      print(count);
    }

    await visithistoryRef
        .doc(currentUserId())
        .collection('visithistory')
        .doc(currentUserId())
        .set({
      'ID': currentUserId(),
      'Count': count,
    });
  }
}
