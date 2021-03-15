import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';

class RoundedButton extends StatelessWidget {
  final String buttontext;

  const RoundedButton({Key key, this.buttontext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: defaultSize * 1.35),
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
      child: Center(
        child: Text(buttontext,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: defaultSize * 1.8,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500)),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.PRIMARY_DARK),
    );
  }
}

class RoundedButtonDark extends StatelessWidget {
  final String buttontext;

  const RoundedButtonDark({Key key, this.buttontext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: defaultSize * 1.35),
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
      child: Center(
        child: Text(buttontext,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: defaultSize * 2.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500)),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.PRIMARY_DARK),
    );
  }
}

class RoundedButtonDarkSave extends StatelessWidget {
  final String buttontext;

  const RoundedButtonDarkSave({Key key, this.buttontext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      width: defaultSize * 15.0,
      padding: EdgeInsets.symmetric(vertical: defaultSize * 1.35),
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
      child: Center(
        child: Text(buttontext,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: defaultSize * 2.2,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500)),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColor.PRIMARY_DARK),
    );
  }
}

class RoundedButtonOutlineBorder extends StatelessWidget {
  final String buttontext;

  const RoundedButtonOutlineBorder({Key key, this.buttontext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
        width: defaultSize * 15.0,
        padding: EdgeInsets.symmetric(vertical: defaultSize * 1.3),
        margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
        child: Center(
          child: Text(buttontext,
              style: GoogleFonts.poppins(
                  color: AppColor.PRIMARY_DARK,
                  fontSize: defaultSize * 2.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500)),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              width: defaultSize * 0.2,
              color: AppColor.PRIMARY_DARK,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30))));
  }
}

class RoundedButtonSlot extends StatelessWidget {
  final String buttontext;

  const RoundedButtonSlot({Key key, this.buttontext}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: defaultSize * 1.35),
      margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
      child: Center(
        child: Text(buttontext,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: defaultSize * 2.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500)),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromRGBO(172, 125, 83, 1)),
    );
  }
}

class RoundedButtonOutlineDialog extends StatelessWidget {
  final String buttontext;

  const RoundedButtonOutlineDialog({Key key, this.buttontext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
        width: defaultSize * 13.0,
        padding: EdgeInsets.symmetric(vertical: defaultSize * 0.5),
        margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
        child: Center(
          child: Text(buttontext,
              style: GoogleFonts.poppins(
                  color: AppColor.PRIMARY_DARK,
                  fontSize: defaultSize * 2.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500)),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              width: defaultSize * 0.2,
              color: AppColor.PRIMARY_DARK,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30))));
  }
}

class RoundedButtonOutlineDialogValidOTP extends StatelessWidget {
  final String buttontext;

  const RoundedButtonOutlineDialogValidOTP({Key key, this.buttontext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
        width: defaultSize * 16.0,
        padding: EdgeInsets.symmetric(vertical: defaultSize * 0.5),
        margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.4),
        child: Center(
          child: Text(buttontext,
              style: GoogleFonts.poppins(
                  color: AppColor.PRIMARY_DARK,
                  fontSize: defaultSize * 2.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500)),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              width: defaultSize * 0.2,
              color: AppColor.PRIMARY_DARK,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30))));
  }
}
