import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/view/pages/salon_slots_ui.dart';

class SalonServicesUI extends StatefulWidget {
  final int salonId;
  final String salonName;
  final UserProfileLogin userprofile;
  const SalonServicesUI(
      {Key key, this.salonName, this.salonId, this.userprofile})
      : super(key: key);
  @override
  _SalonServicesUIState createState() => _SalonServicesUIState();
}

class _SalonServicesUIState extends State<SalonServicesUI> {
  TabController controller;
  @override
  void initState() {
    super.initState();
    // controller = TabController(length: 2, vsync: this);
    _loadServices();
  }

  SaloonServices _services;
  List<Services> _selectedServiceList = [];
  double defaultOverride;
  String genderFromUserProfile;
  var sum = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadServices();
  // }

  void _loadServices() async {
    final res = await LoadSalons.getService(widget.salonId);
    setState(() {
      _services = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      body: Column(
        children: [
          _services == null ? CircularProgressIndicator() : _getServiceWidget(),
          _selectedServiceList != null && _selectedServiceList.length > 0
              ? Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: defaultSize * 10.0,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(defaultSize * 1.65),
                      child: Container(
                          // width: 50,
                          // height: 50,
                          decoration: BoxDecoration(
                              color: AppColor.PRIMARY_DARK,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultSize * 2.5))),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: defaultSize * 2.5),
                                    child: Text(
                                        '${_selectedServiceList.length} Service Added',
                                        style: GoogleFonts.poppins(
                                            fontSize: defaultSize * 1.80,
                                            color: Colors.white)),
                                  ),
                                  Container(
                                    child: Text("data"),
                                  )
                                  // Container(
                                  //   child: FutureBuilder(
                                  //       future: getSalonServicesGenderRate(),
                                  //       builder: (BuildContext context,
                                  //           AsyncSnapshot snapshot) {
                                  //         if (snapshot.hasData) {
                                  //           if (snapshot.data == "M") {
                                  //             for (int i = 0;
                                  //                 i <
                                  //                     _selectedServiceList
                                  //                         .length;
                                  //                 i++) {
                                  //               _selectedServiceList.length > 0
                                  //                   ? sum +=
                                  //                       _selectedServiceList[i]
                                  //                           .maleRate
                                  //                   : sum -=
                                  //                       _selectedServiceList[i]
                                  //                           .maleRate;
                                  //               return Text("$sum");
                                  //             }
                                  //             return null;
                                  //           } else {
                                  //             return Text("hello");
                                  //           }
                                  //         } else {
                                  //           return Text(" ");
                                  //         }
                                  //       }),
                                  // )
                                ],
                              ),
                              Spacer(),
                              FlatButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                // color: Colors.transparent,
                                onPressed: () async {
                                  final userProfile =
                                      await AppSessionManager.getUserProfile();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SalonSlotsUI(
                                            selectedServiceList:
                                                _selectedServiceList,
                                            salonId: widget.salonId,
                                            salonName: widget.salonName,
                                            userProfile: widget.userprofile,
                                          )));
                                },
                                child: Text(" Book Now",
                                    style: GoogleFonts.poppins(
                                        fontSize: defaultSize * 2.0,
                                        color: AppColor.LOGIN_BACKGROUND)),
                              ),
                            ],
                          )),
                    ),
                  ))
              : Align(
                  alignment: FractionalOffset.bottomCenter, child: Text(" ")),
        ],
      ),
    );
  }

  getSalonServicesGenderRate() async {
    Future<UserProfile> userProfileData = AppSessionManager.getUserProfile();
    await userProfileData.then((value) {
      genderFromUserProfile = value.gender;
    });
    return genderFromUserProfile;
  }

  Widget _imageTitle() => Image(
        image: new AssetImage("assets/images/logo_with_circle.png"),
        height: defaultOverride * 10.0,
        width: double.infinity,
        alignment: FractionalOffset.center,
      );

  Widget _getServiceWidget() => Expanded(
      child: ListView.builder(
          itemCount: _services.services.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: defaultOverride * 11.0,
              margin: EdgeInsets.symmetric(horizontal: defaultOverride * 1.25),
              child: Card(
                elevation: 1.75,
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: defaultOverride * 38.0),
                      child: Container(
                        margin: EdgeInsets.only(left: defaultOverride * 1.5),
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultOverride * 1.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _services.services[index].serviceName,
                              style: GoogleFonts.poppins(
                                  fontSize: defaultOverride * 1.95,
                                  color: AppColor.PRIMARY_MEDIUM,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: defaultOverride * 0.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: defaultOverride * 2.0,
                                  width: defaultOverride * 2.0,
                                  child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {},
                                      child: FaIcon(
                                        FontAwesomeIcons.male,
                                        size: defaultOverride * 1.85,
                                        color: AppColor.PRIMARY_MEDIUM,
                                      )),
                                ),
                                SizedBox(width: defaultOverride * 1.25),
                                Text(
                                  _services.services[index].maleRate.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultOverride * 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.PRIMARY_MEDIUM),
                                ),
                                SizedBox(width: defaultOverride * 1.0),
                                Text(
                                  "|",
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultOverride * 1.5,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.PRIMARY_MEDIUM),
                                ),
                                // SizedBox(width: defaultOverride * 0.5),
                                SizedBox(
                                  height: defaultOverride * 2.0,
                                  width: defaultOverride * 2.0,
                                  child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {},
                                      child: FaIcon(
                                        FontAwesomeIcons.female,
                                        size: defaultOverride * 1.85,
                                        color: AppColor.PRIMARY_MEDIUM,
                                      )),
                                ),
                                SizedBox(width: defaultOverride * 1.25),
                                Text(
                                  _services.services[index].femaleRate
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultOverride * 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.PRIMARY_MEDIUM),
                                ),
                                Spacer(),
                                _selectedServiceList
                                        .contains(_services.services[index])
                                    ? FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            // sa = "BB";
                                            _selectedServiceList.remove(
                                                _services.services[index]);
                                            print(_selectedServiceList.length);
                                          });
                                        },
                                        child: Text(
                                          " - Remove Service",
                                          style: GoogleFonts.poppins(
                                            fontSize: defaultOverride * 1.6265,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.PRIMARY_MEDIUM,
                                          ),
                                        ))
                                    : FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            // sa = "aa";
                                            _selectedServiceList
                                                .add(_services.services[index]);
                                          });
                                        },
                                        child: Text(
                                          " + Add Service",
                                          style: GoogleFonts.poppins(
                                            fontSize: defaultOverride * 1.6265,
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
            );
          }));
}
