import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/view/pages/random_tests.dart';
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

  UserProfileLogin _userProfileLogin;

  @override
  void initState() {
    super.initState();
    // controller = TabController(length: 2, vsync: this);
    _loadServices();
    searchController.addListener(() {
      filterList();
    });
  }

  SaloonServices _services;
  List<Services> _selectedServiceList = [];
  List<Services> filteredSearch = [];
  double defaultOverride;
  bool isSearchingOver;
  TextEditingController searchController = new TextEditingController();
  String genderFromUserProfile;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int sum = 0;
  filterList() {
    List<Services> _searchList = [];
    _searchList.addAll(_services.services);
    if (searchController.text.isNotEmpty) {
      _searchList.retainWhere((service) {
        String searchTerm = searchController.text.toLowerCase();
        String salonName = service.serviceName.toLowerCase();
        // widget.hide();
        return salonName.contains(searchTerm);
      });
      setState(() {
        filteredSearch = _searchList;
      });
    }
  }

  void _loadServices() async {
    final res = await LoadSalons.getService(widget.salonId);
    final userProfile = await AppSessionManager.getUserProfileAfterLogin();
    setState(() {
      _services = res.data;
      _userProfileLogin = userProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    bool isSearching = searchController.text.isNotEmpty;
    isSearchingOver = isSearching;
    return Stack(children: [
      Column(
        children: [
          Container(
            height: defaultSize * 5,
            // width: defaultSize * 35.0,
            margin: EdgeInsets.only(
              left: defaultSize * 2.0,
              right: defaultSize * 2.0,
              top: defaultSize * 2.0,
              bottom: defaultSize * 1.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultSize * 3.2),
              color: Colors.white,
              boxShadow: kElevationToShadow[2],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search services',
                hintStyle: GoogleFonts.poppins(color: AppColor.PRIMARY_MEDIUM),
                border: InputBorder.none,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColor.PRIMARY_MEDIUM,
                    ),
                  ],
                ),
              ),
            ),
          ),
          _services == null
              ? Center(child: CircularProgressIndicator())
              : _getServiceWidget(),
        ],
      ),
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
                            margin:
                            EdgeInsets.only(left: defaultSize * 2.5),
                            child: Text(
                                '${_selectedServiceList.length} Service Added',
                                style: GoogleFonts.poppins(
                                    fontSize: defaultSize * 1.6,
                                    color: Colors.white)),
                          ),
                          SizedBox(
                            width: defaultSize * 1,
                          ),
                          SizedBox(
                            width: defaultSize * 1.25,
                            child: Text('|',
                                style: GoogleFonts.poppins(
                                    fontSize: defaultSize * 1.6,
                                    color: Colors.white)),
                          ),
                          Container(
                              child: Text(sum.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 1.6,
                                      color: Colors.white))),
                        ],
                      ),
                      Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.transparent),
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
          : Align(alignment: FractionalOffset.bottomCenter, child: Text(" ")),
    ]);
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
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: defaultOverride * 11.0),
      physics: BouncingScrollPhysics(),
      // dragStartBehavior: DragStartBehavior.down,
      itemCount: isSearchingOver == true
          ? filteredSearch.length
          : _services.services.length,
      itemBuilder: (BuildContext context, int index) {
        Services services = isSearchingOver == true
            ? filteredSearch[index]
            : _services.services[index];
        int _getDiscountPercentage() {
          if (services.globalDiscount != null &&
              services.globalDiscount > 0)
            return services.globalDiscount;
          else
            return services.serviceDiscount ?? 0;
        }

        int _getDiscountedPrice(int amount) {
          int percentageDiscount = _getDiscountPercentage();
          double discount = amount * percentageDiscount / 100;
          return (amount - discount).toInt();
        }

        Widget _getTitleBar() => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: defaultOverride * 1.25,
              vertical: defaultOverride * 1.0),
          decoration: BoxDecoration(
              color: AppColor.PRIMARY_DARK,
              borderRadius:
              BorderRadius.circular(defaultOverride * 1.65)),
          child: Text("${services.id}. ${services.serviceName}",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: defaultOverride * 1.65)),
        );
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: defaultOverride * 1.25,
              vertical: defaultOverride * 0.8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultOverride * 1.65),
              color: AppColor.VERY_LIGHT_GREEN),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getTitleBar(),
              if (services.maleRate != null && services.maleRate > 0)
                Padding(
                  padding: EdgeInsets.only(
                      left: defaultOverride * 1.25,
                      top: defaultOverride * 1.65,
                      right: defaultOverride * 1.25),
                  child: Row(
                    children: [
                      Text(
                          "Male Rate: ₹${_getDiscountedPrice(services.maleRate)}",
                          style: GoogleFonts.poppins(
                              color: AppColor.PRIMARY_DARK,
                              fontWeight: FontWeight.w600,
                              fontSize: defaultOverride * 1.55)),
                      SizedBox(width: defaultOverride * 0.9),
                      if (_getDiscountedPrice(services.maleRate) !=
                          services.maleRate)
                        Text("₹${services.maleRate}",
                            style: GoogleFonts.poppins(
                                decoration: TextDecoration.lineThrough,
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultOverride * 1.55)),
                      SizedBox(width: defaultOverride * 2.4),
                      if (_getDiscountedPrice(services.maleRate) !=
                          services.maleRate)
                        Text("${_getDiscountPercentage()}% Off",
                            style: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultOverride * 1.5)),
                    ],
                  ),
                ),
              if (services.femaleRate != null && services.femaleRate > 0)
                Padding(
                  padding: EdgeInsets.only(
                      left: defaultOverride * 1.25,
                      top: defaultOverride * 0.25,
                      right: defaultOverride * 1.25,
                      bottom: defaultOverride * 0.85),
                  child: Row(
                    children: [
                      Text(
                          "Female Rate: ₹${_getDiscountedPrice(services.femaleRate)}",
                          style: GoogleFonts.poppins(
                              color: AppColor.PRIMARY_DARK,
                              fontWeight: FontWeight.w600,
                              fontSize: defaultOverride * 1.5)),
                      SizedBox(width: defaultOverride * 0.85),
                      if (_getDiscountedPrice(services.femaleRate) !=
                          services.femaleRate)
                        Text("₹${services.femaleRate}",
                            style: GoogleFonts.poppins(
                                decoration: TextDecoration.lineThrough,
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultOverride * 1.5)),
                      SizedBox(width: 24),
                      if (_getDiscountedPrice(services.femaleRate) !=
                          services.femaleRate)
                        Text("${_getDiscountPercentage()}% Off",
                            style: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK,
                                fontSize: defaultOverride * 1.5)),
                    ],
                  ),
                ),
              (services.description == null || services.description == "") ? Text(" ") :
              Padding(
                padding: EdgeInsets.only(
                    left: defaultOverride * 1.25,
                    top: defaultOverride * 0.25,
                    right: defaultOverride * 1.25,
                    bottom: defaultOverride * 0.85),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Description : ',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: AppColor.PRIMARY_MEDIUM,
                              fontSize: defaultOverride * 1.5)),
                      TextSpan(
                          text: services.description,
                          style: GoogleFonts.poppins(
                              color: AppColor.PRIMARY_MEDIUM,
                              fontSize: defaultOverride * 1.35,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: defaultOverride * 0.85),
              Row(
                children: [
                  Container(),
                  Spacer(),
                  _selectedServiceList.contains(services)
                      ? Container(
                    margin: EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // sa = "BB";

                          _selectedServiceList.remove(services);
                          sum -= _userProfileLogin.gender == "M"
                              ? _getDiscountedPrice(services.maleRate)
                              : _getDiscountedPrice(_services
                              .services[index].femaleRate);

                          print(_selectedServiceList.length);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: defaultOverride * 1.25),
                        padding: EdgeInsets.symmetric(
                            vertical: defaultOverride * 0.75,
                            horizontal: defaultOverride * 1.5),
                        decoration: BoxDecoration(
                            color: AppColor.DARK_ACCENT,
                            borderRadius:
                            BorderRadius.circular(50.0)),
                        child: Text(
                          '- Remove Service',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: defaultOverride * 1.35),
                        ),
                      ),
                    ),
                  )
                      : Container(
                    margin:
                    EdgeInsets.only(right: defaultOverride * 2.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          // sa = "aa";
                          if (_userProfileLogin.gender == "M" &&
                              services.maleRate != null &&
                              services.maleRate != 0) {
                            _selectedServiceList.add(services);
                            sum += _getDiscountedPrice(
                                services.maleRate);
                            print(
                                _selectedServiceList.first.maleRate);
                          } else if (_userProfileLogin.gender ==
                              "F" &&
                              services.femaleRate != null &&
                              services.femaleRate != 0) {
                            _selectedServiceList.add(services);
                            sum += _getDiscountedPrice(
                                services.femaleRate);
                            print(_selectedServiceList
                                .first.femaleRate);
                          } else {
                            Fluttertoast.showToast(
                              msg:
                              "Service not available for ${_userProfileLogin.gender == "M" ? "Males" : "Females"}",
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 2,
                            );
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: defaultOverride * 1.25),
                        padding: EdgeInsets.symmetric(
                            vertical: defaultOverride * 0.75,
                            horizontal: defaultOverride * 1.5),
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
              SizedBox(height: defaultOverride * 2.25),
            ],
          ),
        );
      },
    ),
  );
}
