import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: defaultSize * 20,
          width: double.infinity,
          margin: EdgeInsets.only(
              left: defaultSize * 1.0,
              right: defaultSize * 1.0,
              top: defaultSize * 0.5,
              bottom: defaultSize * 1.2),
          child: Card(
            elevation: 2.0,
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: defaultSize * 2.0,
                    top: defaultSize * 1.5,
                  ),
                  child: Text(
                    "BBLUNT APPOINTMENT",
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 2.0,
                      color: AppColor.PRIMARY_MEDIUM,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: defaultSize * 2.0,
                    top: defaultSize * 0.5,
                  ),
                  child: Text(
                    "DATE : 12/02/03",
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 1.75,
                      color: AppColor.PRIMARY_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: defaultSize * 2.0,
                    top: defaultSize * 0.5,
                  ),
                  child: Text(
                    "Time: 3:00 PM",
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 1.75,
                      color: AppColor.PRIMARY_MEDIUM,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Divider(
                  thickness: defaultSize * 0.065,
                ),
                Row(
                  children: [
                    FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {},
                      child: Text(
                        'View Details',
                        style: GoogleFonts.poppins(
                            color: AppColor.PRIMARY_DARK,
                            fontSize: defaultSize * 1.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0),
                      ),
                    ),
                    Spacer(),
                    FlatButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () async {},
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                            color: Colors.red[800],
                            fontSize: defaultSize * 1.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
