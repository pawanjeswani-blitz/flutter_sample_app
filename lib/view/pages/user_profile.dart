import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/custom_appbar.dart';
import 'package:saloonwala_consumer/view/widget/profile_info_ui.dart';
import 'package:saloonwala_consumer/view/widget/profile_menu_item.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ProfileInfoUI(
                title: 'Profile',
                image: 'assets/images/profile.jpg',
                name: 'John Doe',
                email: 'johndoe@gmail.com',
              ),
              SizedBox(
                height: defaultSize * 2.0,
              ),
              ProfileMenuItem(
                iconSrc: Icons.person,
                title: 'Edit Profile',
                press: () {},
              ),
              ProfileMenuItem(
                iconSrc: Icons.access_time,
                title: 'Upcoming Appointments',
                press: () {},
              ),
              ProfileMenuItem(
                iconSrc: Icons.content_paste,
                title: 'Past Appointments',
                press: () {},
              ),
              ProfileMenuItem(
                iconSrc: Icons.privacy_tip,
                title: 'Privacy Policy',
                press: () {},
              ),
              ProfileMenuItem(
                iconSrc: Icons.assignment_returned,
                title: 'Terms & Conditions',
                press: () {},
              ),
              ProfileMenuItem(
                iconSrc: Icons.logout,
                title: 'Logout',
                press: () {},
                hasNavigation: false,
              ),
              SizedBox(
                height: defaultSize * 2.5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
