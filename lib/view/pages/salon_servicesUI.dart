import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/view/pages/salon_slots_ui.dart';

class SalonServicesUI extends StatefulWidget {
  final int salonId;
  final SalonData salonInfo;
  final String salonName;
  final UserProfileLogin userprofile;

  const SalonServicesUI({
    Key key,
    this.salonName,
    this.salonId,
    this.userprofile,
    this.salonInfo,
  }) : super(key: key);
  @override
  _SalonServicesUIState createState() => _SalonServicesUIState();
}

class _SalonServicesUIState extends State<SalonServicesUI> {
  int index;
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
          _services == null
              ? Center(child: CircularProgressIndicator())
              : _getServiceWidget(),
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
                                  // Container(
                                  //     child: Text(_selectedServiceList[index]
                                  //         .maleRate
                                  //         .toString())),
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
            index = index;
            int _getDiscountPercentage() {
              if (_services.services[index].serviceDiscount != null &&
                  _services.services[index].serviceDiscount > 0)
                return _services.services[index].serviceDiscount;
              else
                return _services.services[index].globalDiscount ?? 0;
            }

            int _getDiscountedPrice(int amount) {
              int percentageDiscount = _getDiscountPercentage();
              double discount = amount * percentageDiscount / 100;
              return (amount - discount).toInt();
            }

            Widget _getTitleBar() => Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppColor.PRIMARY_DARK,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Text(
                      "${_services.services[index].id}. ${_services.services[index].serviceName}",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                );
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColor.VERY_LIGHT_GREEN),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getTitleBar(),
                  if (_services.services[index].maleRate != null &&
                      _services.services[index].maleRate > 0)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 12, top: 16, right: 12),
                      child: Row(
                        children: [
                          Text(
                              "Male Rate: ₹${_getDiscountedPrice(_services.services[index].maleRate)}",
                              style: GoogleFonts.poppins(
                                  color: AppColor.PRIMARY_DARK,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                          SizedBox(width: 8),
                          if (_getDiscountedPrice(
                                  _services.services[index].maleRate) !=
                              _services.services[index].maleRate)
                            Text("₹${_services.services[index].maleRate}",
                                style: GoogleFonts.poppins(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColor.PRIMARY_DARK,
                                    fontSize: 15)),
                          SizedBox(width: 24),
                          if (_getDiscountedPrice(
                                  _services.services[index].maleRate) !=
                              _services.services[index].maleRate)
                            Text("${_getDiscountPercentage()}% Off",
                                style: GoogleFonts.poppins(
                                    color: AppColor.PRIMARY_DARK,
                                    fontSize: 15)),
                        ],
                      ),
                    ),
                  if (_services.services[index].femaleRate != null &&
                      _services.services[index].femaleRate > 0)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, top: 2, right: 12, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                              "Female Rate: ₹${_getDiscountedPrice(_services.services[index].femaleRate)}",
                              style: GoogleFonts.poppins(
                                  color: AppColor.PRIMARY_DARK,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                          SizedBox(width: 8),
                          if (_getDiscountedPrice(
                                  _services.services[index].femaleRate) !=
                              _services.services[index].femaleRate)
                            Text("₹${_services.services[index].femaleRate}",
                                style: GoogleFonts.poppins(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColor.PRIMARY_DARK,
                                    fontSize: 15)),
                          SizedBox(width: 24),
                          if (_getDiscountedPrice(
                                  _services.services[index].femaleRate) !=
                              _services.services[index].femaleRate)
                            Text("${_getDiscountPercentage()}% Off",
                                style: GoogleFonts.poppins(
                                    color: AppColor.PRIMARY_DARK,
                                    fontSize: 15)),
                        ],
                      ),
                    ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(),
                      Spacer(),
                      _selectedServiceList.contains(_services.services[index])
                          ? Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // sa = "BB";
                                    _selectedServiceList
                                        .remove(_services.services[index]);
                                    print(_selectedServiceList.length);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 14),
                                  decoration: BoxDecoration(
                                      color: AppColor.DARK_ACCENT,
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: Text(
                                    '- Remove Service',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // sa = "aa";
                                    _selectedServiceList
                                        .add(_services.services[index]);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 14),
                                  decoration: BoxDecoration(
                                      color: AppColor.DARK_ACCENT,
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: Text(
                                    '+ Add Service',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      );
}
