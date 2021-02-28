import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/api/get_appointment_service.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/appointment_response.dart';
import 'package:saloonwala_consumer/model/appointment_salon_details.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:saloonwala_consumer/view/pages/salon_slots_ui.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class RandomTest extends StatefulWidget {
  @override
  _RandomTestState createState() => _RandomTestState();
}

class _RandomTestState extends State<RandomTest> {
  final _pageSize = 100;
  final PagingController<int, Services> _pagingController =
      PagingController(firstPageKey: 0);
  List<Services> _selectedServiceList = [];
  double defaultSize;

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LoadSalons.getServicesList();
      final isLastPage = newItems.data.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data);
      } else {
        final nextPageKey = pageKey + newItems.data.length;
        _pagingController.appendPage(newItems.data, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultOverride = SizeConfig.defaultSize;
    defaultSize = defaultOverride;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            // _bottomservice(),
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
                                    final userProfile = await AppSessionManager
                                        .getUserProfile();
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SalonSlotsUI(
                                            // selectedServiceList:
                                            //     _selectedServiceList,
                                            // salonId: widget.salonId,
                                            // salonName: widget.salonName,
                                            // userProfile: widget.userprofile,
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
                    alignment: FractionalOffset.bottomCenter,
                    child: Text(" "),
                  ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
                ),
                child: PagedListView<int, Services>(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Services>(
                    firstPageProgressIndicatorBuilder: (context) =>
                        _getLoaderView(),
                    itemBuilder: (context, item, index) => ServiceCard(
                      pageController: _pagingController,
                      id: item.id,
                      maleRate: item.maleRate,
                      femaleRate: item.femaleRate,
                      description: item.description,
                      serviceName: item.serviceName,
                      globalDiscount: item.globalDiscount,
                      serviceDiscount: item.serviceDiscount,
                      index: index,
                      serviceinfo: [item],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomservice() {
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
                              margin: EdgeInsets.only(left: defaultSize * 2.5),
                              child: Text(
                                  '${_selectedServiceList.length} Service Added',
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 1.80,
                                      color: Colors.white)),
                            ),
                            Container(
                              child: Text("data"),
                            )
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
                                    // selectedServiceList:
                                    //     _selectedServiceList,
                                    // salonId: widget.salonId,
                                    // salonName: widget.salonName,
                                    // userProfile: widget.userprofile,
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
        : Align(alignment: FractionalOffset.bottomCenter, child: Text(" "));
  }
}

Widget _getLoaderView() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

class ServiceCard extends StatefulWidget {
  // final Services serviceInfoDetails;
  final PagingController<int, Services> pageController;

  final int maleRate, femaleRate, serviceDiscount, globalDiscount, id, index;
  final String serviceName, description;
  final List<Services> serviceinfo;

  const ServiceCard({
    Key key,
    this.pageController,
    this.maleRate,
    this.femaleRate,
    this.serviceDiscount,
    this.globalDiscount,
    this.id,
    this.serviceName,
    this.description,
    this.serviceinfo,
    this.index = 0,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: AppColor.VERY_LIGHT_GREEN),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTitleBar(),
          if (widget.maleRate != null && widget.maleRate > 0)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 16, right: 12),
              child: Row(
                children: [
                  Text("Male Rate: ₹${_getDiscountedPrice(widget.maleRate)}",
                      style: GoogleFonts.poppins(
                          color: AppColor.PRIMARY_DARK,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  SizedBox(width: 8),
                  if (_getDiscountedPrice(widget.maleRate) != widget.maleRate)
                    Text("₹${widget.maleRate}",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.lineThrough,
                            color: AppColor.PRIMARY_DARK,
                            fontSize: 15)),
                  SizedBox(width: 24),
                  if (_getDiscountedPrice(widget.maleRate) != widget.maleRate)
                    Text("${_getDiscountPercentage()}% Off",
                        style: GoogleFonts.poppins(
                            color: AppColor.PRIMARY_DARK, fontSize: 15)),
                ],
              ),
            ),
          if (widget.femaleRate != null && widget.femaleRate > 0)
            Padding(
              padding:
                  const EdgeInsets.only(left: 12, top: 2, right: 12, bottom: 8),
              child: Row(
                children: [
                  Text(
                      "Female Rate: ₹${_getDiscountedPrice(widget.femaleRate)}",
                      style: GoogleFonts.poppins(
                          color: AppColor.PRIMARY_DARK,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  SizedBox(width: 8),
                  if (_getDiscountedPrice(widget.femaleRate) !=
                      widget.femaleRate)
                    Text("₹${widget.femaleRate}",
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.lineThrough,
                            color: AppColor.PRIMARY_DARK,
                            fontSize: 15)),
                  SizedBox(width: 24),
                  if (_getDiscountedPrice(widget.femaleRate) !=
                      widget.femaleRate)
                    Text("${_getDiscountPercentage()}% Off",
                        style: GoogleFonts.poppins(
                            color: AppColor.PRIMARY_DARK, fontSize: 15)),
                ],
              ),
            ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(),
              Spacer(),
              widget.serviceinfo
                      .contains(widget.pageController.itemList[widget.index])
                  ? Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.serviceinfo.remove(
                                widget.pageController.itemList[widget.index]);
                          });
                          print(widget.serviceinfo.length);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 14),
                          decoration: BoxDecoration(
                              color: AppColor.DARK_ACCENT,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Text(
                            '+ Remove Service',
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
                            widget.serviceinfo.add(
                                widget.pageController.itemList[widget.index]);
                          });
                          print(widget.serviceinfo.length);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 14),
                          decoration: BoxDecoration(
                              color: AppColor.DARK_ACCENT,
                              borderRadius: BorderRadius.circular(50.0)),
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
  }

  int _getDiscountedPrice(int amount) {
    int percentageDiscount = _getDiscountPercentage();
    double discount = amount * percentageDiscount / 100;
    return (amount - discount).toInt();
  }

  int _getDiscountPercentage() {
    if (widget.serviceDiscount != null && widget.serviceDiscount > 0)
      return widget.serviceDiscount;
    else
      return widget.globalDiscount ?? 0;
  }

  Widget _getTitleBar() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: AppColor.PRIMARY_DARK,
            borderRadius: BorderRadius.circular(16.0)),
        child: Text("${widget.id}. ${widget.serviceName}",
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
      );
}
