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
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          children: [
            // logo
            SizedBox(height: 90.0),
            Container(
              height: 110.0,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            // padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            // children: [
            SizedBox(height: 12.0),
            Center(
              child: Text(
                'Welcome To 초행길!',
                style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'NanumSquare_acEB'),
              ),
            ),
            SizedBox(height: 5.0),
            Center(
              child: Text(
                'Let\'s get started with Zero-Waste Lifestyle!',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w300,
                  // color: Theme.of(context).accentColor,
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
                  'Already have an account?  ',
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
                    'Login',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      // color: Theme.of(context).accentColor,
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
            hintText: "Username",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateName,
            onSaved: (String val) {
              viewModel.setName(val);
            },
            focusNode: viewModel.usernameFN,
            nextFocusNode: viewModel.emailFN,
          ),
          SizedBox(height: 15.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.mail,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.countryFN,
          ),
          // SizedBox(height: 20.0),
          // TextFormBuilder(
          //   enabled: !viewModel.loading,
          //   prefix: Feather.map_pin,
          //   hintText: "Country",
          //   textInputAction: TextInputAction.next,
          //   validateFunction: Validations.validateName,
          //   onSaved: (String val) {
          //     viewModel.setCountry(val);
          //   },
          //   focusNode: viewModel.countryFN,
          //   nextFocusNode: viewModel.passFN,
          // ),
          SizedBox(height: 15.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.lock,
            suffix: Feather.eye,
            hintText: "Password",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validatePassword,
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
            nextFocusNode: viewModel.cPassFN,
          ),
          SizedBox(height: 15.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Feather.lock,
            hintText: "Confirm Password",
            textInputAction: TextInputAction.done,
            validateFunction: Validations.validatePassword,
            submitAction: () => viewModel.register(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setConfirmPass(val);
            },
            focusNode: viewModel.cPassFN,
          ),
          SizedBox(height: 10.0),
          Container(
            height: 35.0,
            width: 180.0,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(40.0),
            //   border: Border.all(color: Colors.black, width: 0.5),
            // ),
            child: RaisedButton(
              // highlightElevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              //color: Theme.of(context).accentColor,
              color: Colors.white,
              child: Text(
                'sign up'.toUpperCase(),
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
