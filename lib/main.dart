import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/edit_profile.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/pages/login_page.dart';
import 'package:saloonwala_consumer/view/pages/personal_info.dart';
import 'package:saloonwala_consumer/view/pages/random_tests.dart';
import 'package:saloonwala_consumer/view/pages/select_gender.dart';
import 'package:saloonwala_consumer/view/pages/user_profile_ui.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

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
