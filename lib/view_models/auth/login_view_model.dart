import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fornature/screens/mainscreen.dart';
import 'package:fornature/services/auth_service.dart';
import 'package:fornature/utils/validation.dart';

class LoginViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String email, password;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  AuthService auth = AuthService();

  login(BuildContext context) async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar('올바른 이메일과 비밀번호를 입력하세요.');
    } else {
      loading = true;
      notifyListeners();
      try {
        bool success = await auth.loginUser(
          email: email,
          password: password,
        );
        print(success);
        if (success) {
          Navigator.of(context)
              .pushReplacement(CupertinoPageRoute(builder: (_) => TabScreen()));
        }
      } catch (e) {
        loading = false;
        notifyListeners();
        print(e);
        showInSnackBar('${auth.handleFirebaseAuthError(e.toString())}');
      }
      loading = false;
      notifyListeners();
    }
  }

  forgotPassword() async {
    loading = true;
    notifyListeners();
    FormState form = formKey.currentState;
    form.save();
    print(Validations.validateEmail(email));
    if (Validations.validateEmail(email) != null) {
      showInSnackBar('비밀번호 찾기를 위해 올바른 이메일을 입력하세요.');
    } else {
      try {
        await auth.forgotPassword(email);
        showInSnackBar('비밀번호 재설정을 위한 메일이 발송되었습니다.');
      } catch (e) {
        showInSnackBar('${e.toString()}');
      }
    }
    loading = false;
    notifyListeners();
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
