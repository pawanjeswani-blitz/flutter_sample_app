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
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/user_profile.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

// Text Controllers for taking input from text form field
TextEditingController mobilenoController = TextEditingController();
TextEditingController otpController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // bool autoValidate = false;
  String phoneNumber, otp;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final UserProfile _registerUserProfile = UserProfile();
  double defaultOverride;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    // await _checkAndSetInfoBean();
    // _getOTP();
  }

  _checkAndSetInfoBean() async {
    final nonLoginAuthToken = await AppSessionManager.getNonLoginAuthToken();
    if (nonLoginAuthToken == null) {
      //info bean is not set. call the api to set the info bean
      AuthService.getNonAuthToken();
    }
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
    errorStyle:
        GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
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

  Widget _getLoginForm() => Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              // controller: mobilenoController,
              key: _loginFormKey,
              validator: (x) {
                if (x.isEmpty || x.length < 10) {
                  return "Please Enter 10-digit Mobile No.";
                }
                return null;
              },
              cursorColor: AppColor.PRIMARY_DARK,
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
                      _requestOTP();
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
            SizedBox(height: defaultOverride * 1.75),
            TextFormField(
              key: ObjectKey('otp'),
              controller: otpController,
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
            SizedBox(height: defaultOverride * 2.5),
            RoundedButton(buttontext: 'Verify OTP'),
            SizedBox(height: defaultOverride * 3.5),
          ],
        ),
      );

  void _requestOTP() async {
    if (phoneNumber != null && phoneNumber.length == 10) {
      FocusScope.of(context).unfocus();
      final isInternetConnected = await InternetUtil.isInternetConnected();
      if (isInternetConnected) {
        ProgressDialog.showProgressDialog(context);
        final response = await AuthService.getOTP('+91', phoneNumber);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.data) {
          setState(() {});
        } else
          showSnackBar(response.error);
      } else
        showSnackBar("No internet connected");
    } else
      showSnackBar('Enter valid mobile number');
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
