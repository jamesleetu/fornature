import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fornature/auth/register/profile_pic.dart';
import 'package:fornature/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String username, email, bio, password, cPassword;
  FocusNode usernameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode bioFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode cPassFN = FocusNode();
  AuthService auth = AuthService();

  register(BuildContext context) async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar('가입을 위해 올바른 정보를 입력하세요.');
    } else {
      if (password == cPassword) {
        loading = true;
        notifyListeners();
        try {
          bool success = await auth.createUser(
            name: username,
            email: email,
            bio: bio,
            password: password,
          );
          print(success);
          if (success) {
            Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (_) => ProfilePicture()));
          }
        } catch (e) {
          loading = false;
          notifyListeners();
          print(e);
          showInSnackBar('${auth.handleFirebaseAuthError(e.toString())}');
        }
        loading = false;
        notifyListeners();
      } else {
        showInSnackBar('비밀번호가 일치하지 않습니다.');
      }
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  setName(val) {
    username = val;
    notifyListeners();
  }

  setBio(val) {
    bio = val;
    notifyListeners();
  }

  setConfirmPass(val) {
    cPassword = val;
    notifyListeners();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
