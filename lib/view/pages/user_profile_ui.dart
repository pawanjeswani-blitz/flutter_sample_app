import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/api/user_profile_service.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/edit_profile.dart';
import 'package:saloonwala_consumer/view/widget/custom_appbar.dart';
import 'package:saloonwala_consumer/view/widget/profile_info_ui.dart';
import 'package:saloonwala_consumer/view/widget/profile_menu_item.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';

class UserProfileUI extends StatefulWidget {
  @override
  _UserProfileUIState createState() => _UserProfileUIState();
}

class _UserProfileUIState extends State<UserProfileUI> {
  UserProfileLogin _userProfileLogin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _getUserNameData();
  }

  Future<SuperResponse<UserProfileLogin>> _getUserNameData() async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      final response = await UserProfileService.getUserProfileAfterLogin();
      //close the progress dialog
      Navigator.of(context).pop();
      if (response.error == null) {
        //check the user is already register or not
        if (response.data != null) {
          setState(() {
            _userProfileLogin = response.data;
          });
          //user is register
          print("successfull");
        } else
          showSnackBar("Something went wrong");
      } else
        showSnackBar(response.error);
    } else
      showSnackBar("No internet connected");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              ProfileInfoUI(
                  title: 'Profile',
                  image: 'assets/images/profile.jpg',
                  name: _userProfileLogin == null
                      ? ""
                      : _userProfileLogin.firstName.toString(),
                  email: " "),
              SizedBox(
                height: defaultSize * 2.0,
              ),
              ProfileMenuItem(
                iconSrc: Icons.person,
                title: 'Edit Profile',
                press: () async {
                  final userProfile =
                      await AppSessionManager.getUserProfileAfterLogin();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfile(
                            userProfile: userProfile,
                          )));
                },
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

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
