import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:fornature/auth/register/register.dart';
import 'package:fornature/components/password_text_field.dart';
import 'package:fornature/components/text_form_builder.dart';
import 'package:fornature/utils/validation.dart';
import 'package:fornature/view_models/auth/login_view_model.dart';
import 'package:fornature/widgets/indicators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    return ModalProgressHUD(
      progressIndicator: circularProgress(context),
      inAsyncCall: viewModel.loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 25,
              vertical: MediaQuery.of(context).size.height / 4),
          children: [
            // 로고
            Container(
              height: 110.0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            // 환영 메시지
            SizedBox(height: 12.0),
            Center(
              child: Text(
                '돌아오신 걸 환영해요!',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Center(
              child: Text(
                '로그인하고 시작해볼까요?',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            buildForm(context, viewModel),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '계정이 없으신가요?  ',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (_) => Register()));
                  },
                  child: Text(
                    '가입하기',
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

  buildForm(BuildContext context, LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
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
            nextFocusNode: viewModel.passFN,
          ),
          SizedBox(height: 15.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.lock,
            suffix: Feather.eye,
            hintText: "비밀번호",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.login(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: InkWell(
                onTap: () => viewModel.forgotPassword(),
                child: Container(
                  width: 130,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 35.0,
            width: 180.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              color: Colors.white,
              child: Text(
                '로그인',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              onPressed: () => viewModel.login(context),
            ),
          ),
        ],
      ),
    );
  }
}
