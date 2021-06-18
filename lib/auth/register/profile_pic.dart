import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:fornature/components/custom_image.dart';
import 'package:fornature/view_models/auth/posts_view_model.dart';
import 'package:fornature/widgets/indicators.dart';

class ProfilePicture extends StatefulWidget {
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        viewModel.resetPost();
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
            title: Text('프로필 등록'),
            centerTitle: true,
          ),
          body: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
            children: [
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Container(
                  height: MediaQuery.of(context).size.width - 110,
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
                                  size: 50.0,
                                ),
                                Text(
                                  '프로필 사진을 등록하세요',
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
              SizedBox(height: 10.0),
              Center(
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  onPressed: () => viewModel.uploadProfilePicture(context),
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
