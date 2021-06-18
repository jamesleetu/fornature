import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:fornature/auth/login/login.dart';
import 'package:fornature/components/password_text_field.dart';
import 'package:fornature/components/text_form_builder.dart';
import 'package:fornature/utils/validation.dart';
import 'package:fornature/view_models/auth/register_view_model.dart';
import 'package:fornature/widgets/indicators.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return ModalProgressHUD(
      progressIndicator: circularProgress(context),
      inAsyncCall: viewModel.loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 25,
              vertical: MediaQuery.of(context).size.height / 5),
          children: [
            Center(
              child: Text(
                '초행길에 오신 걸 환영합니다!',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Center(
              child: Text(
                '제로 웨이스트 라이프 스타일을 시작해볼까요?',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            buildForm(viewModel, context),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이미 계정이 있으신가요?  ',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (_) => Login()));
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildForm(RegisterViewModel viewModel, BuildContext context) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.user,
            hintText: "닉네임",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setName(val);
            },
            focusNode: viewModel.usernameFN,
            nextFocusNode: viewModel.emailFN,
          ),
          SizedBox(height: 10.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.mail,
            hintText: "이메일",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.bioFN,
          ),
          SizedBox(height: 10.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: CupertinoIcons.t_bubble,
            hintText: "소개",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateBio,
            onSaved: (String val) {
              viewModel.setBio(val);
            },
            focusNode: viewModel.bioFN,
            nextFocusNode: viewModel.passFN,
          ),
          SizedBox(height: 10.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.lock,
            suffix: Feather.eye,
            hintText: "비밀번호",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validatePassword,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
            nextFocusNode: viewModel.cPassFN,
          ),
          SizedBox(height: 10.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.lock,
            hintText: "비밀번호 확인",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.register(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setConfirmPass(val);
            },
            focusNode: viewModel.cPassFN,
          ),
          SizedBox(height: 15.0),
          Container(
            height: 35.0,
            width: 180.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              color: Colors.white,
              child: Text(
                '가입하기',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              onPressed: () => viewModel.register(context),
            ),
          ),
        ],
      ),
    );
  }
}
