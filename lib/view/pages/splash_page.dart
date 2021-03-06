import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/api/auth_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/onboarding_screen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //take the permission
    // firebaseMessaging.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, alert: true));
    // firebaseMessaging.configure();
    _refreshToken();
    _startTime();
  }

  _refreshToken() async {
    final refreshToken = await AppSessionManager.getRefreshToken();
    if (refreshToken != null) {
      //if user is login then refresh his token
      AuthService.refreshToken();
    }
  }

  _startTime() async {
    final authToken = await AppSessionManager.getLoginAuthToken();
    final _duration = new Duration(seconds: 2);
    return Timer(
        _duration,
        () => Navigator.pushReplacement(
            //if user is not login then redirect him to login page
            context,
            MaterialPageRoute(
                builder: (context) =>
                    authToken != null ? BottomNavBar() : OnboardingScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Center(
              child: Image.asset('assets/images/logo_with_circle.png',
                  height: MediaQuery.of(context).size.width * 2.4 / 3,
                  width: MediaQuery.of(context).size.width * 2.4 / 3),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_DARK])),
          ),
        ],
      ),
    );
  }
}
