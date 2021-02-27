import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/api/get_appointment_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/appointment_response.dart';
import 'package:saloonwala_consumer/model/appointment_salon_details.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class UpcomingAppointmentScreen extends StatefulWidget {
  @override
  _UpcomingAppointmentScreenState createState() =>
      _UpcomingAppointmentScreenState();
}

class _UpcomingAppointmentScreenState extends State<UpcomingAppointmentScreen> {
  final PagingController<int, AppointmentResponse> _pagingController =
      PagingController(firstPageKey: 1);
  double defaultOverride;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SalonDetails _salonDetails;
  String news;

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await GetAppointmentService.getSalonFeed(pageKey);
      final hasMore = newItems.data.hasMore;

      // if response from hasMore ==true change the pageNO that is pageKey in this case
      if (hasMore == true) {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data.list, nextPageKey);
        for (int index = 0; index < newItems.data.list.length; index++) {
          news = newItems.data.list[index].status;
        }
      } else {
        // _reachedEnd();
        _pagingController.appendLastPage(newItems.data.list);
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
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Upcoming Appointments",
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 2.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  floating: true,
                  pinned: true,
                  snap: true,
                  expandedHeight: 120.0,
                  bottom: TabBar(
                    indicatorPadding: EdgeInsets.symmetric(
                        vertical: defaultSize * 0.8,
                        horizontal: defaultSize * 2.25),
                    indicatorColor: AppColor.LOGIN_BACKGROUND,
                    tabs: [
                      Tab(
                        child: Text(
                          'Awaiting',
                          style: GoogleFonts.poppins(
                            fontSize: defaultSize * 1.654,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Confirmed',
                          style: GoogleFonts.poppins(
                            fontSize: defaultSize * 1.654,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  flexibleSpace: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              AppColor.PRIMARY_LIGHT,
                              AppColor.PRIMARY_MEDIUM
                            ])),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: new TabBarView(
              children: [
                Container(
                  child: PagedListView<int, AppointmentResponse>(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    pagingController: _pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<AppointmentResponse>(
                            firstPageProgressIndicatorBuilder: (context) =>
                                _getLoaderView(),
                            itemBuilder: (context, item, index) =>
                                item.status == "REQUESTED"
                                    ? AppointmentCard(
                                        salonTitle: item.salonDetails.name
                                            .toUpperCase(),
                                        date: DateUtil.getDisplayFormatDay(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                item.startTime)),
                                        time: DateUtil.getDisplayFormatHour(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                item.startTime)),
                                        cancel: () {},
                                        viewDetails: () {},
                                      )
                                    : SizedBox()),
                  ),
                ),
                Container(
                  child: PagedListView<int, AppointmentResponse>(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    pagingController: _pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<AppointmentResponse>(
                            firstPageProgressIndicatorBuilder: (context) =>
                                _getLoaderView(),
                            itemBuilder: (context, item, index) =>
                                item.status == "Booked"
                                    ? AppointmentCard(
                                        salonTitle: item.salonDetails.name
                                            .toUpperCase(),
                                        date: DateUtil.getDisplayFormatDay(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                item.startTime)),
                                        time: DateUtil.getDisplayFormatHour(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                item.startTime)),
                                        cancel: () {},
                                        viewDetails: () {},
                                      )
                                    : SizedBox()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLoaderView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
