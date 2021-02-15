import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  DateTime _selectedDateTime;
  String dob = DateUtil.getDisplayFormatDate(DateTime.now());
  // Text Controllers for taking input from text form field
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  double defaultSizeOveride;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultSizeOveride = defaultSize;
    return Scaffold(
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
                          controller: nameController,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'Full Name',
                            suffixIcon: Icon(
                              Icons.perm_identity,
                              color: AppColor.PRIMARY_DARK,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Full Name cannot be empty";
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
                            if (value == "") {
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
                          controller: cityController,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'City',
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return "City Name cannot be empty";
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
                          controller: stateController,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: 'State',
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return "State Name cannot be empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 8.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            print("validation Done");
                          } else {
                            print("try agian");
                          }
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
}
