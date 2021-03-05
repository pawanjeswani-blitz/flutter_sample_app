import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/get_appointment_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/appointment_response.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class ViewBookingDetails extends StatefulWidget {
  final int bookingId;
  final Color cardcolor;
  const ViewBookingDetails({Key key, this.bookingId, this.cardcolor})
      : super(key: key);
  @override
  _ViewBookingDetailsState createState() => _ViewBookingDetailsState();
}

class _ViewBookingDetailsState extends State<ViewBookingDetails> {
  double defaultSize;
  AppointmentResponse _appointmentResponse;
  UserProfileLogin _userProfileLogin;
  var time;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await getSingleAppointment(widget.bookingId);
    AppSessionManager.getUserProfileAfterLogin().then((value) {
      setState(() {
        _userProfileLogin = value;
      });
    });
    setState(() {
      time =
          "${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(_appointmentResponse.startTime))}- ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(_appointmentResponse.endTime))} ";
    });
  }

  Future<SuperResponse<AppointmentResponse>> getSingleAppointment(
      int bookingId) async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response =
            await GetAppointmentService.getSingleAppointment(bookingId);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data != null) {
            //user is register
            print(response.data);
            _appointmentResponse = response.data;
            print(_appointmentResponse.date);
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSizeOver = SizeConfig.defaultSize;
    defaultSize = defaultSizeOver;
    return Scaffold(
      key: _scaffoldKey,
      body: _appointmentResponse != null
          ? _getViewBookingDetails()
          : Center(child: CircularProgressIndicator()),
    );
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  int getSaved() {
    int saved = 0;
    for (int i = 0; i < _appointmentResponse.serviceInfo.length; i++) {
      int _getDiscountPercentage() {
        if (_appointmentResponse.serviceInfo[i].globalDiscount != null &&
            _appointmentResponse.serviceInfo[i].globalDiscount > 0)
          return _appointmentResponse.serviceInfo[i].globalDiscount;
        else
          return _appointmentResponse.serviceInfo[i].serviceDiscount ?? 0;
      }

      int _getDiscountedPrice(int amount) {
        int percentageDiscount = _getDiscountPercentage();
        double discount = amount * percentageDiscount / 100;
        return (amount - discount).toInt();
      }

      int _getTotalSaved(int amount, actualamount) {
        return (actualamount - amount).toInt();
      }

      saved += _getTotalSaved(
          _userProfileLogin.gender == "M"
              ? _getDiscountedPrice(
                  _appointmentResponse.serviceInfo[i].maleRate)
              : _getDiscountedPrice(
                  _appointmentResponse.serviceInfo[i].femaleRate),
          _userProfileLogin.gender == "M"
              ? _appointmentResponse.serviceInfo[i].maleRate
              : _appointmentResponse.serviceInfo[i].femaleRate);
    }
    return saved;
  }

  Widget _getViewBookingDetails() => SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: defaultSize * 3.0),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: defaultSize * 3.0),
                          height: defaultSize * 11.0,
                          width: defaultSize * 11.0,
                          child: Image.asset('assets/images/waiting.gif')),
                      Text(
                        "Booking Details",
                        style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColor.DARK_ACCENT),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: defaultSize * 3.25),
                child: Card(
                  elevation: defaultSize * 1.0,
                  color: widget.cardcolor,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: defaultSize * 2.0),
                        child: Text(
                          " APPOINTMENT",
                          style: GoogleFonts.poppins(
                              color: AppColor.DARK_ACCENT,
                              fontWeight: FontWeight.w600,
                              fontSize: defaultSize * 2.0),
                        ),
                      ),
                      Text(
                        "Date: ${_appointmentResponse.date}",
                        style: GoogleFonts.poppins(
                            color: AppColor.DARK_ACCENT,
                            fontWeight: FontWeight.w500,
                            fontSize: defaultSize * 1.5),
                      ),
                      Text(
                        "TIME: ${time.toString()}",
                        style: GoogleFonts.poppins(
                            color: AppColor.DARK_ACCENT,
                            fontWeight: FontWeight.w500,
                            fontSize: defaultSize * 1.5),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: defaultSize * 3.0,
                            vertical: defaultSize * 2.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "SPECIALIST SELECTED",
                              style: GoogleFonts.poppins(
                                color: Color.fromRGBO(172, 125, 83, 1),
                                fontSize: defaultSize * 1.45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: defaultSize * 1.85),
                            Expanded(
                              child: Divider(
                                color: Color.fromRGBO(216, 206, 197, 0.32),
                                thickness: defaultSize * 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: defaultSize * 2.0),
                        child: Text(
                          "${_appointmentResponse.empInfo.firstName.toString() + ' ' + _appointmentResponse.empInfo.lastName.toString()}",
                          style: GoogleFonts.poppins(
                              color: AppColor.DARK_ACCENT,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                              fontSize: defaultSize * 2.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: defaultSize * 3.0,
                          right: defaultSize * 3.0,
                          top: defaultSize * 2.0,
                          // bottom: defaultSize * 1.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "SERVICE SELECTED",
                              style: GoogleFonts.poppins(
                                color: Color.fromRGBO(172, 125, 83, 1),
                                fontSize: defaultSize * 1.45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: defaultSize * 1.85),
                            Expanded(
                              child: Divider(
                                color: Color.fromRGBO(216, 206, 197, 0.32),
                                thickness: defaultSize * 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            left: defaultSize * 3.0,
                            right: defaultSize * 3.0,
                            bottom: defaultSize * 2.0),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _appointmentResponse.serviceInfo.length,
                            itemBuilder: (BuildContext context, int index) {
                              int _getDiscountPercentage() {
                                if (_appointmentResponse.serviceInfo[index]
                                            .globalDiscount !=
                                        null &&
                                    _appointmentResponse
                                            .serviceInfo[index].globalDiscount >
                                        0)
                                  return _appointmentResponse
                                      .serviceInfo[index].globalDiscount;
                                else
                                  return _appointmentResponse
                                          .serviceInfo[index].serviceDiscount ??
                                      0;
                              }

                              int _getDiscountedPrice(int amount) {
                                int percentageDiscount =
                                    _getDiscountPercentage();
                                double discount =
                                    amount * percentageDiscount / 100;
                                return (amount - discount).toInt();
                              }

                              return Row(
                                children: [
                                  Text(
                                    "${_appointmentResponse.serviceInfo[index].serviceName}",
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.poppins(
                                        color: AppColor.DARK_ACCENT,
                                        fontWeight: FontWeight.w500,
                                        fontSize: defaultSize * 1.5),
                                  ),
                                  Spacer(),
                                  Text(
                                    _userProfileLogin.gender == "M"
                                        ? "₹ ${_getDiscountedPrice(_appointmentResponse.serviceInfo[index].maleRate)}"
                                        : "₹ ${_getDiscountedPrice(_appointmentResponse.serviceInfo[index].femaleRate)}",
                                    style: GoogleFonts.poppins(
                                        color: AppColor.DARK_ACCENT,
                                        fontWeight: FontWeight.w500,
                                        fontSize: defaultSize * 1.5),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: defaultSize * 1.0,
                                    ),
                                    child: Text(
                                        _userProfileLogin.gender == "M"
                                            ? "₹ ${_appointmentResponse.serviceInfo[index].maleRate}"
                                            : "₹ ${_appointmentResponse.serviceInfo[index].femaleRate}",
                                        style: GoogleFonts.poppins(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2.2,
                                            color: AppColor.DARK_ACCENT,
                                            fontWeight: FontWeight.w500,
                                            fontSize: defaultSize * 1.5)),
                                  ),
                                  // Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: defaultSize * 2.0,
                                    ),
                                    child: Text(
                                      _getDiscountPercentage() == 0
                                          ? " "
                                          : "${_getDiscountPercentage()}% Off",
                                      style: GoogleFonts.poppins(
                                          color: AppColor.DARK_ACCENT,
                                          fontWeight: FontWeight.w500,
                                          fontSize: defaultSize * 1.5),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: defaultSize * 3.0,
                          right: defaultSize * 3.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Total",
                              style: GoogleFonts.poppins(
                                  color: AppColor.DARK_ACCENT,
                                  fontWeight: FontWeight.w500,
                                  fontSize: defaultSize * 2.5),
                            ),
                            Spacer(),
                            Text(
                              "₹ ${_appointmentResponse.totalRate}",
                              style: GoogleFonts.poppins(
                                  color: AppColor.DARK_ACCENT,
                                  fontWeight: FontWeight.w500,
                                  fontSize: defaultSize * 2.5),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: defaultSize * 3.0,
                            right: defaultSize * 3.0,
                            bottom: defaultSize * 3.0),
                        child: Row(
                          children: [
                            Text(
                              "Total saved",
                              style: GoogleFonts.poppins(
                                  color: AppColor.DARK_ACCENT,
                                  fontWeight: FontWeight.w500,
                                  fontSize: defaultSize * 1.45),
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: defaultSize * 1.0),
                              child: Text(
                                "₹ ${getSaved().toString()}",
                                style: GoogleFonts.poppins(
                                    color: AppColor.DARK_ACCENT,
                                    fontWeight: FontWeight.w500,
                                    fontSize: defaultSize * 1.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: defaultSize * 3.0,
                    bottom: defaultSize * 3.0,
                    left: defaultSize * 2.0,
                    right: defaultSize * 2.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BottomNavBar()));
                  },
                  child: RoundedButtonDark(
                    buttontext: "DONE",
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
