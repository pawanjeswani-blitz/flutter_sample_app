import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/api/auth_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAndSetInfoBean();
    _startTime();
  }

  _checkAndSetInfoBean() async {
    final nonLoginAuthToken = await AppSessionManager.getNonLoginAuthToken();
    if (nonLoginAuthToken == null) {
      //info bean is not set. call the api to set the info bean
      AuthService.getNonAuthToken();
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
                    authToken != null ? BottomNavBar() : LoginPage())));
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
