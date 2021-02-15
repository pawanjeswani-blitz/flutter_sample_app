import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class SelectGender extends StatefulWidget {
  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  String gender;
  String selectedGender;
  String maleSelected = 'assets/images/male.png';
  String femaleSelected = 'assets/images/female.png';
  double defaultSizeOveride;
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
                child: Column(
                  children: [
                    SizedBox(
                      height: defaultSize * 10.0,
                    ),
                    Text(
                      "PERSONAL INFORMATION",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: defaultSize * 2.8,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                    ),
                    SizedBox(
                      height: defaultSize * 2.0,
                    ),
                    Text(
                      "Please Specify Gender",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: defaultSize * 2.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5),
                    ),
                    SizedBox(
                      height: defaultSize * 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                selectedGender = "Male";
                                maleSelected =
                                    'assets/images/male-selected.png';
                                femaleSelected = 'assets/images/female.png';
                                gender = 'M';
                                print(gender);
                              });
                            },
                            child: _getGenderButton('Male', maleSelected)),
                        SizedBox(width: 12),
                        InkWell(
                            onTap: () {
                              setState(() {
                                selectedGender = "Female";

                                femaleSelected =
                                    'assets/images/female-selected.png';
                                maleSelected = 'assets/images/male.png';
                                gender = 'F';
                                print(gender);
                              });
                            },
                            child: _getGenderButton('Female', femaleSelected)),
                      ],
                    ),
                    SizedBox(
                      height: defaultSize * 8.0,
                    ),
                    selectedGender != null
                        ? Container(
                            margin: EdgeInsets.only(
                                left: defaultSize * 1.8,
                                right: defaultSize * 1.8),
                            child: RoundedButtonDark(
                              buttontext: 'Continue',
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: defaultSize * 5.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGenderButton(String title, String imagePath) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: defaultSizeOveride * 20.0,
              width: defaultSizeOveride * 20.0,
            ),
            // SizedBox(height: defaultSizeOveride * 0.75),
            Text(title,
                style: GoogleFonts.poppins(
                  color: selectedGender == title
                      ? AppColor.LOGIN_BACKGROUND
                      : Colors.white,
                  fontSize: defaultSizeOveride * 2.0,
                ))
          ],
        ),
      );
}
