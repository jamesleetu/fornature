import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fornature/pages/manual.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:fornature/themes/light_color.dart';
import 'package:fornature/themes/theme.dart';
import 'package:fornature/widgets/title_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/pages/search_shop.dart';

List<DocumentSnapshot> shops = [];
List<DocumentSnapshot> filteredshops = [];

String placename;
double lat;
double long;
bool searched = false;

class BaseMapPage extends StatefulWidget {
  @override
  _BaseMapPageState createState() => _BaseMapPageState();
}

class _BaseMapPageState extends State<BaseMapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];
  bool detail = false;
  var cat = 0;

  /* variables for selected shop */
  List<int> _categor = [0, 1, 2, 3];
  List<String> _catstr = ["", "소분", "공방", "리필", "카페"];
  List<String> tmpcat;
  List<bool> tmpcatbool = [false, false, false, false];

  /* detail info */
  String address;
  String time;
  String homepage;
  String phone;

  double _value = 20000.0;
  String _label = '';
  TextEditingController searchController = TextEditingController();

  bool loading = true;
  bool searchflag = false;

  Position _currentPosition;

  getShops() async {
    QuerySnapshot snap = await shopsRef.get();
    List<DocumentSnapshot> doc = snap.docs;
    shops = doc;
    filteredshops = doc;
    setState(() {
      loading = false;
    });
  }

  removeFromList(index) {
    filteredshops.removeAt(index);
  }

  @override
  void initState() {
    getShops();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'assets/images/map/map-marker-icon.png',
        context: context,
      ).then((image) {
        Marker(
            markerId: 'id',
            position: LatLng(37.563600, 126.962370),
            captionText: "커스텀 아이콘",
            captionColor: Colors.indigo,
            captionTextSize: 20.0,
            alpha: 0.8,
            icon: image,
            anchor: AnchorPoint(0.5, 1),
            captionMinZoom: 10,
            width: 35,
            height: 35,
            onMarkerTab: _onMarkerTap);
        setState(() {});
      });
    });

    getPosition();

    FirebaseFirestore.instance.collection('shops').get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          _markers.add(Marker(
              markerId: _markers.length.toString(),
              position: LatLng(value.docs[i].data()['location'].latitude,
                  value.docs[i].data()['location'].longitude),
              width: 25,
              height: 35,
              captionText: value.docs[i].id,
              captionMinZoom: 15,
              onMarkerTab: _onMarkerTap));
          setState(() {});
        }
      }
    });
    super.initState();
  }

  getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    try {
      setState(() {
        _currentPosition = position;
        for (int i = 0; i < _markers.length; i++) {
          if (Geolocator.distanceBetween(
                  _currentPosition.latitude,
                  _currentPosition.longitude,
                  _markers[i].position.latitude,
                  _markers[i].position.longitude) >
              _value) {
            _markers.removeWhere((m) => m.markerId == _markers[i].markerId);
          }
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  MapType _mapType = MapType.Basic;
  LocationTrackingMode _trackingMode = LocationTrackingMode.Follow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: buildSearch(),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          NaverMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.569968415084, 126.93120094519),
              zoom: 17,
            ),
            onMapCreated: onMapCreated,
            mapType: _mapType,
            initLocationTrackingMode: _trackingMode,
            locationButtonEnable: true,
            indoorEnable: true,
            onCameraChange: _onCameraChange,
            onMapTap: _onMapTap,
            markers: _markers,
            nightModeEnable: true,
          ),
          if (detail == true) _detailWidget(),
          Padding(
            padding: EdgeInsets.all(30),
            child: _mapTypeSelector(),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: _slidertap(),
          ),
        ],
      ),
    );
  }

  buildSearch() {
    return Row(
      children: [
        Container(
          height: 40.0,
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.black26,
              )),
          child: Center(
            child: TextFormField(
              controller: searchController,
              textAlignVertical: TextAlignVertical.center,
              maxLength: 10,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              textCapitalization: TextCapitalization.sentences,
              onTap: () {
                FocusManager.instance.primaryFocus.unfocus();
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    searchController.clear();
                  },
                  child: Icon(Feather.x, size: 15.0, color: Colors.black),
                ),
                contentPadding: EdgeInsets.only(bottom: 10.0, left: 15.0),
                border: InputBorder.none,
                counterText: '',
                hintText: '검색',
                hintStyle: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => Manual()));
            },
            child: Icon(
              CupertinoIcons.lightbulb,
              size: 22.0,
            ),
          ),
        ),
      ],
    );
  }

  searchFunc() async {}

  _slidertap() {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.all(60.0),
          padding: EdgeInsets.all(15.0),
          alignment: Alignment.topCenter,
          height: 50,
          child: Slider(
            min: 1000,
            max: 400000,
            divisions: 10,
            value: _value,
            label: _label,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.2),
            onChanged: (double value) => changed(value),
          ),
        ),
      ),
    );
  }

  changed(value) {
    setState(() {
      _value = value;
      _label = '${(_value.toInt() / 1000).toString()} kms';
      _markers.clear();
    });
    if (cat == 0) {
      FirebaseFirestore.instance.collection('shops').get().then((value) {
        if (value.docs.isNotEmpty) {
          for (int i = 0; i < value.docs.length; i++) {
            if (Geolocator.distanceBetween(
                    _currentPosition.latitude,
                    _currentPosition.longitude,
                    value.docs[i].data()['location'].latitude,
                    value.docs[i].data()['location'].longitude) <=
                _value) {
              _markers.add(Marker(
                  markerId: _markers.length.toString(),
                  position: LatLng(value.docs[i].data()['location'].latitude,
                      value.docs[i].data()['location'].longitude),
                  width: 25,
                  height: 35,
                  captionText: value.docs[i].id,
                  captionMinZoom: 15,
                  onMarkerTab: _onMarkerTap));
              setState(() {});
            }
          }
        }
      });
    } else if (cat == 1) {
      //소분샵
      FirebaseFirestore.instance
          .collection('shops')
          .where('category', arrayContainsAny: [_catstr[1], _catstr[3]])
          .get()
          .then((value) {
            if (value.docs.isNotEmpty) {
              for (int i = 0; i < value.docs.length; i++) {
                if (Geolocator.distanceBetween(
                        _currentPosition.latitude,
                        _currentPosition.longitude,
                        value.docs[i].data()['location'].latitude,
                        value.docs[i].data()['location'].longitude) <=
                    _value) {
                  _markers.add(Marker(
                      markerId: _markers.length.toString(),
                      position: LatLng(
                          value.docs[i].data()['location'].latitude,
                          value.docs[i].data()['location'].longitude),
                      width: 25,
                      height: 35,
                      captionText: value.docs[i].id,
                      captionMinZoom: 15,
                      onMarkerTab: _onMarkerTap));
                  setState(() {});
                }
              }
            }
          });
    } else if (cat == 3) {
      //카페
      FirebaseFirestore.instance
          .collection('shops')
          .where('category', arrayContainsAny: [_catstr[4]])
          .get()
          .then((value) {
            if (value.docs.isNotEmpty) {
              for (int i = 0; i < value.docs.length; i++) {
                if (Geolocator.distanceBetween(
                        _currentPosition.latitude,
                        _currentPosition.longitude,
                        value.docs[i].data()['location'].latitude,
                        value.docs[i].data()['location'].longitude) <=
                    _value) {
                  _markers.add(Marker(
                      markerId: _markers.length.toString(),
                      position: LatLng(
                          value.docs[i].data()['location'].latitude,
                          value.docs[i].data()['location'].longitude),
                      width: 25,
                      height: 35,
                      captionText: value.docs[i].id,
                      captionMinZoom: 15,
                      onMarkerTab: _onMarkerTap));
                  setState(() {});
                }
              }
            }
          });
    } else {
      FirebaseFirestore.instance
          .collection('shops')
          .where('category', arrayContains: _catstr[cat])
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (int i = 0; i < value.docs.length; i++) {
            if (Geolocator.distanceBetween(
                    _currentPosition.latitude,
                    _currentPosition.longitude,
                    value.docs[i].data()['location'].latitude,
                    value.docs[i].data()['location'].longitude) <=
                _value) {
              _markers.add(Marker(
                  markerId: _markers.length.toString(),
                  position: LatLng(value.docs[i].data()['location'].latitude,
                      value.docs[i].data()['location'].longitude),
                  width: 25,
                  height: 35,
                  captionText: value.docs[i].id,
                  captionMinZoom: 15,
                  onMarkerTab: _onMarkerTap));
              setState(() {});
            }
          }
        }
      });
    }
  }

  _onMapTap(LatLng position) async {
    setState(() {
      detail = false;
    });
  }

  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: _categor.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (_, index) {
          final type = _categor[index];
          String title;
          switch (type) {
            case 0:
              title = '모두';
              break;
            case 1:
              title = '소분샵';
              break;
            case 2:
              title = '공방';
              break;
            case 3:
              title = '카페';
              break;
          }

          return GestureDetector(
            onTap: () => _onTapTypeSelector(type),
            child: Container(
              decoration: BoxDecoration(
                  color: cat == type ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)]),
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 지도 생성 완료시
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  /// 지도 유형 선택시
  void _onTapTypeSelector(int type) async {
    if (cat != type) {
      cat = type;
      setState(() {
        _markers.clear();
      });
      if (cat == 0) {
        FirebaseFirestore.instance.collection('shops').get().then((value) {
          if (value.docs.isNotEmpty) {
            for (int i = 0; i < value.docs.length; i++) {
              if (Geolocator.distanceBetween(
                      _currentPosition.latitude,
                      _currentPosition.longitude,
                      value.docs[i].data()['location'].latitude,
                      value.docs[i].data()['location'].longitude) <=
                  _value) {
                _markers.add(Marker(
                    markerId: _markers.length.toString(),
                    position: LatLng(value.docs[i].data()['location'].latitude,
                        value.docs[i].data()['location'].longitude),
                    width: 25,
                    height: 35,
                    captionText: value.docs[i].id,
                    captionMinZoom: 15,
                    onMarkerTab: _onMarkerTap));
                setState(() {});
              }
            }
          }
        });
      } else if (cat == 1) {
        FirebaseFirestore.instance
            .collection('shops')
            .where('category', arrayContainsAny: [_catstr[1], _catstr[3]])
            .get()
            .then((value) {
              if (value.docs.isNotEmpty) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (Geolocator.distanceBetween(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                          value.docs[i].data()['location'].latitude,
                          value.docs[i].data()['location'].longitude) <=
                      _value) {
                    _markers.add(Marker(
                        markerId: _markers.length.toString(),
                        position: LatLng(
                            value.docs[i].data()['location'].latitude,
                            value.docs[i].data()['location'].longitude),
                        width: 25,
                        height: 35,
                        captionText: value.docs[i].id,
                        captionMinZoom: 15,
                        onMarkerTab: _onMarkerTap));
                    setState(() {});
                  }
                }
              }
            });
      } else if (cat == 3) {
        //카페
        FirebaseFirestore.instance
            .collection('shops')
            .where('category', arrayContainsAny: [_catstr[4]])
            .get()
            .then((value) {
              if (value.docs.isNotEmpty) {
                for (int i = 0; i < value.docs.length; i++) {
                  if (Geolocator.distanceBetween(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                          value.docs[i].data()['location'].latitude,
                          value.docs[i].data()['location'].longitude) <=
                      _value) {
                    _markers.add(Marker(
                        markerId: _markers.length.toString(),
                        position: LatLng(
                            value.docs[i].data()['location'].latitude,
                            value.docs[i].data()['location'].longitude),
                        width: 25,
                        height: 35,
                        captionText: value.docs[i].id,
                        captionMinZoom: 15,
                        onMarkerTab: _onMarkerTap));
                    setState(() {});
                  }
                }
              }
            });
      } else {
        FirebaseFirestore.instance
            .collection('shops')
            .where('category', arrayContains: _catstr[cat])
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            for (int i = 0; i < value.docs.length; i++) {
              if (Geolocator.distanceBetween(
                      _currentPosition.latitude,
                      _currentPosition.longitude,
                      value.docs[i].data()['location'].latitude,
                      value.docs[i].data()['location'].longitude) <=
                  _value) {
                _markers.add(Marker(
                    markerId: _markers.length.toString(),
                    position: LatLng(value.docs[i].data()['location'].latitude,
                        value.docs[i].data()['location'].longitude),
                    width: 25,
                    height: 35,
                    captionText: value.docs[i].id,
                    captionMinZoom: 15,
                    onMarkerTab: _onMarkerTap));
                setState(() {});
              }
            }
          }
        });
      }
    }
  }

  void _onCameraChange(
      LatLng latLng, CameraChangeReason reason, bool isAnimated) async {
    if (searched == true) {
      int pos = _markers.indexWhere((m) => m.position == LatLng(lat, long));
      if (pos == -1) {
        _markers.add(Marker(
            markerId: _markers.length.toString(),
            position: LatLng(lat, long),
            width: 25,
            height: 35,
            captionText: placename,
            captionMinZoom: 15,
            onMarkerTab: _onMarkerTap));

        setState(() {});
      }
      final controller = await _controller.future;
      controller.moveCamera(
        CameraUpdate.toCameraPosition(
          CameraPosition(
            target: LatLng(lat, long),
            zoom: 15,
          ),
        ),
      );
      searched = false;
    }
  }

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) {
    int pos = _markers.indexWhere((m) => m.markerId == marker.markerId);
    var documentref = FirebaseFirestore.instance
        .collection('shops')
        .doc(_markers[pos].captionText);
    documentref.get().then((doc) => {
          if (doc.exists)
            {
              setState(() {
                detail = true;
                placename = _markers[pos].captionText;

                /* detail info */
                address = doc.data()['address'];

                time = doc.data()['time'];
                homepage = doc.data()['page'];
                phone = doc.data()['phone'];

                tmpcat = List.from(doc.data()['category']);
                lat = doc.data()['location'].latitude;
                long = doc.data()['location'].longitude;
                for (int i = 0; i < tmpcatbool.length; i++) {
                  tmpcatbool[i] = false;
                }
                for (int i = 0; i < tmpcat.length; i++) {
                  if (tmpcat[i] == "소분") {
                    tmpcatbool[0] = true;
                  } else if (tmpcat[i] == "공방") {
                    tmpcatbool[1] = true;
                  } else if (tmpcat[i] == "리필") {
                    tmpcatbool[2] = true;
                  } else if (tmpcat[i] == "카페") {
                    tmpcatbool[3] = true;
                  }
                }
              })
            }
        });
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 3,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(text: placename, fontSize: 23),
                          buildCategory(),
                        ],
                      ),
                      Container(
                        width: 68.0,
                        child: RaisedButton(
                          onPressed: () =>
                              launchInBrowser(LatLng(lat, long), placename),
                          child: Column(
                            children: [
                              SizedBox(height: 3.0),
                              Icon(CupertinoIcons.location_fill),
                              Text(
                                '길찾기',
                                style: TextStyle(fontSize: 12.0),
                              ),
                              SizedBox(height: 3.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25.0),
                buildAddress(),
                SizedBox(height: 8.0),
                buildTime(),
                SizedBox(height: 8.0),
                buildHomepage(),
                SizedBox(height: 8.0),
                buildNumber(),
              ],
            ),
          ),
        );
      },
    );
  }

  buildCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        tmpcatbool[0] == true || tmpcatbool[2] == true ? Text('리필샵') : Text(''),
        tmpcatbool[1] == true
            ? tmpcatbool[0] == true || tmpcatbool[2] == true
                ? Text(', 공방')
                : Text('공방')
            : Text(''),
        tmpcatbool[3] == true
            ? tmpcatbool[1] == true
                ? Text(', 카페')
                : Text('카페')
            : Text(''),
      ],
    );
  }

  buildAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Icon(
            CupertinoIcons.location,
            color: Colors.black45,
            size: 15.0,
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          address,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  buildTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Icon(
            CupertinoIcons.clock,
            color: Colors.black45,
            size: 15.0,
          ),
        ),
        SizedBox(width: 10.0),
        Flexible(
          child: Text(
            time,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  buildHomepage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Icon(
            CupertinoIcons.home,
            color: Colors.black45,
            size: 15.0,
          ),
        ),
        SizedBox(width: 10.0),
        GestureDetector(
          onTap: () {
            launchPageInBrowser(homepage);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              homepage,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  buildNumber() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Icon(
            CupertinoIcons.phone,
            color: Colors.black45,
            size: 15.0,
          ),
        ),
        SizedBox(width: 10.0),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            phone,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  launchInBrowser(LatLng position, String placename) async {
    String url = 'https://map.kakao.com/link/to/' +
        '$placename' +
        ',' +
        '${position.latitude}' +
        ',' +
        '${position.longitude}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '열기 실패';
    }
  }

  launchPageInBrowser(String homepage) async {
    if (await canLaunch(homepage)) {
      await launch(homepage);
    } else {
      throw '홈페이지를 열 수 없습니다.';
    }
  }
}
