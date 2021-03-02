import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/user_profile_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/dialog/select_gender_dialog.dart';
import 'package:saloonwala_consumer/view/pages/user_profile_ui.dart';
import 'package:saloonwala_consumer/view/widget/profile_info_ui.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class EditProfile extends StatefulWidget {
  final UserProfileLogin userProfile;

  const EditProfile({Key key, this.userProfile}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool readOnly = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _fullNameFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _genderFormKey = GlobalKey<FormState>();
  String firstName,
      lastName,
      email,
      gender,
      name,
      number,
      selectedgender,
      fname,
      address;
  String fsname = "aa";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _fullNameFormKey,
            child: Column(
              children: [
                ProfileInfoUI(
                  title: 'Edit Profile',
                  image: 'assets/images/profile.jpg',
                  name: widget.userProfile.firstName,
                  email: ' ',
                  showBackButton: true,
                ),
                SizedBox(
                  height: defaultSize * 3.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ).copyWith(
                    bottom: defaultSize * 2.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ),
                  child: TextFormField(
                    readOnly: readOnly,
                    // validator: _validatePhoneNumber,
                    cursorColor: AppColor.PRIMARY_DARK,
                    style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                    maxLines: 1,
                    onChanged: (value) {
                      List<String> split = value.split(' ');
                      Map<int, String> values = {
                        for (int i = 0; i < split.length; i++) i: split[i]
                      };
                      final value1 = values[0];
                      final value2 = values[1];
                      firstName = value1;
                      lastName = value2;
                    },
                    decoration: _getTextFormFieldInputDecoration.copyWith(
                      hintText: widget.userProfile.firstName +
                          " " +
                          widget.userProfile.lastName,
                      hintStyle:
                          GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                      suffixIcon: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            setState(() {
                              readOnly = false;
                            });
                          },
                          child: Text(
                            'Edit Name',
                            style: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultSize * 1.75,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ).copyWith(
                    bottom: defaultSize * 2.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ),
                  child: TextFormField(
                    readOnly: readOnly,
                    // validator: _validatePhoneNumber,
                    cursorColor: AppColor.PRIMARY_DARK,
                    style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                    maxLines: 1,
                    onChanged: (value) => email = value,
                    decoration: _getTextFormFieldInputDecoration.copyWith(
                      hintText: widget.userProfile.email,
                      hintStyle:
                          GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                      suffixIcon: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            setState(() {
                              readOnly = false;
                            });
                          },
                          child: Text(
                            'Edit Email',
                            style: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultSize * 1.75,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ).copyWith(
                    bottom: defaultSize * 2.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    // validator: _validatePhoneNumber,
                    cursorColor: AppColor.PRIMARY_DARK,

                    style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                    maxLines: 1,
                    // onChanged: (value) => gender = value,
                    decoration: _getTextFormFieldInputDecoration.copyWith(
                      hintText:
                          widget.userProfile.gender == "M" ? 'Male' : 'Female',
                      suffixIcon: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            // _requestOTP();
                            // setState(() {
                            //   // readOnly = false;
                            // });
                            _onEditGender();
                          },
                          child: Text(
                            'Edit Gender',
                            style: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultSize * 1.75,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ).copyWith(
                    bottom: defaultSize * 2.0,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultSize * 1.0,
                  ),
                  child: TextFormField(
                    readOnly: readOnly,
                    // validator: _validatePhoneNumber,
                    cursorColor: AppColor.PRIMARY_DARK,
                    style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                    maxLines: 4,
                    onChanged: (value) => address = value,
                    decoration: _getTextFormFieldInputDecoration.copyWith(
                      hintText: widget.userProfile.address,
                      hintStyle:
                          GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                      suffixIcon: FlatButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            setState(() {
                              readOnly = false;
                            });
                          },
                          child: Text(
                            'Edit Address',
                            style: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultSize * 1.75,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultSize * 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          readOnly = true;
                        });
                      },
                      child: RoundedButtonOutlineBorder(
                        buttontext: 'Cancel',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_fullNameFormKey.currentState.validate()) {
                          await _onEditProfileClick();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BottomNavBar()));
                        } else {
                          showSnackBar("try agian");
                        }
                      },
                      child: RoundedButtonDarkSave(
                        buttontext: 'save',
                      ),
                    )
                  ],
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

  void _onEditGender() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SelectGenderDialog();
        }).then((val) {
      setState(() {
        gender = val;
      });
    });
  }

  Future<SuperResponse<bool>> _onEditProfileClick() async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response =
            await UserProfileService.updateUserProfileFromEditProfile(
          firstName == null ? widget.userProfile.firstName : firstName,
          lastName == null ? widget.userProfile.lastName : lastName,
          widget.userProfile.dob,
          widget.userProfile.cityName,
          widget.userProfile.stateName,
          gender,
          email == null ? widget.userProfile.email : email,
          address == null ? widget.userProfile.address : address,
        );
        print(response.data);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            //user is register
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

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone Number is required';
    } else if (value.length < 10) {
      return 'Please enter 10-digit Phone Number';
    }
    return null;
  }

  var _getTextFormFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintStyle: GoogleFonts.poppins(color: AppColor.PRIMARY_LIGHT),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: AppColor.PRIMARY_MEDIUM, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: AppColor.PRIMARY_MEDIUM, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: AppColor.PRIMARY_MEDIUM, width: 2.0)),
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
}
