import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:fornature/components/text_form_builder.dart';
import 'package:fornature/models/user.dart';
import 'package:fornature/utils/firebase.dart';
import 'package:fornature/utils/validation.dart';
import 'package:fornature/view_models/profile/edit_profile_view_model.dart';
import 'package:fornature/widgets/indicators.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;

  const EditProfile({this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel user;

  String currentUid() {
    return firebaseAuth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    EditProfileViewModel viewModel = Provider.of<EditProfileViewModel>(context);
    return ModalProgressHUD(
      progressIndicator: circularProgress(context),
      inAsyncCall: viewModel.loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: viewModel.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("프로필 편집"),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: GestureDetector(
                  onTap: () => viewModel.editProfile(context),
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => viewModel.pickImage(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.transparent,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: viewModel.imgLink != null
                        ? Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 65.0,
                              backgroundImage: NetworkImage(viewModel.imgLink),
                            ),
                          )
                        : viewModel.image == null
                            ? Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage:
                                      NetworkImage(widget.user.photoUrl),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage: FileImage(viewModel.image),
                                ),
                              ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              buildForm(viewModel, context)
            ],
          ),
        ),
      ),
    );
  }

  buildForm(EditProfileViewModel viewModel, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: viewModel.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormBuilder(
              enabled: !viewModel.loading,
              initialValue: widget.user.username,
              prefix: Feather.user,
              hintText: "닉네임",
              textInputAction: TextInputAction.next,
              validateFunction: Validations.validateName,
              onSaved: (String val) {
                viewModel.setUsername(val);
              },
            ),
            SizedBox(height: 10.0),
            TextFormBuilder(
              enabled: !viewModel.loading,
              initialValue: widget.user.bio,
              prefix: CupertinoIcons.t_bubble,
              hintText: "소개",
              textInputAction: TextInputAction.done,
              validateFunction: Validations.validateBio,
              onSaved: (String val) {
                viewModel.setBio(val);
              },
              onChange: (String val) {
                viewModel.setBio(val);
              },
            ),
          ],
        ),
      ),
    );
  }
}
