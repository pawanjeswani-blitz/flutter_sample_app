import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/feedback_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/appointment_salon_details.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SalonRatingScreen extends StatefulWidget {
  final int bookingId;
  final SalonDetails salonData;

  const SalonRatingScreen({Key key, this.bookingId, this.salonData})
      : super(key: key);
  @override
  _SalonRatingScreenState createState() => _SalonRatingScreenState();
}

class _SalonRatingScreenState extends State<SalonRatingScreen> {
  double rating = 0;
  String comment;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      key: _scaffoldKey,
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
                  Container(
                    width: defaultSize * 18.0,
                    child: Text(
                      "Rate ${widget.salonData.name.toUpperCase()}",
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        fontSize: defaultSize * 1.8,
                        color: AppColor.PRIMARY_DARK,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defaultSize * 1.25,
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
                  fontSize: defaultSize * 1.8,
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
                  hintText:
                      'Write your feedback for ${widget.salonData.name.toUpperCase()}.....',
                  hintStyle: GoogleFonts.poppins(
                      fontStyle: FontStyle.italic,
                      fontSize: defaultSize * 1.5,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (value) => comment = value,
              ),
            ),
            rating == 0.0
                ? Container()
                : GestureDetector(
                    onTap: () async {
                      await _onPostRating();
                      await _onPostComment();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BottomNavBar()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: defaultSize * 4.0,
                        left: defaultSize * 2.0,
                        right: defaultSize * 2.0,
                      ),
                      child: RoundedButtonDark(
                        buttontext: 'Submit',
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<SuperResponse<bool>> _onPostRating() async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await FeedBackService.postsalonRating(
            widget.salonData.id, widget.bookingId, rating.toInt());
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            //user is register
            print(response.data);
            showSnackBar("Feedback submitted succesfully");
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

  Future<SuperResponse<bool>> _onPostComment() async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await FeedBackService.postsalonComment(
            widget.salonData.id,
            widget.bookingId,
            comment == '' && comment == null ? '' : comment);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            //user is register
            print(response.data);
            showSnackBar(" ");
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
    final snackBar = SnackBar(
      content: Text(errorText),
      duration: Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
