import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:fornature/components/custom_image.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/view_models/auth/posts_view_model.dart';
import 'package:fornature/widgets/indicators.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    currentUserId() {
      return firebaseAuth.currentUser.uid;
    }

    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        await viewModel.resetPost();
        return true;
      },
      child: ModalProgressHUD(
        progressIndicator: circularProgress(context),
        inAsyncCall: viewModel.loading,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Feather.x),
              onPressed: () {
                viewModel.resetPost();
                Navigator.pop(context);
              },
            ),
            title: Text('새 게시물'),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () async {
                  await viewModel.uploadPosts();
                  Navigator.pop(context);
                  viewModel.resetPost();
                },
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              StreamBuilder(
                stream: usersRef.doc(currentUserId()).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    UserModel user = UserModel.fromJson(snapshot.data.data());
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(user?.photoUrl),
                      ),
                      title: Text(
                        user?.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        user?.email,
                      ),
                    );
                  }
                  return Container();
                },
              ),
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: viewModel.imgLink != null
                        ? CustomImage(
                            imageUrl: viewModel.imgLink,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 30,
                            fit: BoxFit.cover,
                          )
                        : viewModel.mediaUrl == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 60.0,
                                  ),
                                  Text(
                                    '사진을 등록하세요',
                                  ),
                                ],
                              )
                            : Image.file(
                                viewModel.mediaUrl,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width - 30,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
              ),
              TextFormField(
                initialValue: viewModel.description,
                decoration: InputDecoration(
                  hintText: '설명 추가',
                  focusedBorder: UnderlineInputBorder(),
                ),
                maxLines: null,
                onChanged: (val) => viewModel.setDescription(val),
              ),
              SizedBox(height: 15.0),
              ListTile(
                contentPadding: EdgeInsets.all(0.0),
                title: Container(
                  width: 250.0,
                  child: TextFormField(
                    controller: viewModel.locationTEC,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0.0),
                      hintText: '위치 추가',
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    maxLines: null,
                    onChanged: (val) => viewModel.setLocation(val),
                  ),
                ),
                trailing: IconButton(
                  tooltip: "현재 위치를 추가하세요",
                  icon: Icon(
                    CupertinoIcons.map_pin_ellipse,
                    size: 25.0,
                  ),
                  iconSize: 30.0,
                  color: Theme.of(context).accentColor,
                  onPressed: () => viewModel.getLocation(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImageChoices(BuildContext context, PostsViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
                child: Text(
                  '선택하기',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Feather.camera,
                  size: 25.0,
                ),
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Text('사진 찍기'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(camera: true);
                },
              ),
              ListTile(
                leading: Icon(
                  Feather.image,
                  size: 25.0,
                ),
                title: Transform.translate(
                  offset: Offset(-16, 0),
                  child: Text('사진 보관함'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
