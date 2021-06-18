import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:image_picker/image_picker.dart';
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

    this._outputController = new TextEditingController();
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
        leading: IconButton(
          icon: Icon(Feather.x),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('QR 스캐너'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                TextField(
                  controller: this._outputController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.wrap_text),
                    hintText: 'QR 값이 표시됩니다.',
                    hintStyle: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                this._buttonGroup(context),
                SizedBox(height: 70),
                Expanded(
                  child: Text("제로 웨이스트 샵을 방문하여 자신의 방문 일지를 기록해 보세요!"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buttonGroup(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 120,
            child: InkWell(
              onTap: () async {
                bool snackbarflag = await _scan();
                SnackBar snackBar;
                if (snackbarflag == true) {
                  print("성공");
                  snackBar = new SnackBar(
                      content: new Text('제로웨이스트 매장을 방문하여, 1회 방문 기록이 추가되었습니다.'));
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  print("실패");
                  snackBar = new SnackBar(
                      content: new Text('해당 QR 코드가 아닙니다. 다시 시도해주세요'));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/images/qr.png'),
                    ),
                    Divider(height: 20),
                    Expanded(flex: 1, child: Text("Scan")),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 120,
            child: InkWell(
              onTap: () async {
                bool snackbarflag = await _scanPhoto();
                SnackBar snackBar;
                if (snackbarflag == true) {
                  print("성공");
                  snackBar = new SnackBar(
                      content: new Text('제로웨이스트 매장을 방문하여, 1회 방문 기록이 추가되었습니다.'));
                  Scaffold.of(context).showSnackBar(snackBar);
                  handlevisithistory();
                } else {
                  print("실패");
                  snackBar = new SnackBar(
                      content: new Text('해당 QR 코드가 아닙니다. 다시 시도해주세요'));
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/images/qr.png'),
                    ),
                    Divider(height: 20),
                    Expanded(flex: 1, child: Text("Scan Photo")),
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

  Future<bool> _scanPhoto() async {
    await Permission.storage.request();
    try {
      String barcode = await scanner.scanPhoto();
      if (barcode == null) return false;
      this._outputController.text = barcode;
      if (this._outputController.text == null)
        return false;
      else {
        if (this._outputController.text == "chgodrlf") return true;
      }
      return false;
    } on FormatException {
      return false;
    }
  }

  Future _scanBytes() async {
    File _image;
    final picker = ImagePicker();
    final file = await picker.getImage(source: ImageSource.camera);
    if (file == null) return;
    _image = File(file.path);
    Uint8List bytes = _image.readAsBytesSync();
    String barcode = await scanner.scanBytes(bytes);
    this._outputController.text = barcode;
  }

  handlevisithistory() async {
    //  DocumentSnapshot doc = await visithistoryRef.doc(currentUserId()).get();
    //   users = UserModel.fromJson(doc.data());
    // print(currentUserId());
    //  DocumentSnapshot doc = await visithistoryRef.doc(currentUserId()).get();
    if (isvisitHistory == false) {
      print("안뇽?");
      await visithistoryRef
          .doc(currentUserId())
          .collection('visithistory')
          .doc(currentUserId())
          .set({
        'ID': currentUserId(),
        'Count': 1,
      });
      this.isvisitHistory = true;
    } else {
      print("hihi");
      /* Future<DocumentSnapshot<Map<String, dynamic>>> count = visithistoryRef
          .doc(currentUserId())
          .collection('visithistory')
          .doc(currentUserId())*/
      var count;
      await visithistoryRef
          .doc(currentUserId())
          .collection('visithistory')
          .doc(currentUserId())
          .get()
          .then((DocumentSnapshot ds) {
        print(ds.get('Count'));
        count = ds.get('Count') + 1;
      });

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
}
