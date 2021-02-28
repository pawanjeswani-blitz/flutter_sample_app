import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/view/pages/salon_servicesUI.dart';
import 'package:saloonwala_consumer/view/pages/single_salon_data.dart';

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
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    // defaultOverride = defaultSize;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: InkWell(
                onTap: () => Navigator.of(context).pop(true),
                child: Container(
                  // height: defaultSize * 4.0,
                  // width: defaultSize * 4.0,
                  margin: EdgeInsets.only(
                      left: defaultSize * 1.5, top: defaultSize * 2.5),
                  // padding: EdgeInsets.all(defaultSize * 1.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColor.LOGIN_BACKGROUND),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    // size: defaultSize * 2.0,
                  ),
                ),
              ),
              expandedHeight: defaultSize * 20.0,
              elevation: 0,
              floating: true,
              pinned: true,
              snap: true,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg",
                    fit: BoxFit.cover,
                  )),
                ],
              ),
            ),
            SliverList(
              delegate: new SliverChildListDelegate([
                Container(
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
              ]),
            ),
          ];
        },
        body: TabBarView(controller: controller, children: [
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
    );
  }
}
