import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class SalonCard extends StatefulWidget {
  final String title;
  final dynamic distance;
  final Function customfunction, customFunctionLike;

  const SalonCard(
      {Key key,
      this.title,
      this.distance,
      this.customfunction,
      this.customFunctionLike})
      : super(key: key);

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
              sample != null && sample.isNotEmpty
                  ? Container(
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
                    )
                  : Container(
                      height: defaultSize * 10,
                      width: defaultSize * 15,
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.home,
                        size: defaultSize * 3.0,
                        color: Colors.white,
                      ),
                    ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: defaultSize * 15.0),
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
                        height: defaultSize * 1.5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color.fromRGBO(96, 127, 99, 1.0),
                            size: defaultSize * 1.5,
                          ),
                          SizedBox(width: defaultSize * 0.5),
                          Text(
                            widget.distance,
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.25,
                                fontWeight: FontWeight.w400,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          SizedBox(width: defaultSize * 0.5),
                          Text(
                            "|",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          SizedBox(width: defaultSize * 0.5),
                          Icon(
                            Icons.star,
                            color: Color.fromRGBO(96, 127, 99, 1.0),
                            size: defaultSize * 1.5,
                          ),
                          SizedBox(width: defaultSize * 0.5),
                          Text(
                            "4.0 / 5",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.25,
                                fontWeight: FontWeight.w400,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: defaultSize * 2.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        widget.customFunctionLike();
                      },
                      child: Container(
                        height: defaultSize * 2.8,
                        width: defaultSize * 2.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: defaultSize * 1.85,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
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

class ServiceCard extends StatefulWidget {
  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String sa = "aa";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: Container(
        height: defaultSize * 16.0,
        margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.25),
        child: Card(
          elevation: 5.0,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: defaultSize * 38.0),
                child: Container(
                  margin: EdgeInsets.only(left: defaultSize * 1.5),
                  padding: EdgeInsets.all(defaultSize * 1.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hair cut",
                        style: GoogleFonts.poppins(
                            fontSize: defaultSize * 2.354,
                            color: AppColor.PRIMARY_MEDIUM,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: defaultSize * 1.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: defaultSize * 2.5,
                            width: defaultSize * 2.5,
                            child: FlatButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {},
                                child: FaIcon(
                                  FontAwesomeIcons.male,
                                  size: defaultSize * 2.0,
                                  color: AppColor.PRIMARY_MEDIUM,
                                )),
                          ),
                          SizedBox(width: defaultSize * 1.25),
                          Text(
                            "100",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.5,
                                fontWeight: FontWeight.w400,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          SizedBox(width: defaultSize * 1.5),
                          Text(
                            "|",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 2.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          // SizedBox(width: defaultSize * 0.5),
                          SizedBox(
                            height: defaultSize * 2.5,
                            width: defaultSize * 2.5,
                            child: FlatButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () {},
                                child: FaIcon(
                                  FontAwesomeIcons.female,
                                  size: defaultSize * 2.0,
                                  color: AppColor.PRIMARY_MEDIUM,
                                )),
                          ),
                          SizedBox(width: defaultSize * 1.25),
                          Text(
                            "1000",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.5,
                                fontWeight: FontWeight.w400,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          Spacer(),
                          sa == "aa"
                              ? FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      sa = "BB";
                                    });
                                  },
                                  child: Text(
                                    " - Remove Service",
                                    style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 1.6265,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.PRIMARY_MEDIUM,
                                    ),
                                  ))
                              : FlatButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      sa = "aa";
                                    });
                                  },
                                  child: Text(
                                    " + Add Service",
                                    style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 1.6265,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.PRIMARY_MEDIUM,
                                    ),
                                  ))
                        ],
                      ),
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

class BookingDetailsCard extends StatefulWidget {
  @override
  _BookingDetailsCardState createState() => _BookingDetailsCardState();
}

class _BookingDetailsCardState extends State<BookingDetailsCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: SingleChildScrollView(
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
                          "APPOINTMENT",
                          style: GoogleFonts.poppins(
                              color: AppColor.DARK_ACCENT,
                              fontWeight: FontWeight.w600,
                              fontSize: defaultSize * 2.0),
                        ),
                      ),
                      Text(
                        "Date 11 JULY,2021 | MONDAY",
                        style: GoogleFonts.poppins(
                            color: AppColor.DARK_ACCENT,
                            fontWeight: FontWeight.w500,
                            fontSize: defaultSize * 1.5),
                      ),
                      Text(
                        "TIME: 10AM",
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
                          "Susmita",
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
                      Padding(
                        padding: EdgeInsets.only(
                            left: defaultSize * 3.0,
                            right: defaultSize * 3.0,
                            bottom: defaultSize * 2.0),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Text(
                                    "The Work",
                                    style: GoogleFonts.poppins(
                                        color: AppColor.DARK_ACCENT,
                                        fontWeight: FontWeight.w500,
                                        fontSize: defaultSize * 1.5),
                                  ),
                                  Spacer(),
                                  Text(
                                    " 200",
                                    style: GoogleFonts.poppins(
                                        color: AppColor.DARK_ACCENT,
                                        fontWeight: FontWeight.w500,
                                        fontSize: defaultSize * 1.5),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: defaultSize * 3.0,
                            right: defaultSize * 3.0,
                            bottom: defaultSize * 3.0),
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
                              " 200",
                              style: GoogleFonts.poppins(
                                  color: AppColor.DARK_ACCENT,
                                  fontWeight: FontWeight.w500,
                                  fontSize: defaultSize * 2.5),
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
                child: RoundedButtonDark(
                  buttontext: "DONE",
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
  final Function customfunction;

  const FavoriteSalonCard(
      {Key key, this.title, this.distance, this.customfunction})
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
          child: Column(
            children: [
              sample != null && sample.isNotEmpty
                  ? Container(
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
                    )
                  : Container(
                      height: defaultSize * 1,
                      width: defaultSize * 15,
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.home,
                        size: defaultSize * 3.0,
                        color: Colors.white,
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
                  Container(
                    margin: EdgeInsets.only(
                      right: defaultSize * 2.0,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColor.PRIMARY_DARK,
                          size: defaultSize * 1.75,
                        ),
                        SizedBox(width: defaultSize * 0.5),
                        Text(
                          "4.0",
                          style: GoogleFonts.poppins(
                              fontSize: defaultSize * 1.75,
                              color: AppColor.PRIMARY_MEDIUM,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  left: defaultSize * 1.25,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColor.PRIMARY_DARK,
                      size: defaultSize * 1.5,
                    ),
                    SizedBox(width: defaultSize * 0.5),
                    Text(
                      widget.distance,
                      style: GoogleFonts.poppins(
                          fontSize: defaultSize * 1.5,
                          color: AppColor.PRIMARY_MEDIUM,
                          fontWeight: FontWeight.w400),
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
  final Function customfunction, customFunctionLike;

  const SearchSalonCard(
      {Key key,
      this.title,
      this.distance,
      this.customfunction,
      this.customFunctionLike})
      : super(key: key);
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
          elevation: 1,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              sample != null && sample.isNotEmpty
                  ? Container(
                      height: defaultSize * 8.5,
                      width: defaultSize * 15,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg"),
                        ),
                      ),
                    )
                  : Container(
                      height: defaultSize * 10,
                      width: defaultSize * 15,
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.home,
                        size: defaultSize * 3.0,
                        color: Colors.white,
                      ),
                    ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: defaultSize * 20.0),
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
