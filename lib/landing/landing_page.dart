import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fornature/auth/login/login.dart';
import 'package:fornature/auth/register/register.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 메인 로고
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 150.0,
                width: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '초록 행성을 위한 길',
              style: TextStyle(
                fontSize: 26.0,
                fontFamily: 'SangSangFlowerRoad',
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (_) => Login(),
                  ),
                );
              },
              // 로그인 버튼
              child: Container(
                height: 60.0,
                width: 180.0,
                child: Center(
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(builder: (_) => Register()));
              },
              // 회원가입 버튼
              child: Container(
                height: 60.0,
                width: 180.0,
                child: Center(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
