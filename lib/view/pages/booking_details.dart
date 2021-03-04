import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class BookingDetails extends StatefulWidget {
  final List<Services> selectedServiceList;
  final int salonId;
  final String salonName, employeeName, dateString, dayMonth;
  final UserProfileLogin userProfile;

  const BookingDetails(
      {Key key,
      this.selectedServiceList,
      this.salonId,
      this.salonName,
      this.employeeName,
      this.dateString,
      this.dayMonth,
      this.userProfile})
      : super(key: key);
  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  double defaultSize;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSizeOver = SizeConfig.defaultSize;
    defaultSize = defaultSizeOver;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _getBookingDetails(),
      ),
    );
  }

  int getTotal() {
    int sum = 0;
    int saved = 0;
    for (int i = 0; i < widget.selectedServiceList.length; i++) {
      int _getDiscountPercentage() {
        if (widget.selectedServiceList[i].globalDiscount != null &&
            widget.selectedServiceList[i].globalDiscount > 0)
          return widget.selectedServiceList[i].globalDiscount;
        else
          return widget.selectedServiceList[i].serviceDiscount ?? 0;
      }

      int _getDiscountedPrice(int amount) {
        int percentageDiscount = _getDiscountPercentage();
        double discount = amount * percentageDiscount / 100;
        return (amount - discount).toInt();
      }

      sum += widget.userProfile.gender == "M"
          ? _getDiscountedPrice(widget.selectedServiceList[i].maleRate)
          : _getDiscountedPrice(widget.selectedServiceList[i].femaleRate);
      // sum += widget.userProfile.gender == "M"
      //     ? widget.selectedServiceList[i].maleRate
      //     : widget.selectedServiceList[i].femaleRate;

    }
    print(sum.toString());
    return sum;
  }

  int getSaved() {
    int saved = 0;
    for (int i = 0; i < widget.selectedServiceList.length; i++) {
      int _getDiscountPercentage() {
        if (widget.selectedServiceList[i].globalDiscount != null &&
            widget.selectedServiceList[i].globalDiscount > 0)
          return widget.selectedServiceList[i].globalDiscount;
        else
          return widget.selectedServiceList[i].serviceDiscount ?? 0;
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
          widget.userProfile.gender == "M"
              ? _getDiscountedPrice(widget.selectedServiceList[i].maleRate)
              : _getDiscountedPrice(widget.selectedServiceList[i].femaleRate),
          widget.userProfile.gender == "M"
              ? widget.selectedServiceList[i].maleRate
              : widget.selectedServiceList[i].femaleRate);
    }
    return saved;
  }

  Widget _getBookingDetails() => SingleChildScrollView(
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
                        "Awaiting Confirmation",
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
                  color: Colors.white,
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
                          "${widget.salonName.toUpperCase()} APPOINTMENT",
                          style: GoogleFonts.poppins(
                              color: AppColor.DARK_ACCENT,
                              fontWeight: FontWeight.w600,
                              fontSize: defaultSize * 2.0),
                        ),
                      ),
                      Text(
                        "${widget.dayMonth}",
                        style: GoogleFonts.poppins(
                            color: AppColor.DARK_ACCENT,
                            fontWeight: FontWeight.w500,
                            fontSize: defaultSize * 1.5),
                      ),
                      Text(
                        "TIME: ${widget.dateString}",
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
                          "${widget.employeeName}",
                          style: GoogleFonts.poppins(
                              color: AppColor.DARK_ACCENT,
                              fontWeight: FontWeight.w500,
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
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     left: defaultSize * 3.0,
                      //     right: defaultSize * 3.0,
                      //     bottom: 0.0,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         "Service Name",
                      //         style: GoogleFonts.poppins(
                      //             color: AppColor.DARK_ACCENT,
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: defaultSize * 1.5),
                      //       ),
                      //       Spacer(),
                      //       Text(
                      //         "Amount",
                      //         style: GoogleFonts.poppins(
                      //             color: AppColor.DARK_ACCENT,
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: defaultSize * 1.5),
                      //       ),
                      //       // Spacer(),
                      //       Padding(
                      //         padding: EdgeInsets.only(
                      //           left: defaultSize * 2.0,
                      //         ),
                      //         child: Text(
                      //           "Discount",
                      //           style: GoogleFonts.poppins(
                      //               color: AppColor.DARK_ACCENT,
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: defaultSize * 1.5),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            left: defaultSize * 3.0,
                            right: defaultSize * 3.0,
                            bottom: defaultSize * 2.0),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.selectedServiceList.length,
                            itemBuilder: (BuildContext context, int index) {
                              int _getDiscountPercentage() {
                                if (widget.selectedServiceList[index]
                                            .globalDiscount !=
                                        null &&
                                    widget.selectedServiceList[index]
                                            .globalDiscount >
                                        0)
                                  return widget.selectedServiceList[index]
                                      .globalDiscount;
                                else
                                  return widget.selectedServiceList[index]
                                          .serviceDiscount ??
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
                                    "${widget.selectedServiceList[index].serviceName}",
                                    style: GoogleFonts.poppins(
                                        color: AppColor.DARK_ACCENT,
                                        fontWeight: FontWeight.w500,
                                        fontSize: defaultSize * 1.5),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.userProfile.gender == "M"
                                        ? "₹ ${_getDiscountedPrice(widget.selectedServiceList[index].maleRate)}"
                                        : "₹ ${_getDiscountedPrice(widget.selectedServiceList[index].femaleRate)}",
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
                                        widget.userProfile.gender == "M"
                                            ? "₹ ${widget.selectedServiceList[index].maleRate}"
                                            : "₹ ${widget.selectedServiceList[index].femaleRate}",
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
                                      // "${_getDiscountPercentage()}% Off",
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
                              "₹ ${getTotal().toString()}",
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
