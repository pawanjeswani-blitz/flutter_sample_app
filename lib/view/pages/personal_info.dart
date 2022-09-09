import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/user_profile_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class PersonalInfo extends StatefulWidget {
  final String gender;

  const PersonalInfo({Key key, this.gender}) : super(key: key);
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  DateTime _selectedDateTime;
  String dob = DateUtil.getDisplayFormatDate(DateTime.now());
  // Text Controllers for taking input from text form field
  TextEditingController dobController = TextEditingController();
  String firstName, lastName, city, state, email, address;
  double defaultSizeOveride;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserProfile _userProfile;
  UserProfileLogin _userProfileLogin;

  void initState() {
    super.initState();

    // Get User object from Preferences
    AppSessionManager.getUserProfile().then((value) {
      setState(() {
        _userProfile = value;
      });
    });
    AppSessionManager.getUserProfileAfterLogin().then((value) {
      setState(() {
        _userProfileLogin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultSizeOveride = defaultSize;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_DARK])),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: defaultSize * 10,
                      ),
                      Text(
                        "PERSONAL INFORMATION",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: defaultSize * 2.8,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: defaultSize * 7.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: defaultSize * 2.2, right: defaultSize * 2.2),
                        child: TextFormField(
                          onChanged: (value) {
                            List<String> split = value.split(' ');
                            Map<int, String> values = {
                              for (int i = 0; i < split.length; i++) i: split[i]
                            };
                            final value1 = values[0];
                            final value2 = values[1];
                            firstName = value1;
                            lastName = value2 == null ? " " : value2;
                          },
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'Full Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Required Field";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: defaultSize * 2.2, right: defaultSize * 2.2),
                        child: TextFormField(
                          controller: dobController,
                          readOnly: true,
                          onTap: _showDatePicker,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: dob,
                            hintStyle: TextStyle(color: AppColor.PRIMARY_DARK),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: AppColor.PRIMARY_DARK,
                            ),
                            prefixIcon: Container(
                              margin: EdgeInsets.only(left: defaultSize * 1.25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'DOB  ',
                                    style: GoogleFonts.poppins(
                                      color: AppColor.PRIMARY_DARK,
                                      fontSize: defaultSize * 1.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == "" ||
                                value ==
                                    DateUtil.getDisplayFormatDate(
                                        DateTime.now())) {
                              return "DOB cannot be current date";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: defaultSize * 2.2, right: defaultSize * 2.2),
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          onChanged: (value) => email = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'email@example.com',
                            suffixIcon: Icon(
                              Icons.email_rounded,
                              color: AppColor.PRIMARY_DARK,
                            ),
                            prefixIcon: Container(
                              margin: EdgeInsets.only(left: defaultSize * 1.25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Email  ',
                                    style: GoogleFonts.poppins(
                                        color: AppColor.PRIMARY_DARK,
                                        fontSize: defaultSize * 1.8
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          validator: _validateEmail,
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: defaultSize * 2.2, right: defaultSize * 2.2),
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          onChanged: (value) => city = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'example: Mumbai',
                            suffixIcon: Icon(
                              Icons.location_city,
                              color: AppColor.PRIMARY_DARK,
                            ),
                            prefixIcon: Container(
                              margin: EdgeInsets.only(left: defaultSize * 1.25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'City  ',
                                    style: GoogleFonts.poppins(
                                        color: AppColor.PRIMARY_DARK,
                                        fontSize: defaultSize * 1.8
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "City Name cannot be empty";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: defaultSize * 2.2, right: defaultSize * 2.2),
                        child: TextFormField(
                          // controller: stateController,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          onChanged: (value) => state = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'example: Maharashtra',
                            suffixIcon: Icon(
                              Icons.location_on,
                              color: AppColor.PRIMARY_DARK,
                            ),
                            prefixIcon: Container(
                              margin: EdgeInsets.only(left: defaultSize * 1.25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'State  ',
                                    style: GoogleFonts.poppins(
                                        color: AppColor.PRIMARY_DARK,
                                        fontSize: defaultSize * 1.8
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "State Name cannot be empty";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: defaultSize * 2.2, right: defaultSize * 2.2),
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 4,
                          onChanged: (value) => address = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'Address',
                          ),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return "Address cannot be empty";
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 8.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            if (_userProfile.firstName == null &&
                                _userProfile.gender == null &&
                                _userProfile.dob == null &&
                                widget.gender == null) {
                              showSnackBar(
                                  "Please fill all the required fields");
                            } else {
                              await _onUpdateClick();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BottomNavBar()));
                            }
                          } else {
                            showSnackBar("Please fill the required details");
                          }
                          // print(firstName);
                        },
                        child: RoundedButtonDark(
                          buttontext: 'Get Started !',
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 5.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.isNotEmpty && !regExp.hasMatch(value)) {
      return 'Please enter valid Email address';
    } else {
      return null;
    }
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
    disabledBorder: InputBorder.none,
    errorStyle:
        GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
    contentPadding: EdgeInsets.only(left: 15, bottom: 14, top: 14, right: 15),
    // hintText: hint,
  );

  void _showDatePicker() async {
    _selectedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (_selectedDateTime != null) {
      setState(() {
        print(
            'Selected Date is  -> ${DateUtil.getDisplayFormatDate(_selectedDateTime)}');
        dob = DateUtil.getDisplayFormatDate(_selectedDateTime);
        dobController.text = dob;
      });
    }
  }

  Future<SuperResponse<bool>> _onUpdateClick() async {
    FocusScope.of(context).unfocus();
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await UserProfileService.updateUserProfile(
            firstName,
            lastName,
            dob,
            city,
            state,
            widget.gender,
            email == null && email == "" ? "" : email,
            address);
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
        showSnackBar("Something went wrong.");
      }
    } else
      showSnackBar("No internet connected");
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
