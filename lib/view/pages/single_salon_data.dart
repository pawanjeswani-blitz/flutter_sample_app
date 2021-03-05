import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/api/feedback_service.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/feedback.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SingleStoreData extends StatefulWidget {
  final SalonData salonInfo;
  final int salonId;

  const SingleStoreData({Key key, this.salonInfo, this.salonId})
      : super(key: key);

  @override
  _SingleStoreDataState createState() => _SingleStoreDataState();
}

class _SingleStoreDataState extends State<SingleStoreData> {
  SalonData _salonData;
  final PagingController<int, FeedBackModel> _pagingController =
      PagingController(firstPageKey: 1);
  double defaultOverride;
  @override
  void initState() {
    super.initState();
    // controller = TabController(length: 2, vsync: this);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _loadServices();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await FeedBackService.getSalonRating(pageKey, widget.salonInfo.id);
      final hasMore = newItems.data.hasMore;
      // if response from hasMore ==true change the pageNO that is pageKey in this case
      if (hasMore == true) {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems.data.list, nextPageKey);
      } else {
        // _reachedEnd();
        _pagingController.appendLastPage(newItems.data.list);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  void _loadServices() async {
    final res = await LoadSalons.getSingleStore(widget.salonInfo.id);
    setState(() {
      _salonData = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: defaultSize * 2.5,
          top: defaultSize * 2.0,
        ),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(
              bottom: defaultSize * 2.5,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_iphone,
                  color: AppColor.PRIMARY_MEDIUM,
                  size: defaultSize * 3.0,
                ),
                Text(
                  _salonData.phoneNumber.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: defaultSize * 2.0,
                    color: AppColor.PRIMARY_MEDIUM,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: AppColor.PRIMARY_MEDIUM,
                size: defaultSize * 3.0,
              ),
              Expanded(
                child: Text(
                  _salonData.address.toString(),
                  maxLines: 8,
                  // overflow: TextOverflow.ellipsis,
                  // textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: defaultSize * 1.75,
                    color: AppColor.PRIMARY_MEDIUM,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: defaultSize * 2.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: defaultSize * 1.0, vertical: defaultSize * 1.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Reviews",
                  style: GoogleFonts.poppins(
                    color: Color.fromRGBO(172, 125, 83, 1),
                    fontSize: defaultSize * 2.0,
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
          Expanded(
            child: Container(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
                ),
                child: PagedListView<int, FeedBackModel>(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<FeedBackModel>(
                      firstPageProgressIndicatorBuilder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                      newPageProgressIndicatorBuilder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: defaultSize * 2.0,
                              top: defaultSize * 2.0,
                            ),
                            child: Text(
                              "No reviews yet",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontSize: defaultSize * 2.0,
                              ),
                            ),
                          ),
                        );
                      },
                      // noMoreItemsIndicatorBuilder: (context) {
                      //   return Center(
                      //     child: Padding(
                      //       padding: EdgeInsets.only(
                      //         bottom: defaultSize * 2.0,
                      //         top: defaultSize * 2.0,
                      //       ),
                      //       child: Text(
                      //         "No more reviews",
                      //         style: GoogleFonts.poppins(
                      //           color: Colors.grey[500],
                      //           fontSize: defaultSize * 2.0,
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // },
                      itemBuilder: (context, item, index) => Container(
                            margin: EdgeInsets.only(bottom: defaultSize * 1.5),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: defaultSize * 1.0,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: AppColor.PRIMARY_MEDIUM,
                                    child: Center(
                                      child: Text(
                                        "${item.userDetails.firstName[0]}${item.userDetails.lastName[0] == null ? "" : item.userDetails.lastName[0]}",
                                        style: GoogleFonts.poppins(
                                            fontSize: defaultSize * 2.0,
                                            color: Colors.white,
                                            letterSpacing: 2.0),
                                      ),
                                    ),
                                    radius: defaultSize * 2.75,
                                  ),
                                ),
                                SizedBox(
                                  width: defaultSize * 1.5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: defaultSize * 1.25,
                                    ),
                                    SmoothStarRating(
                                      rating: item.rating.toDouble(),
                                      isReadOnly: true,
                                      size: defaultSize * 2.0,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      color: AppColor.PRIMARY_MEDIUM,
                                      borderColor: AppColor.PRIMARY_MEDIUM,
                                      starCount: 5,
                                      allowHalfRating: false,
                                      spacing: 2.0,
                                    ),
                                    SizedBox(
                                      height: defaultSize * 1.0,
                                    ),
                                    // Text(
                                    //   item.comment,
                                    //   textAlign: TextAlign.center,
                                    //   overflow: TextOverflow.clip,
                                    // style: GoogleFonts.poppins(
                                    //     fontSize: defaultSize * 1.5,
                                    //     color: AppColor.PRIMARY_MEDIUM,
                                    //     fontWeight: FontWeight.w500),
                                    // ),
                                    // Expanded(
                                    //   child: Text(
                                    //     item.comment == null ? "" : item.comment,
                                    //     maxLines: 8,
                                    //     // overflow: TextOverflow.ellipsis,
                                    //     // textDirection: TextDirection.rtl,
                                    //     textAlign: TextAlign.start,
                                    //     style: GoogleFonts.poppins(
                                    //       fontSize: defaultSize * 1.5,
                                    //       color: AppColor.PRIMARY_MEDIUM,
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width:
                                    //       MediaQuery.of(context).size.width - 100,
                                    //   child: Text(
                                    //     item.comment == null ? "" : item.comment,
                                    //     maxLines: 4,
                                    //     textAlign: TextAlign.justify,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     softWrap: true,
                                    //     style: GoogleFonts.poppins(
                                    //         fontSize: defaultSize * 1.5,
                                    //         color: AppColor.PRIMARY_MEDIUM,
                                    //         fontWeight: FontWeight.w500),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width:
                                    //       MediaQuery.of(context).size.width - 150,
                                    //   child: Text(
                                    //     item.comment == null ? "" : item.comment,
                                    //     maxLines: 4,
                                    //     textAlign: TextAlign.justify,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     softWrap: true,
                                    //   style: GoogleFonts.poppins(
                                    //       fontSize: defaultSize * 1.5,
                                    //       color: AppColor.PRIMARY_MEDIUM,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // ),
                                    Row(
                                      //Widgets which help to display a list of children widgets are the 'culprit', they make your text widget not know what the maximum width is. In OP's example it is the ButtonBar widget.
                                      children: [
                                        Container(
                                          width: defaultSize *
                                              28, //This helps the text widget know what the maximum width is again! You may also opt to use an Expanded widget instead of a Container widget, if you want to use all remaining space.
                                          child: Container(
                                            child: Text(
                                              item.comment == null
                                                  ? ""
                                                  : item.comment,
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.poppins(
                                                  fontSize: defaultSize * 1.5,
                                                  color:
                                                      AppColor.PRIMARY_MEDIUM,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Expanded(
                                    //   child: Text(
                                    //     item.comment == null ? "" : item.comment,
                                    //     maxLines: 8,
                                    //     // overflow: TextOverflow.ellipsis,
                                    //     // textDirection: TextDirection.rtl,
                                    //     textAlign: TextAlign.start,
                                    //     style: GoogleFonts.poppins(
                                    //       fontSize: defaultSize * 1.75,
                                    //       color: AppColor.PRIMARY_MEDIUM,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
