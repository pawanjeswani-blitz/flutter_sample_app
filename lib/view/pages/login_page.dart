import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:device_info/device_info.dart';
import 'package:saloonwala_consumer/api/auth_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/dialog/no_internet_dialog.dart';
import 'package:saloonwala_consumer/view/pages/dialog/valid_otp_dailog.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/pages/select_gender.dart';
import 'package:saloonwala_consumer/view/pages/user_profile_ui.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

// Text Controllers for taking input from text form field
TextEditingController _mobilenoController = TextEditingController();
TextEditingController _otpController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool autoValidate = false;
  String phoneNumber, otp;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormKey2 = GlobalKey<FormState>();
  // final UserProfileLoginResponse _registerUserProfile =
  //     UserProfileLoginResponse();
  double defaultOverride;
  bool readOnly = true;
  @override
  void initState() {
    super.initState();
    _checkAndSetInfoBean();
  }

  _getData() async {
    // await _checkAndSetInfoBean();
    // _getOTP();
  }

  _checkAndSetInfoBean() async {
    final nonLoginAuthToken = await AppSessionManager.getNonLoginAuthToken();
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (nonLoginAuthToken == null) {
      if (isInternetConnected) {
        ProgressDialog.showProgressDialog(context);
        try {
          AuthService.getNonAuthToken();
          //close the progress dialog
          Navigator.of(context).pop();
        } catch (ex) {
          Navigator.of(context).pop();
          showSnackBar("ex");
        }
      } else
        _onShow();
    }
  }

  void _onShow() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NoInternetDialog(
            customFunction: () {
              _checkAndSetInfoBean();
              Navigator.of(context).pop();
            },
          );
        });
  }

  _getUserProfileData() async {
    Future<UserProfile> userProfileData = AppSessionManager.getUserProfile();
    userProfileData.then((value) {
      if (value.firstName == null && value.lastName == null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SelectGender()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    });
  }

  // _getOTP() async {
  //   AuthService.getOTP();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/login_background.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: defaultSize * 12,
                ),
                _getWelcomeTitleWidget(),
                SizedBox(
                  height: defaultSize * 7.0,
                ),
                Center(
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: defaultSize * 4.8,
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultSize * 2.0,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: defaultSize * 2.0, right: defaultSize * 2.0),
                  child: _getLoginForm(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  var _getTextFormFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintStyle: GoogleFonts.poppins(color: AppColor.PRIMARY_LIGHT),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    errorStyle: GoogleFonts.poppins(
        color: AppColor.PRIMARY_DARK,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5),
    disabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.only(left: 15, bottom: 14, top: 14, right: 15),
    // hintText: hint,
  );

  Widget _getWelcomeTitleWidget() => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          'Welcome to Saloonwala',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: defaultOverride * 2.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        decoration: BoxDecoration(
            color: Color(0x3F000000),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0))),
      );

  Widget _getLoginForm() => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _loginFormKey1,
              child: TextFormField(
                validator: _validatePhoneNumber,
                cursorColor: AppColor.PRIMARY_DARK,
                enableSuggestions: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                maxLines: 1,
                onChanged: (value) => phoneNumber = value,
                decoration: _getTextFormFieldInputDecoration.copyWith(
                  hintText: 'Phone Number',
                  prefixIcon: Container(
                    margin: EdgeInsets.only(left: defaultOverride * 1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+91 ',
                          style: GoogleFonts.poppins(
                            color: AppColor.PRIMARY_DARK,
                            // fontSize: MediaQuery.of(context).size.width * 0.040,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  suffixIcon: FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {
                        if (_loginFormKey1.currentState.validate()) {
                          _requestOTP();
                          readOnly = false;
                        } else {
                          showSnackBar("Please Enter 10-digit phone number");
                        }
                      },
                      child: Text(
                        'Get OTP',
                        style: GoogleFonts.poppins(
                            color: AppColor.PRIMARY_DARK,
                            fontSize: defaultOverride * 1.75,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0),
                      )),
                ),
              ),
            ),
            SizedBox(height: defaultOverride * 1.75),
            Form(
              key: _loginFormKey2,
              child: TextFormField(
                key: ObjectKey('otp'),
                readOnly: readOnly,
                validator: _validateOTP,
                // controller: _otpController,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: AppColor.PRIMARY_DARK,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                maxLines: 1,
                onChanged: (value) => otp = value,
                decoration: _getTextFormFieldInputDecoration.copyWith(
                    hintText: 'Enter 4-digit OTP'),
              ),
            ),
            SizedBox(height: defaultOverride * 2.5),
            GestureDetector(
                child: RoundedButton(buttontext: 'Verify OTP'),
                onTap: () async {
                  if (_loginFormKey1.currentState.validate() &&
                      _loginFormKey2.currentState.validate()) {
                    await _onVerifyOTPClick();
                    _getUserProfileData();
                  } else {
                    showSnackBar("Please enter phone number and otp");
                  }
                }),
            SizedBox(height: defaultOverride * 3.5),
          ],
        ),
      );
  void _onRequestOTPShow() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NoInternetDialog(
            customFunction: () {
              _requestOTP();
            },
          );
        });
  }

  void _onVerifyOTP() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NoInternetDialog(
            customFunction: () {
              _onVerifyOTPClick();
              Navigator.of(context).pop();
            },
          );
        });
  }

  void _onValidOTP() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EnterValidOTP(
            customFunction: () {
              // _onVerifyOTPClick();
              Navigator.of(context).pop();
            },
          );
        });
  }

  void _requestOTP() async {
    if (_loginFormKey1.currentState.validate()) {
      _loginFormKey1.currentState.save();
      FocusScope.of(context).unfocus();
      final isInternetConnected = await InternetUtil.isInternetConnected();
      if (isInternetConnected) {
        ProgressDialog.showProgressDialog(context);
        final response = await AuthService.getOTP('+91', phoneNumber);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.data == null) {
          setState(() {});
        } else
          showSnackBar(response.error);
      } else
        _onRequestOTPShow();
    } else
      showSnackBar('Enter valid mobile number');
  }

  Future<SuperResponse<bool>> _onVerifyOTPClick() async {
    if (_loginFormKey2.currentState.validate()) {
      _loginFormKey2.currentState.save();
      if (otp != null && otp.length == 4) {
        FocusScope.of(context).unfocus();
        final isInternetConnected = await InternetUtil.isInternetConnected();
        if (isInternetConnected) {
          ProgressDialog.showProgressDialog(context);
          try {
            final response =
                await AuthService.verifyLoginOTP('+91', phoneNumber, otp);
            //close the progress dialog
            Navigator.of(context).pop();
            if (response.error == null) {
              //check the user is already register or not
              if (response.data != null) {
                //user is register
                print("registered");
              } else
                showSnackBar("Something went wrong");
            } else
              showSnackBar(response.error);
          } catch (ex) {
            Navigator.of(context).pop();
            _onValidOTP();
          }
        } else
          _onVerifyOTP();
      } else
        showSnackBar('Please enter OTP');
    }
  }

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone Number is required';
    } else if (value.length < 10) {
      return 'Please enter 10-digit Phone Number';
    }
    return null;
  }

  String _validateOTP(String value) {
    if (value.isEmpty) {
      return 'OTP is required';
    } else if (value.length < 4) {
      return 'OTP must be at least 4 characters';
    }
    return null;
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
