import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class SalonCard extends StatefulWidget {
  final String title;
  final dynamic distance;
  final Function customfunction, customFunctionLike, customFnc;
  final Color color;
  final String thumb;
  final bool liked;

  const SalonCard({
    Key key,
    this.title,
    this.distance,
    this.customfunction,
    this.customFunctionLike,
    this.customFnc,
    this.color,
    this.thumb,
    this.liked,
  }) : super(key: key);

  @override
  _SalonCardState createState() => _SalonCardState();
}

class _SalonCardState extends State<SalonCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    String sample = "AA";
    return GestureDetector(
      onTap: () {
        widget.customfunction();
      },
      child: Container(
        margin: EdgeInsets.only(
            left: defaultSize * 1.0,
            right: defaultSize * 1.0,
            top: defaultSize * 0.5,
            bottom: defaultSize * 1.2),
        child: Card(
          elevation: 1.85,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              widget.thumb != null && widget.thumb.isNotEmpty
                  ? Container(
                      height: defaultSize * 10.5,
                      width: defaultSize * 15,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.thumb),
                        ),
                      ),
                    )
                  : Container(
                      height: defaultSize * 10.5,
                      width: defaultSize * 15,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg"),
                        ),
                      ),
                    ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: defaultSize * 17.0),
                child: Container(
                  margin: EdgeInsets.only(left: defaultSize * 1.35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                            fontSize: defaultSize * 1.70,
                            color: AppColor.PRIMARY_MEDIUM,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: defaultSize * 1.0,
                      ),
                      Text(widget.distance,
                          style: GoogleFonts.poppins(
                              fontSize: defaultSize * 1.25,
                              fontWeight: FontWeight.w400,
                              color: AppColor.PRIMARY_MEDIUM)),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.location_on,
                      //       color: Color.fromRGBO(96, 127, 99, 1.0),
                      //       size: defaultSize * 1.5,
                      //     ),
                      //     SizedBox(width: defaultSize * 0.5),
                      //     Text(
                      //       widget.distance,
                      //       style: GoogleFonts.poppins(
                      //           fontSize: defaultSize * 1.25,
                      //           fontWeight: FontWeight.w400,
                      //           color: AppColor.PRIMARY_MEDIUM),
                      //     ),
                      // SizedBox(width: defaultSize * 0.5),
                      // Text(
                      //   "|",
                      //   style: GoogleFonts.poppins(
                      //       fontSize: defaultSize * 1.5,
                      //       fontWeight: FontWeight.w500,
                      //       color: AppColor.PRIMARY_MEDIUM),
                      // ),
                      // SizedBox(width: defaultSize * 0.5),
                      // Icon(
                      //   Icons.star,
                      //   color: Color.fromRGBO(96, 127, 99, 1.0),
                      //   size: defaultSize * 1.5,
                      // ),
                      // SizedBox(width: defaultSize * 0.5),
                      // Text(
                      //   "4.0 / 5",
                      //   style: GoogleFonts.poppins(
                      //       fontSize: defaultSize * 1.25,
                      //       fontWeight: FontWeight.w400,
                      //       color: AppColor.PRIMARY_MEDIUM),
                      // ),
                    ],
                  ),
                  // ],
                ),
              ),
              // ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  right: defaultSize * 2.5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: defaultSize * 3.0,
                      width: defaultSize * 3.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: defaultSize * 0.30),
                        child: LikeButton(
                          isLiked: widget.liked,
                          onTap: (bool isLiked) async {
                            if (isLiked) {
                              widget.customFunctionLike();
                            } else {
                              widget.customFnc();
                            }
                            return !isLiked;
                          },
                          size: defaultSize * 1.82,
                          circleColor: CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Color(0xff33b5e5),
                            dotSecondaryColor: Color(0xff0099cc),
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color:
                                  isLiked ? Colors.red[800] : Colors.grey[400],
                              size: defaultSize * 1.82,
                            );
                          },
                        ),
                      ),
                    ),
                    // InkWell(
                    //   splashColor: Colors.transparent,
                    //   highlightColor: Colors.transparent,
                    //   onTap: () {
                    //     widget.customFunctionLike();
                    //   },
                    //   child: Container(
                    //     height: defaultSize * 2.8,
                    //     width: defaultSize * 2.8,
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       color: Colors.white,
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.5),
                    //           spreadRadius: 1,
                    //           blurRadius: 3,
                    //           offset:
                    //               Offset(0, 0), // changes position of shadow
                    //         ),
                    //       ],
                    //     ),
                    //     child: Icon(
                    //       Icons.favorite,
                    //       size: defaultSize * 1.85,
                    //       color: widget.color,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteSalonCard extends StatefulWidget {
  final String title;
  final dynamic distance;
  final Function customfunction, redirect;
  final String thumb;

  const FavoriteSalonCard(
      {Key key,
      this.title,
      this.distance,
      this.customfunction,
      this.redirect,
      this.thumb})
      : super(key: key);
  @override
  _FavoriteSalonCardState createState() => _FavoriteSalonCardState();
}

class _FavoriteSalonCardState extends State<FavoriteSalonCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    String sample = "AA";
    return GestureDetector(
      onTap: () {
        widget.redirect();
      },
      child: Container(
        margin: EdgeInsets.only(
            left: defaultSize * 1.0,
            right: defaultSize * 1.0,
            top: defaultSize * 0.5,
            bottom: defaultSize * 1.2),
        child: Card(
          elevation: 1.85,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              widget.thumb != null && widget.thumb.isNotEmpty
                  ? Container(
                      height: defaultSize * 12.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.thumb),
                        ),
                      ),
                    )
                  : Container(
                      height: defaultSize * 12.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg"),
                        ),
                      ),
                    ),
              SizedBox(
                height: defaultSize * 1.25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      left: defaultSize * 1.25,
                    ),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                          fontSize: defaultSize * 1.75,
                          color: AppColor.PRIMARY_MEDIUM,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: defaultSize * 0.5,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: defaultSize * 1.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: AppColor.PRIMARY_MEDIUM,
                      size: defaultSize * 2.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.distance,
                        maxLines: 8,
                        // overflow: TextOverflow.ellipsis,
                        // textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontSize: defaultSize * 1.75,
                          color: AppColor.PRIMARY_MEDIUM,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                height: defaultSize * 2.5,
                margin: EdgeInsets.only(
                  bottom: defaultSize * 1.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.customfunction();
                  },
                  child: Text(
                    "Remove from favorites",
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 1.5,
                      color: AppColor.PRIMARY_DARK,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchSalonCard extends StatefulWidget {
  final String title;
  final dynamic distance;
  final Function customfunction, customFunctionLike, customFnc;
  final Color color;
  final String thumb;
  final bool liked;

  const SearchSalonCard({
    Key key,
    this.title,
    this.distance,
    this.customfunction,
    this.customFunctionLike,
    this.customFnc,
    this.color,
    this.thumb,
    this.liked,
  }) : super(key: key);

  @override
  _SearchSalonCardState createState() => _SearchSalonCardState();
}

class _SearchSalonCardState extends State<SearchSalonCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    String sample = "AA";
    return GestureDetector(
      onTap: () {
        widget.customfunction();
      },
      child: Container(
        margin: EdgeInsets.only(
            left: defaultSize * 1.0,
            right: defaultSize * 1.0,
            top: defaultSize * 0.5,
            bottom: defaultSize * 1.2),
        child: Card(
          elevation: 1.85,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              widget.thumb != null && widget.thumb.isNotEmpty
                  ? Container(
                      height: defaultSize * 10.5,
                      width: defaultSize * 15,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(widget.thumb),
                        ),
                      ),
                    )
                  : Container(
                      height: defaultSize * 10.5,
                      width: defaultSize * 15,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg"),
                        ),
                      ),
                    ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: defaultSize * 17.0),
                child: Container(
                  margin: EdgeInsets.only(left: defaultSize * 1.35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                            fontSize: defaultSize * 1.70,
                            color: AppColor.PRIMARY_MEDIUM,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: defaultSize * 1.0,
                      ),
                      Text(widget.distance,
                          style: GoogleFonts.poppins(
                              fontSize: defaultSize * 1.25,
                              fontWeight: FontWeight.w400,
                              color: AppColor.PRIMARY_MEDIUM)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatefulWidget {
  final String salonTitle, date, time;
  final Function viewDetails, cancel;

  const AppointmentCard(
      {Key key,
      this.salonTitle,
      this.date,
      this.time,
      this.viewDetails,
      this.cancel})
      : super(key: key);
  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      // height: defaultSize * 20,
      // width: double.infinity,
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
                widget.salonTitle,
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
                widget.date,
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
                widget.time,
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
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                  onPressed: () async {
                    widget.viewDetails();
                  },
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
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                  onPressed: () async {
                    widget.cancel();
                  },
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
    );
  }
}

class PastAppointmentCard extends StatefulWidget {
  final String salonTitle, date, time;
  final Function viewDetails, review;

  const PastAppointmentCard({
    Key key,
    this.salonTitle,
    this.date,
    this.time,
    this.viewDetails,
    this.review,
  }) : super(key: key);
  @override
  _PastAppointmentCardState createState() => _PastAppointmentCardState();
}

class _PastAppointmentCardState extends State<PastAppointmentCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      // height: defaultSize * 20,
      // width: double.infinity,
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
                widget.salonTitle,
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
                widget.date,
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
                widget.time,
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
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                  onPressed: () async {
                    widget.review();
                  },
                  child: Text(
                    'Write a review',
                    style: GoogleFonts.poppins(
                        color: AppColor.PRIMARY_DARK,
                        fontSize: defaultSize * 1.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0),
                  ),
                ),
                Spacer(),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                  onPressed: () async {
                    widget.viewDetails();
                  },
                  child: Text(
                    'View Details',
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
    );
  }
}

class CancelledAppointmentCard extends StatefulWidget {
  final String salonTitle, date, time;
  final Function viewDetails;

  const CancelledAppointmentCard({
    Key key,
    this.salonTitle,
    this.date,
    this.time,
    this.viewDetails,
  }) : super(key: key);
  @override
  _CancelledAppointmentCardState createState() =>
      _CancelledAppointmentCardState();
}

class _CancelledAppointmentCardState extends State<CancelledAppointmentCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Container(
      // height: defaultSize * 20,
      // width: double.infinity,
      margin: EdgeInsets.only(
          left: defaultSize * 1.0,
          right: defaultSize * 1.0,
          top: defaultSize * 0.5,
          bottom: defaultSize * 1.2),
      child: Card(
        elevation: 2.0,
        color: Colors.grey[200],
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
                widget.salonTitle,
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
                widget.date,
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
                widget.time,
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
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                  onPressed: () async {
                    widget.viewDetails();
                  },
                  child: Text(
                    'View Details',
                    style: GoogleFonts.poppins(
                        color: AppColor.PRIMARY_DARK,
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
    );
  }
}
