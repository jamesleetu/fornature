import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:fornature/themes/light_color.dart';
import 'package:fornature/themes/theme.dart';
import 'package:fornature/widgets/title_text.dart';
import 'package:fornature/widgets/extentions.dart';
import 'package:flutter/cupertino.dart';
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
  List<int> _categor = [0, 1, 2, 3, 4];
  List<String> _catstr = ["", "소분", "공방", "리필", "카페"];
  String phone;
  String time;
  List<String> tmpcat;
  List<bool> tmpcatbool = [false, false, false, false];
  //variables for selected shop

  double _value = 20000.0;
  String _label = '';
  TextEditingController searchController = TextEditingController();
  ////////////////////////////////search variables

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

/*
  search(String query) {
    if (query == "") {
      filteredshops = shops;
    } else {
      List shopSearch = shops.where((shopSnap) {
        String shopName = shopSnap.id;
        return shopName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredshops = shopSearch;
      });
    }
  }
*/
  removeFromList(index) {
    filteredshops.removeAt(index);
  }

  @override
  void initState() {
    getShops();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'ss/map-marker-icon.png',
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
            //infoWindow: '인포 윈도우',
            onMarkerTab: _onMarkerTap);
        setState(() {});
      });
    });
    /*
    _markers.add(Marker(
        markerId: 'id',
        position: LatLng(37.563600, 126.962370),
        captionText: "커스텀 아이콘",
        captionColor: Colors.indigo,
        captionTextSize: 20.0,
        alpha: 0.8,
        //icon: image,
        anchor: AnchorPoint(0.5, 1),
        captionMinZoom: 10,
        width: 35,
        height: 35,
        //infoWindow: '인포 윈도우',
        onMarkerTab: _onMarkerTap));
    setState(() {});
    */
    /*
    _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: LatLng(37.569968415084, 126.93120094519),
        infoWindow: '테스트',
        onMarkerTab: _onMarkerTap,
      ));
    setState(() {});
    */
    getPosition();
    /*
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print('현재위치 : ${_currentPosition.latitude},'
            '${_currentPosition.longitude}');
      });
    }).catchError((e) {
      print(e);
    });
    */
    FirebaseFirestore.instance.collection('shops').get().then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          print(value.docs[i].id);
          print('위치 : ${value.docs[i].data()['location'].latitude},'
              '${value.docs[i].data()['location'].longitude}');
          //if (Geolocator.distanceBetween(
          //        _currentPosition.latitude,
          //        _currentPosition.longitude,
          //        value.docs[i].data()['location'].latitude,
          //        value.docs[i].data()['location'].longitude) <=
          //    _value) {
          //OverlayImage.fromAssetImage(
          //  assetName: 'ss/map-marker-icon.png',
          //  context: context,
          //).then((image) {
          _markers.add(Marker(
              markerId: _markers.length.toString(),
              position: LatLng(value.docs[i].data()['location'].latitude,
                  value.docs[i].data()['location'].longitude),
              //infoWindow: '인포 윈도우',
              //icon: image,
              width: 25,
              height: 35,
              //iconTintColor: Color.fromARGB(255, 255, 0, 0),
              captionText: value.docs[i].id,
              captionMinZoom: 15,
              onMarkerTab: _onMarkerTap));
          //});
          //}
          setState(() {});
        }
      }
    });

    /*
    FirebaseFirestore.instance.collection('shops').get().then((value) {
      if(value.docs.isNotEmpty){
          print('firebase 불러오기 성공!');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            OverlayImage.fromAssetImage(
              assetName: 'icon/marker.png',
              context: context,
            ).then((image) {
              setState(() {
                for(int i =0; i<value.docs.length; i++){
                    print(value.docs[i].data());
                    _markers.add(Marker(
                    markerId: 'id',
                    position: LatLng(
                      value.docs[i].data()["loaction"].latitude, 
                      value.docs[i].data()["loaction"].longitude),
                    captionText: "커스텀 아이콘",
                    captionColor: Colors.indigo,
                    captionTextSize: 20.0,
                    alpha: 0.8,
                    icon: image,
                    anchor: AnchorPoint(0.5, 1),
                    width: 45,
                    height: 45,
                    infoWindow: '인포 윈도우',
                    onMarkerTab: _onMarkerTap));
                }
              });
            });
          });
        /*
        for(int i =0; i<value.docs.length; i++){
                    print('위치 : ${value.docs[i].data()['loaction'].latitude},'
                          '${value.docs[i].data()['loaction'].longitude}');
                    _markers.add(Marker(
                    markerId: 'id',
                    position: LatLng(
                      value.docs[i].data()['loaction'].latitude, 
                      value.docs[i].data()['loaction'].longitude),
                    infoWindow: '인포 윈도우',
                    onMarkerTab: _onMarkerTap));
        }
        setState(() {});
        */
      }
    });
    */
    super.initState();
  }

  getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
    try {
      setState(() {
        _currentPosition = position;
        print('현재위치 : ${_currentPosition.latitude},'
            '${_currentPosition.longitude}');
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
            onCameraIdle: _onCameraIdle,
            onMapTap: _onMapTap,
            onMapLongTap: _onMapLongTap,
            onMapDoubleTap: _onMapDoubleTap,
            onMapTwoFingerTap: _onMapTwoFingerTap,
            onSymbolTap: _onSymbolTap,
            markers: _markers,
            nightModeEnable: true,
          ),
          //if (searched == true) searchFunc(),
          if (detail == true) _detailWidget(),
          Padding(
            padding: EdgeInsets.all(30),
            child: _mapTypeSelector(),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: _slidertap(),
          ),
          /*
          Padding(
            padding: EdgeInsets.only(50),
            child: Slider(
              min: 1000,
              max: 20000,
              divisions: 5,
              value: _value,
              label: _label,
              activeColor: Colors.blue,
              inactiveColor: Colors.blue.withOpacity(0.2),
              onChanged: (double value) => changed(value),
            ),
          ),
          */
          //_trackingModeSelector(),
        ],
      ),
    );
  }

  buildSearch() {
    return Row(
      children: [
        Container(
          height: 35.0,
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                onChanged: (query) {
                  //search(query);
                },
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
                  contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                  border: InputBorder.none,
                  counterText: '',
                  hintText: '검색...',
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  searchFunc() async {}

/*
  buildUsers() {
    if (!loading) {
      if (filteredshops.isEmpty) {
        return Center(
          child: Text("No User Found",
              style: TextStyle(fontWeight: FontWeight.bold)),
        );
      } else {
        return ListView.builder(
          itemCount: filteredshops.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot doc = filteredshops[index];
            //UserModel user = UserModel.fromJson(doc.data());
            return Column(
              children: [
                ListTile(
                  onTap: () => showProfile(context, profileId: user?.id),
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  leading: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(user?.photoUrl),
                  ),
                  title: Text(user?.username,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    user?.email,
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          // builder: (_) => Conversation(
                          //   userId: doc.id,
                          //   chatId: 'newChat',
                          // ),
                          builder: (_) =>
                              Profile(profileId: firebaseAuth.currentUser.uid),
                        ),
                      );
                    },
                    // child: Icon(CupertinoIcons.chat_bubble_fill,
                    //     color: Theme.of(context).accentColor),
                    child: Container(
                      height: 30.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(3.0),
                        // border:
                        //     Border.all(color: Theme.of(context).accentColor),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('Message',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          },
        );
      }
    } else {
      return Center(
        child: circularProgress(context),
      );
    }
  }
*/

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
          //width: 400,
          height: 50,
          //margin: EdgeInsets.,
          //padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
            print(value.docs[i]);
            print('위치 : ${value.docs[i].data()['location'].latitude},'
                '${value.docs[i].data()['location'].longitude}');
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
                  //infoWindow: '인포 윈도우',
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
            print(value.docs[i]);
            print('위치 : ${value.docs[i].data()['location'].latitude},'
                '${value.docs[i].data()['location'].longitude}');
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
                  //infoWindow: '인포 윈도우',
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
    //print('[onTap] lat: ${position.latitude}, lon: ${position.longitude}');

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text('[onTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
    /*
    final controller = await _controller.future;
    controller.moveCamera(
      CameraUpdate.toCameraPosition(
        CameraPosition(
          target: LatLng(37.569968415084, 126.93120094519),
          zoom: 15,
        ),
      ),
    );
    */
    setState(() {
      detail = false;
    });
  }

  _onMapLongTap(LatLng position) {
    /*
    _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: LatLng(37.569968415084, 126.93120094519),
        infoWindow: '테스트',
        onMarkerTab: _onMarkerTap,
      ));
      for(int i =0; i< _markers.length; i++)
      {
        print('마커 ${i}: ${_markers[i].position.latitude},'
                          '${_markers[i].position.longitude}');
      }
      setState(() {});
    */
    //setState(() {
    //  _markers.clear();
    //});
    /*
    LatLng tmp = LatLng(37.569968415084954, 126.93120094519954);
    FirebaseFirestore.instance.collection('shops').get().then((value) {
      if(value.docs.isNotEmpty){
        for(int i =0; i<value.docs.length; i++){
                    print('위치 : ${value.docs[i].data()['loaction'].latitude},'
                          '${value.docs[i].data()['loaction'].longitude}');
                    OverlayImage.fromAssetImage(
                      assetName: 'icon/marker.png',
                      context: context,
                    ).then((image) {
                      setState(() {
                        _markers.add(Marker(
                            markerId: 'id',
                            position: tmp,
                            captionText: "커스텀 아이콘",
                            captionColor: Colors.indigo,
                            captionTextSize: 20.0,
                            alpha: 0.8,
                            icon: image,
                            anchor: AnchorPoint(0.5, 1),
                            width: 45,
                            height: 45,
                            infoWindow: '인포 윈도우',
                            onMarkerTab: _onMarkerTap));
                      });
                    });      
                    //_markers.add(Marker(
                    //markerId: 'id',
                    //position: tmp,
                    //infoWindow: '인포 윈도우',
                    //onMarkerTab: _onMarkerTap));
                    //setState(() {});
        }
      }
    });
    */
    //setState(() {});

    /*
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
    */
  }

  _onMapDoubleTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onDoubleTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapTwoFingerTap(LatLng position) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onSymbolTap(LatLng position, String caption) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          '[onSymbolTap] caption: $caption, lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: MapType.values.length,
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
              title = '소분';
              break;
            case 2:
              title = '공방';
              break;
            case 3:
              title = '리필';
              break;
            case 4:
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

/*
  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: MapType.values.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (_, index) {
          final type = MapType.values[index];
          String title;
          switch (type) {
            case MapType.Basic:
              title = '기본';
              break;
            case MapType.Navi:
              title = '내비';
              break;
            case MapType.Satellite:
              title = '위성';
              break;
            case MapType.Hybrid:
              title = '위성혼합';
              break;
            case MapType.Terrain:
              title = '지형도';
              break;
          }

          return GestureDetector(
            onTap: () => _onTapTypeSelector(type),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
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
*/
  _trackingModeSelector() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: _onTapTakeSnapShot,
        child: Container(
          margin: EdgeInsets.only(right: 16, bottom: 48),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ]),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.photo_camera,
                color: Colors.black54,
              ),
            ],
          ),
        ),
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
      print('type is $type');
      setState(() {
        _markers.clear();
      });
      if (cat == 0) {
        FirebaseFirestore.instance.collection('shops').get().then((value) {
          if (value.docs.isNotEmpty) {
            for (int i = 0; i < value.docs.length; i++) {
              print(value.docs[i]);
              print('위치 : ${value.docs[i].data()['location'].latitude},'
                  '${value.docs[i].data()['location'].longitude}');
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
                    //infoWindow: '인포 윈도우',
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
              print(value.docs[i]);
              print('위치 : ${value.docs[i].data()['location'].latitude},'
                  '${value.docs[i].data()['location'].longitude}');
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
                    //infoWindow: '인포 윈도우',
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

/*
  /// 지도 유형 선택시
  void _onTapTypeSelector(MapType type) async {
    if (_mapType != type) {
      setState(() {
        _mapType = type;
      });
    }
  }
*/

  /// my location button
  // void _onTapLocation() async {
  //   final controller = await _controller.future;
  //   controller.setLocationTrackingMode(LocationTrackingMode.Follow);
  // }

  void _onCameraChange(
      LatLng latLng, CameraChangeReason reason, bool isAnimated) async {
    if (searched == true) {
      int pos = _markers.indexWhere((m) => m.position == LatLng(lat, long));
      if (pos == -1) {
        print("here!");
        _markers.add(Marker(
            markerId: _markers.length.toString(),
            position: LatLng(lat, long),
            width: 25,
            height: 35,
            captionText: placename,
            captionMinZoom: 15,
            onMarkerTab: _onMarkerTap));
        //});
        //}
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
      //detail = true;
      searched = false;
    }
    print('카메라 움직임 >>> 위치 : ${latLng.latitude}, ${latLng.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }

  void _onCameraIdle() {
    print('카메라 움직임 멈춤');
  }

  /// 지도 스냅샷
  void _onTapTakeSnapShot() async {
    final controller = await _controller.future;
    controller.takeSnapshot((path) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: path != null
                  ? Image.file(
                      File(path),
                    )
                  : Text('path is null!'),
              titlePadding: EdgeInsets.zero,
            );
          });
    });
  }

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) {
    int pos = _markers.indexWhere((m) => m.markerId == marker.markerId);
    var documentref = FirebaseFirestore.instance
        .collection('shops')
        .doc(_markers[pos].captionText);
    documentref.get().then((doc) => {
          if (doc.exists)
            {
              print("Open doc success!!"),
              //tmpcat = List.from(doc.data()['category']),
              print("${doc.data()['number']} , ${doc.data()['time']}"),
              setState(() {
                detail = true;
                placename = _markers[pos].captionText;
                phone = doc.data()['number'];
                time = doc.data()['time'];
                tmpcat = List.from(doc.data()['category']);
                //_markers[pos].captionText = '선택됨';
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

    /*
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
    */
    /*
    setState(() {
      detail = true;
      placename = _markers[pos].captionText;
      //_markers[pos].captionText = '선택됨';
    });
    */
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
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
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
                    height: 5,
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
                      TitleText(text: placename, fontSize: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TitleText(
                                text: "\$ ",
                                fontSize: 18,
                                color: LightColor.red,
                              ),
                              TitleText(
                                text: "240",
                                fontSize: 25,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star,
                                  color: LightColor.yellowColor, size: 17),
                              Icon(Icons.star_border, size: 17),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _availableSize(),
                SizedBox(
                  height: 20,
                ),
                _availableColor(),
                SizedBox(
                  height: 20,
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "분류",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            tmpcatbool[0] == false
                ? _sizeWidget("소분")
                : _sizeWidget("소분", isSelected: true),
            tmpcatbool[1] == false
                ? _sizeWidget("공방")
                : _sizeWidget("공방", isSelected: true),
            tmpcatbool[2] == false
                ? _sizeWidget("리필")
                : _sizeWidget("리필", isSelected: true),
            tmpcatbool[3] == false
                ? _sizeWidget("카페")
                : _sizeWidget("카페", isSelected: true),
            //_sizeWidget("소분"),
            //_sizeWidget("공방", isSelected: true),
            //_sizeWidget("리필"),
            //_sizeWidget("카페"),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description() {
    print("$time");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(),
        Text(
          time,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}

/*import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class BaseMapPage extends StatefulWidget {
  @override
  _BaseMapPageState createState() => _BaseMapPageState();
}

class _BaseMapPageState extends State<BaseMapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();

  MapType _mapType = MapType.Basic;
  LocationTrackingMode _trackingMode = LocationTrackingMode.NoFollow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          NaverMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.566570, 126.978442),
              zoom: 17,
            ),
            onMapCreated: onMapCreated,
            mapType: _mapType,
            initLocationTrackingMode: _trackingMode,
            locationButtonEnable: true,
            indoorEnable: true,
            onCameraChange: _onCameraChange,
            onCameraIdle: _onCameraIdle,
            onMapTap: _onMapTap,
            onMapLongTap: _onMapLongTap,
            onMapDoubleTap: _onMapDoubleTap,
            onMapTwoFingerTap: _onMapTwoFingerTap,
            onSymbolTap: _onSymbolTap,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: _mapTypeSelector(),
          ),
          _trackingModeSelector(),
        ],
      ),
    );
  }

  _onMapTap(LatLng position) async {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
          Text('[onTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapLongTap(LatLng position) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
          '[onLongTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapDoubleTap(LatLng position) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
          '[onDoubleTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onMapTwoFingerTap(LatLng position) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
          '[onTwoFingerTap] lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _onSymbolTap(LatLng position, String caption) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
          '[onSymbolTap] caption: $caption, lat: ${position.latitude}, lon: ${position.longitude}'),
      duration: Duration(milliseconds: 500),
      backgroundColor: Colors.black,
    ));
  }

  _mapTypeSelector() {
    return SizedBox(
      height: kToolbarHeight,
      child: ListView.separated(
        itemCount: MapType.values.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => SizedBox(width: 16),
        itemBuilder: (_, index) {
          final type = MapType.values[index];
          String title;
          switch (type) {
            case MapType.Basic:
              title = '기본';
              break;
            case MapType.Navi:
              title = '내비';
              break;
            case MapType.Satellite:
              title = '위성';
              break;
            case MapType.Hybrid:
              title = '위성혼합';
              break;
            case MapType.Terrain:
              title = '지형도';
              break;
          }

          return GestureDetector(
            onTap: () => _onTapTypeSelector(type),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
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

  _trackingModeSelector() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: _onTapTakeSnapShot,
        child: Container(
          margin: EdgeInsets.only(right: 16, bottom: 48),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                )
              ]),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.photo_camera,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 지도 생성 완료시
  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  /// 지도 유형 선택시
  void _onTapTypeSelector(MapType type) async {
    if (_mapType != type) {
      setState(() {
        _mapType = type;
      });
    }
  }

  /// my location button
  // void _onTapLocation() async {
  //   final controller = await _controller.future;
  //   controller.setLocationTrackingMode(LocationTrackingMode.Follow);
  // }

  void _onCameraChange(
      LatLng latLng, CameraChangeReason reason, bool isAnimated) {
    print('카메라 움직임 >>> 위치 : ${latLng.latitude}, ${latLng.longitude}'
        '\n원인: $reason'
        '\n에니메이션 여부: $isAnimated');
  }

  void _onCameraIdle() {
    print('카메라 움직임 멈춤');
  }

  /// 지도 스냅샷
  void _onTapTakeSnapShot() async {
    final controller = await _controller.future;
    controller.takeSnapshot((path) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: path != null
                  ? Image.file(
                      File(path),
                    )
                  : Text('path is null!'),
              titlePadding: EdgeInsets.zero,
            );
          });
    });
  }
}
*/
