import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class NoInternetDialog extends StatefulWidget {
  final Function customFunction;

  const NoInternetDialog({Key key, this.customFunction}) : super(key: key);
  @override
  _NoInternetDialogState createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<NoInternetDialog> {
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
            vertical: defaultSize * 2.5, horizontal: defaultSize * 2.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: defaultSize * 2.0),
            Container(
              height: defaultSize * 16.0,
              width: defaultSize * 16.0,
              child: Center(
                child: Image.asset('assets/images/no-connection.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: defaultSize * 0.75, horizontal: defaultSize * 0.90),
              child: Text(
                'Oops!',
                style: GoogleFonts.poppins(
                    fontSize: defaultSize * 3.5, color: AppColor.PRIMARY_DARK),
              ),
            ),
            Text(
              'No internet connection\ncheck your connection and try again',
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
                child: RoundedButtonOutlineDialog(
                  buttontext: 'Retry',
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
