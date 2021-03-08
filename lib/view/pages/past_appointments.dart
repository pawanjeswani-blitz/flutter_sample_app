import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/api/get_appointment_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/appointment_response.dart';
import 'package:saloonwala_consumer/model/appointment_salon_details.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:saloonwala_consumer/view/pages/rating_screen.dart';
import 'package:saloonwala_consumer/view/pages/view_booking_details.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class PastAppointments extends StatefulWidget {
  @override
  _PastAppointmentsState createState() => _PastAppointmentsState();
}

class _PastAppointmentsState extends State<PastAppointments> {
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
        length: 3,
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
                    "Past Appointments",
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
                        horizontal: defaultSize * 1.0),
                    indicatorColor: AppColor.LOGIN_BACKGROUND,
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: defaultSize * 1.0),
                          child: Text(
                            'Past',
                            style: GoogleFonts.poppins(
                              fontSize: defaultSize * 1.354,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: defaultSize * 1.0),
                          child: Text(
                            'Owner cancelled',
                            style: GoogleFonts.poppins(
                              fontSize: defaultSize * 1.354,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: defaultSize * 1.0),
                          child: Text(
                            'Customer cancelled',
                            style: GoogleFonts.poppins(
                              fontSize: defaultSize * 1.354,
                              fontWeight: FontWeight.w500,
                            ),
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
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => _pagingController.refresh(),
                    ),
                    child: PagedListView<int, AppointmentResponse>(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<
                              AppointmentResponse>(
                          firstPageProgressIndicatorBuilder: (context) =>
                              _getLoaderView(),
                          noItemsFoundIndicatorBuilder: (context) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: defaultSize * 2.0,
                                  bottom: defaultSize * 2.0,
                                ),
                                child: Text(
                                  "No Appointments Found",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontSize: defaultSize * 2.0,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemBuilder: (context, item, index) => item.status ==
                                  "DONE"
                              ? PastAppointmentCard(
                                  salonTitle:
                                      item.salonDetails.name.toUpperCase(),
                                  date: DateUtil.getDisplayFormatDay(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.startTime)),
                                  time: DateUtil.getDisplayFormatHour(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item.startTime)),
                                  viewDetails: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewBookingDetails(
                                          bookingId: item.id,
                                          cardcolor: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                  review: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SalonRatingScreen(
                                          bookingId: item.id,
                                          salonData: item.salonDetails,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : SizedBox()),
                    ),
                  ),
                ),
                Container(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => _pagingController.refresh(),
                    ),
                    child: PagedListView<int, AppointmentResponse>(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<
                              AppointmentResponse>(
                          noItemsFoundIndicatorBuilder: (context) {
                            return Center(
                              child: Text(
                                "No cancelled bookings found",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: defaultSize * 2.0,
                                ),
                              ),
                            );
                          },
                          firstPageProgressIndicatorBuilder: (context) =>
                              _getLoaderView(),
                          itemBuilder: (context, item, index) =>
                              item.status == "OWNER_CANCELLED"
                                  ? CancelledAppointmentCard(
                                      salonTitle:
                                          item.salonDetails.name.toUpperCase(),
                                      date: DateUtil.getDisplayFormatDay(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.startTime)),
                                      time: DateUtil.getDisplayFormatHour(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.startTime)),
                                      viewDetails: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewBookingDetails(
                                              bookingId: item.id,
                                              cardcolor: Colors.grey[200],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox()),
                    ),
                  ),
                ),
                Container(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => _pagingController.refresh(),
                    ),
                    child: PagedListView<int, AppointmentResponse>(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<
                              AppointmentResponse>(
                          noItemsFoundIndicatorBuilder: (context) {
                            return Center(
                              child: Text(
                                "No cancelled bookings found",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[200],
                                  fontSize: defaultSize * 2.0,
                                ),
                              ),
                            );
                          },
                          firstPageProgressIndicatorBuilder: (context) =>
                              _getLoaderView(),
                          itemBuilder: (context, item, index) =>
                              item.status == "CUST_CANCELLED"
                                  ? CancelledAppointmentCard(
                                      salonTitle:
                                          item.salonDetails.name.toUpperCase(),
                                      date: DateUtil.getDisplayFormatDay(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.startTime)),
                                      time: DateUtil.getDisplayFormatHour(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              item.startTime)),
                                      viewDetails: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ViewBookingDetails(
                                              bookingId: item.id,
                                              cardcolor: Colors.grey[200],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _refreshPage() => Future.sync(
        () => _pagingController.refresh(),
      );
  Widget _getLoaderView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
