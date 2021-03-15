import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/pages/edit_profile.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class SelectGenderDialog extends StatefulWidget {
  @override
  _SelectGenderDialogState createState() => _SelectGenderDialogState();
}

class _SelectGenderDialogState extends State<SelectGenderDialog> {
  String selectedGender, gender;
  double defaultOverride;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultSize * 2.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: defaultSize * 2.75, horizontal: defaultSize * 0.90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: defaultSize * 2.0),
            Text('Choose Gender',
                style: GoogleFonts.poppins(
                    color: AppColor.DARK_ACCENT, fontSize: defaultSize * 2.35)),
            SizedBox(height: defaultSize * 3.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedGender = "Male";
                        gender = 'M';
                      });
                    },
                    child:
                        _getGenderCard('Male', 'assets/images/male_icon.png')),
                SizedBox(width: defaultSize * 2.5),
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedGender = "Female";
                        gender = 'F';
                      });
                    },
                    child: _getGenderCard(
                        'Female', 'assets/images/female_icon.png')),
              ],
            ),
            SizedBox(height: defaultSize * 3.5),
            GestureDetector(
              onTap: () {
                // print(gender);
                // Navigator.of(context).pop(MaterialPageRoute(
                //     builder: (context) => EditProfile(
                //           gender: gender,
                //         )));
                Navigator.pop(context, gender);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: defaultSize * 2.5, right: defaultSize * 2.5),
                child: RoundedButton(
                  buttontext: 'Proceed',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getGenderCard(String title, String imagePath) => Container(
        width: defaultOverride * 10.0,
        height: defaultOverride * 10.0,
        decoration: BoxDecoration(
            color: selectedGender == title
                ? AppColor.PRIMARY_MEDIUM
                : AppColor.VERY_LIGHT_GREEN,
            borderRadius: BorderRadius.circular(defaultOverride * 2.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath,
                height: defaultOverride * 3.5,
                width: defaultOverride * 3.5,
                color: selectedGender == title
                    ? Colors.white
                    : AppColor.PRIMARY_DARK),
            SizedBox(height: defaultOverride * 1.0),
            Text(title,
                style: GoogleFonts.poppins(
                    color: selectedGender == title
                        ? Colors.white
                        : AppColor.PRIMARY_DARK,
                    fontSize: defaultOverride * 1.6))
          ],
        ),
      );
}
