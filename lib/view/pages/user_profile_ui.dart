import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/auth_service.dart';
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
import 'package:saloonwala_consumer/view/widget/custom_clipper.dart';

class UserProfileUI extends StatefulWidget {
  @override
  _UserProfileUIState createState() => _UserProfileUIState();
}

class _UserProfileUIState extends State<UserProfileUI> {
  UserProfileLogin _userProfileLogin;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double defaultOverride;
  bool refresh = false;
  @override
  void initState() {
    super.initState();
    _refresh();
    _getUserNameData();
  }

  void _refresh() {
    if (refresh) {
      setState(() {});
    }
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
        body: _userProfileLogin != null
            ? SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: defaultSize * 34,
                        child: Stack(
                          children: [
                            ClipPath(
                              clipper: CustomClipperShape(),
                              child: Container(
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: defaultSize * 3.5,
                                          ),
                                          child: Text("Profile",
                                              style: GoogleFonts.poppins(
                                                color:
                                                    AppColor.LOGIN_BACKGROUND,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500,
                                                fontSize: defaultSize * 3.5,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                height: defaultSize * 25,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColor.PRIMARY_LIGHT,
                                        AppColor.PRIMARY_MEDIUM
                                      ]),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: _getImageDisplayWidget(),
                                ),
                                Text(
                                  _userProfileLogin == null
                                      ? ""
                                      : _userProfileLogin.firstName.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 2.2,
                                      color: AppColor.PRIMARY_DARK),
                                ),
                                SizedBox(height: defaultSize / 2),
                                Text(
                                  _userProfileLogin.email == null
                                      ? ""
                                      : _userProfileLogin.email.toString(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.PRIMARY_LIGHT,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ProfileInfoUI(
                      //   title: 'Profile',
                      //   image: _userProfileLogin.gender == null
                      //       ? Container()
                      //       : _userProfileLogin.gender == "M"
                      //           ? 'assets/images/avatar.png'
                      //           : 'assets/images/favatar.png',
                      //   name: _userProfileLogin == null
                      //       ? ""
                      //       : _userProfileLogin.firstName.toString(),
                      //   email: _userProfileLogin.email == null
                      //       ? ""
                      //       : _userProfileLogin.email.toString(),
                      //   customFunction: () async {
                      //     final userProfile = await AppSessionManager
                      //         .getUserProfileAfterLogin();
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => EditProfile(
                      //               userProfile: userProfile,
                      //             )));
                      //   },
                      // ),
                      SizedBox(
                        height: defaultSize * 2.0,
                      ),
                      ProfileMenuItem(
                        iconSrc: Icons.person,
                        title: 'Edit Profile',
                        press: () async {
                          final userProfile = await AppSessionManager
                              .getUserProfileAfterLogin();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    userProfile: userProfile,
                                    refresh: refresh,
                                  )));
                        },
                      ),
                      ProfileMenuItem(
                        iconSrc: Icons.access_time,
                        title: 'Upcoming Appointments',
                        press: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpcomingAppointmentScreen()));
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
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Future<SuperResponse<bool>> _onLogout() async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await AuthService.logoutUser();
        print(response.data);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          if (response.data == null) {
            print(response.data);
          } else
            showSnackBar("Something went wrong");
        } else
          showSnackBar(response.error);
      } catch (ex) {
        Navigator.of(context).pop();
        showSnackBar("Something went wrong.");
      }
    } else
      showSnackBar("No internet connected");
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
        await _onLogout();
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

  Widget _getImageDisplayWidget() {
    return GestureDetector(
      onTap: () async {
        final userProfile = await AppSessionManager.getUserProfileAfterLogin();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProfile(
                  userProfile: userProfile,
                  refresh: refresh,
                )));
      },
      child: Stack(
        children: [
          if (_userProfileLogin.profileUrl != null)
            Container(
              margin: EdgeInsets.only(bottom: defaultOverride), //10
              height: defaultOverride * 14, //140
              width: defaultOverride * 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: defaultOverride * 0.8, //8
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(_userProfileLogin.profileUrl),
                ),
              ),
            ),
          if (_userProfileLogin.profileUrl == null)
            Container(
              margin: EdgeInsets.only(bottom: defaultOverride), //10
              height: defaultOverride * 14, //140
              width: defaultOverride * 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: defaultOverride * 0.8, //8
                ),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _userProfileLogin.gender == "M"
                        ? AssetImage('assets/images/avatar.png')
                        : AssetImage(
                            'assets/images/favatar.png',
                          )),
              ),
            ),
          Positioned(
            bottom: defaultOverride * 1.5,
            right: defaultOverride * 1.5,
            child: Container(
              height: defaultOverride * 3.2,
              width: defaultOverride * 3.2,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                heightFactor: defaultOverride * 2.5,
                widthFactor: defaultOverride * 2.5,
                child: Icon(Icons.edit,
                    color: AppColor.PRIMARY_MEDIUM,
                    size: defaultOverride * 2.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
