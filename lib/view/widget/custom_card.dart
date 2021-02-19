import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SalonCard extends StatefulWidget {
  final String title;
  final dynamic distance;
  final Function customfunction;

  const SalonCard({Key key, this.title, this.distance, this.customfunction})
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
        margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.0),
        child: Card(
          elevation: 5.0,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              sample != null && sample.isNotEmpty
                  ? Container(
                      height: defaultSize * 12,
                      width: defaultSize * 12,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://image.freepik.com/free-vector/monochrome-vintage-barber-shop-elements-concept_1284-39204.jpg"),
                        ),
                      ),
                    )
                  : Container(
                      height: defaultSize * 12,
                      width: defaultSize * 12,
                      color: Colors.blueGrey,
                      child: Icon(
                        Icons.home,
                        size: defaultSize * 3.0,
                        color: Colors.white,
                      ),
                    ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: defaultSize * 21.0),
                child: Container(
                  margin: EdgeInsets.only(left: defaultSize * 1.35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                            fontSize: defaultSize * 2.0,
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
                            size: defaultSize * 2.2,
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.distance,
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.5,
                                fontWeight: FontWeight.w400,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          SizedBox(width: defaultSize * 1.0),
                          Text(
                            "|",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 2.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.PRIMARY_MEDIUM),
                          ),
                          SizedBox(width: defaultSize * 1.0),
                          Icon(
                            Icons.star,
                            color: Color.fromRGBO(96, 127, 99, 1.0),
                            size: defaultSize * 2.2,
                          ),
                          SizedBox(width: defaultSize * 1.0),
                          Text(
                            "4.0 / 5",
                            style: GoogleFonts.poppins(
                                fontSize: defaultSize * 1.5,
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
                margin: EdgeInsets.only(right: defaultSize * 2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        print("Heart Clciked");
                      },
                      child: Container(
                        height: defaultSize * 3.5,
                        width: defaultSize * 3.5,
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
                          size: defaultSize * 2.6,
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
