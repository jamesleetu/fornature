import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fornature/utils/time_util.dart';
import 'package:provider/provider.dart';
import 'package:fornature/components/life_cycle_event_handler.dart';
import 'package:fornature/landing/landing_page.dart';
import 'package:fornature/screens/mainscreen.dart';
import 'package:fornature/services/user_service.dart';
import 'package:fornature/utils/config.dart';
import 'package:fornature/utils/constants.dart';
import 'package:fornature/utils/providers.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () => UserService().setUserStatus(false),
      resumeCallBack: () => UserService().setUserStatus(true),
    ));
    timeago.setLocaleMessages('ko', KoMessages());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: Constants.lightTheme,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                if (snapshot.hasData) {
                  return TabScreen();
                } else
                  return Landing();
              },
            ),
          );
        },
      ),
    );
  }
}
