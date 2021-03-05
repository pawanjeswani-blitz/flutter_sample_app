import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/user_profile_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/edit_profile.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/pages/login_page.dart';
import 'package:saloonwala_consumer/view/pages/past_appointments.dart';
import 'package:saloonwala_consumer/view/pages/saloonawala_terms.dart';
import 'package:saloonwala_consumer/view/pages/saloonwala_privacy.dart';
import 'package:saloonwala_consumer/view/pages/upcoming_appointments_screen.dart';
import 'package:saloonwala_consumer/view/widget/custom_appbar.dart';
import 'package:saloonwala_consumer/view/widget/profile_info_ui.dart';
import 'package:saloonwala_consumer/view/widget/profile_menu_item.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileUI extends StatefulWidget {
  @override
  _UserProfileUIState createState() => _UserProfileUIState();
}

class _UserProfileUIState extends State<UserProfileUI> {
  UserProfileLogin _userProfileLogin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double defaultOverride;
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
    defaultOverride = defaultSize;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: AppColor.PRIMARY_LIGHT),
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                ProfileInfoUI(
                  title: 'Profile',
                  image: _userProfileLogin.gender == "M"
                      ? 'assets/images/avatar.png'
                      : 'assets/images/favatar.png',
                  name: _userProfileLogin == null
                      ? ""
                      : _userProfileLogin.firstName.toString(),
                  email: _userProfileLogin == null
                      ? ""
                      : _userProfileLogin.email.toString(),
                ),
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
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpcomingAppointmentScreen()));
                  },
                ),
                ProfileMenuItem(
                  iconSrc: Icons.content_paste,
                  title: 'Past Appointments',
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PastAppointments()));
                  },
                ),
                ProfileMenuItem(
                  iconSrc: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SaloonWalaPrivacy()));
                  },
                ),
                ProfileMenuItem(
                  iconSrc: Icons.assignment_returned,
                  title: 'Terms & Conditions',
                  press: () {
                    // _launchURL();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SaloonWalaTerms()));
                  },
                ),
                ProfileMenuItem(
                  iconSrc: Icons.logout,
                  title: 'Logout',
                  press: () async {
                    _showLogout();
                  },
                  hasNavigation: false,
                ),
                SizedBox(
                  height: defaultSize * 2.5,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showLogout() {
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: GoogleFonts.poppins(
          fontSize: defaultOverride * 1.39,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Logout",
        style: GoogleFonts.poppins(
          fontSize: defaultOverride * 1.39,
        ),
      ),
      onPressed: () async {
        Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Are you sure you want to logout",
        style: GoogleFonts.poppins(
          fontSize: defaultOverride * 1.49,
          color: Colors.grey[500],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // _launchURL() async {
  //   const url = 'http://saloonwala.in/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
