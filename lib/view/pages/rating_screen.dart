import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SalonRatingScreen extends StatefulWidget {
  @override
  _SalonRatingScreenState createState() => _SalonRatingScreenState();
}

class _SalonRatingScreenState extends State<SalonRatingScreen> {
  double rating = 0;
  String comment;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: defaultSize * 32.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_MEDIUM]),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(45.0),
                    bottomRight: Radius.circular(45.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(true),
                        child: Container(
                          margin: EdgeInsets.only(
                            left: defaultSize * 1.5,
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            size: defaultSize * 4.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "Feedback",
                        style: GoogleFonts.poppins(
                          fontSize: defaultSize * 3.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(),
                    ],
                  ),
                  Container(
                    height: defaultSize * 10.0,
                    width: defaultSize * 10.0,
                    margin: EdgeInsets.only(
                      top: defaultSize * 2.5,
                    ),
                    child: Image.asset('assets/images/feedback.png'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: defaultSize * 5.0,
                left: defaultSize * 3.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Rate BBLUNT",
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 2.0,
                      color: AppColor.PRIMARY_DARK,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: defaultSize * 1.5,
                  ),
                  SmoothStarRating(
                    rating: rating,
                    isReadOnly: false,
                    size: defaultSize * 3.0,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    color: AppColor.PRIMARY_MEDIUM,
                    borderColor: AppColor.PRIMARY_MEDIUM,
                    starCount: 5,
                    allowHalfRating: false,
                    spacing: 2.0,
                    onRated: (value) {
                      print("rating value -> $value");
                      setState(() {
                        rating = value;
                      });
                      // print("rating value dd -> ${value.truncate()}");
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: defaultSize * 5.0,
                left: defaultSize * 3.0,
                bottom: defaultSize * 2.0,
              ),
              child: Text(
                "Comment",
                style: GoogleFonts.poppins(
                  fontSize: defaultSize * 2.0,
                  color: AppColor.PRIMARY_DARK,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: defaultSize * 2.5,
                left: defaultSize * 2.5,
              ),
              child: TextFormField(
                maxLines: 4,
                decoration: _getTextFormFieldInputDecoration.copyWith(
                    hintText: 'Comment'),
                onChanged: (value) => comment = value,
              ),
            ),
            rating == 0.0
                ? Container()
                : Container(
                    margin: EdgeInsets.only(
                      top: defaultSize * 4.0,
                      left: defaultSize * 2.0,
                      right: defaultSize * 2.0,
                    ),
                    child: RoundedButtonDark(
                      buttontext: 'Submit',
                    ),
                  )
          ],
        ),
      ),
    );
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
