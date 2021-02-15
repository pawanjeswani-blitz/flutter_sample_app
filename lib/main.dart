import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/view/pages/login_page.dart';
import 'package:saloonwala_consumer/view/pages/personal_info.dart';
import 'package:saloonwala_consumer/view/pages/select_gender.dart';
import 'package:saloonwala_consumer/view/pages/user_profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saloonwala Consumer',
      theme: ThemeData(
        primaryColor: AppColor.PRIMARY_DARK,
      ),
      home: LoginPage(),
    );
  }
}
