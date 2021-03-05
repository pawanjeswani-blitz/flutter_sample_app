import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/view/pages/salon_servicesUI.dart';
import 'package:saloonwala_consumer/view/pages/single_salon_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SalonServicesTabView extends StatefulWidget {
  final int salonId;
  final String salonName;
  final SalonData salonInfo;
  final UserProfileLogin userprofile;
  final List<SalonData> salonList;
  const SalonServicesTabView({
    Key key,
    this.salonId,
    this.salonName,
    this.userprofile,
    this.salonInfo,
    this.salonList,
  }) : super(key: key);
  @override
  _SalonServicesTabViewState createState() => _SalonServicesTabViewState();
}

class _SalonServicesTabViewState extends State<SalonServicesTabView>
    with SingleTickerProviderStateMixin {
  TabController controller;
  var bannerImagesList = List<String>();
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<String> _getImages() {
    bannerImagesList = [
      widget.salonInfo.thumbnail1 != null
          ? widget.salonInfo.thumbnail1
          : "https://i.postimg.cc/D052dhhF/saloonwala-nobg.png",
      widget.salonInfo.thumbnail2 != null
          ? widget.salonInfo.thumbnail2
          : 'https://i.postimg.cc/D052dhhF/saloonwala-nobg.png',
      widget.salonInfo.thumbnail3 != null
          ? widget.salonInfo.thumbnail3
          : 'https://i.postimg.cc/D052dhhF/saloonwala-nobg.png',
      widget.salonInfo.thumbnail4 != null
          ? widget.salonInfo.thumbnail4
          : 'https://i.postimg.cc/D052dhhF/saloonwala-nobg.png'
    ];
    return bannerImagesList;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  leading: InkWell(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      // height: 5.0,
                      // width: 5.0,
                      margin: EdgeInsets.only(
                          left: defaultSize * 1.5, top: defaultSize * 2.5),
                      // padding: EdgeInsets.all(defaultSize * 1.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.LOGIN_BACKGROUND,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        // size: defaultSize * 2.0,
                      ),
                    ),
                  ),
                  backgroundColor: AppColor.PRIMARY_MEDIUM,
                  // pinned: true,
                  floating: true,
                  automaticallyImplyLeading: false,
                  expandedHeight: defaultSize * 20.0,
                  // title:
                  elevation: 2.0,
                  flexibleSpace: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: defaultSize * 30.0,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            // autoPlayInterval: Duration(seconds: 2),
                            // aspectRatio: 3 / 4,
                            viewportFraction: 1.0,
                            // aspectRatio: 16 / 9,
                            // height: defaultSize * 100.0,
                            autoPlayCurve: Curves.easeInOut,
                            enlargeCenterPage: true,
                          ),
                          items: _getImages()
                              .map((item) => Container(
                                    margin: EdgeInsets.only(
                                        top: defaultSize * 3.0, bottom: 0.0),
                                    width: double.infinity,
                                    // height: defaultSize * 39.0,
                                    child: CachedNetworkImage(
                                      imageUrl: item,
                                      fit: BoxFit.fill,
                                      height: 1000,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  )),
            ];
          },
          body: Column(
            children: [
              Container(
                height: defaultSize * 15.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColor.PRIMARY_LIGHT,
                          AppColor.PRIMARY_MEDIUM
                        ]),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30))),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: defaultSize * 2.5, bottom: defaultSize * 2.5),
                      child: Text(widget.salonName.toUpperCase(),
                          style: GoogleFonts.poppins(
                              fontSize: defaultSize * 2.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: defaultSize * 2.0),
                      width: defaultSize * 35.0,
                      height: defaultSize * 3.4,
                      child: TabBar(
                          unselectedLabelColor: Colors.white,
                          controller: controller,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: AppColor.LOGIN_BACKGROUND,
                          ),
                          tabs: [
                            Tab(
                              text: 'Services',
                            ),
                            Tab(
                              text: 'Details',
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(controller: controller, children: [
                  SalonServicesUI(
                    salonId: widget.salonId,
                    salonName: widget.salonName,
                    userprofile: widget.userprofile,
                    salonInfo: widget.salonInfo,
                  ),
                  SingleStoreData(
                    salonInfo: widget.salonInfo,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
