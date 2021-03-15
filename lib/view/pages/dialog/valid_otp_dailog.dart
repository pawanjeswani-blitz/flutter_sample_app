import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class EnterValidOTP extends StatefulWidget {
  final Function customFunction;

  const EnterValidOTP({Key key, this.customFunction}) : super(key: key);
  @override
  _EnterValidOTPState createState() => _EnterValidOTPState();
}

class _EnterValidOTPState extends State<EnterValidOTP> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultSize * 2.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: defaultSize * 2.5, horizontal: defaultSize * 2.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: defaultSize * 2.0),
            Container(
              height: defaultSize * 16.0,
              width: defaultSize * 16.0,
              child: Center(
                child: Image.asset('assets/images/otp.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: defaultSize * 0.75, horizontal: defaultSize * 0.90),
              child: Text(
                'Oops wrong OTP',
                style: GoogleFonts.poppins(
                    fontSize: defaultSize * 2.5, color: AppColor.PRIMARY_DARK),
              ),
            ),
            Text(
              'Please enter valid OTP again',
              style: GoogleFonts.poppins(
                  fontSize: defaultSize * 1.75, color: AppColor.PRIMARY_DARK),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: defaultSize * 1.35),
              child: Center(
                  child: GestureDetector(
                onTap: () {
                  widget.customFunction();
                },
                child: RoundedButtonOutlineDialogValidOTP(
                  buttontext: 'Enter Again',
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
