import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/favorite_service.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/salon_servicesUI.dart';
import 'package:saloonwala_consumer/view/pages/salon_services_tabview.dart';
import 'package:saloonwala_consumer/view/pages/search_salons.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:like_button/like_button.dart';

class RandomLikes extends StatefulWidget {
  @override
  _RandomLikesState createState() => _RandomLikesState();
}

class _RandomLikesState extends State<RandomLikes> {
  final PagingController<int, SalonData> _pagingController =
      PagingController(firstPageKey: 1);
  double defaultOverride;
  // List<bool> liked = [];
  Color _color;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LoadSalons.getSalonFeed(pageKey);
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.timer.cancel();
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Colors.transparent,
                    // pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    // expandedHeight: defaultSize * 10.0,
                    title: _title(),
                    elevation: 2.0,
                    flexibleSpace: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 0.0, color: AppColor.PRIMARY_MEDIUM),
                              ),
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    AppColor.PRIMARY_LIGHT,
                                    AppColor.PRIMARY_MEDIUM
                                  ])),
                        ),
                      ],
                    )),
              ];
            },
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    // height: 60.0,

                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: defaultSize * 1.0,
                      bottom: defaultSize * 1.0,
                      right: defaultSize * 2.0,
                      left: defaultSize * 2.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultSize * 3.2),
                        color: Colors.white,
                        boxShadow: kElevationToShadow[2],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultSize * 2.0),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchSalons()));
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Salons',
                            hintStyle: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_MEDIUM),
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
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: RefreshIndicator(
                        onRefresh: () => Future.sync(
                          () => _pagingController.refresh(),
                        ),
                        child: PagedListView<int, SalonData>(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0.0),
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<SalonData>(
                            firstPageProgressIndicatorBuilder: (context) =>
                                _loadingWidget(),
                            newPageProgressIndicatorBuilder: (context) =>
                                _loadingWidget(),
                            noMoreItemsIndicatorBuilder: (context) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: defaultSize * 2.0,
                                  ),
                                  child: Text(
                                    "You've reached the end",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[500],
                                      fontSize: defaultSize * 2.0,
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemBuilder: (context, item, index) =>
                                GestureDetector(
                              onTap: () async {
                                final userProfile = await AppSessionManager
                                    .getUserProfileAfterLogin();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SalonServicesTabView(
                                      salonId: item.id,
                                      salonName: item.name,
                                      userprofile: userProfile,
                                      salonInfo: item,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: defaultSize * 1.0,
                                    right: defaultSize * 1.0,
                                    top: defaultSize * 0.5,
                                    bottom: defaultSize * 1.2),
                                child: Card(
                                  elevation: 1.85,
                                  color: Colors.white,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    children: [
                                      item.thumbnail1 != null &&
                                              item.thumbnail1.isNotEmpty
                                          ? Container(
                                              height: defaultSize * 10.5,
                                              width: defaultSize * 15,
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                      item.thumbnail1),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: defaultSize * 10.5,
                                              width: defaultSize * 15,
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      "https://upload.wikimedia.org/wikipedia/commons/b/b2/Hair_Salon_Stations.jpg"),
                                                ),
                                              ),
                                            ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: defaultSize * 17.0),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: defaultSize * 1.35),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                item.name,
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        defaultSize * 1.70,
                                                    color:
                                                        AppColor.PRIMARY_MEDIUM,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: defaultSize * 1.0,
                                              ),
                                              Text(item.address,
                                                  style: GoogleFonts.poppins(
                                                      fontSize:
                                                          defaultSize * 1.25,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColor
                                                          .PRIMARY_MEDIUM)),
                                              // Row(
                                              //   children: [
                                              //     Icon(
                                              //       Icons.location_on,
                                              //       color: Color.fromRGBO(96, 127, 99, 1.0),
                                              //       size: defaultSize * 1.5,
                                              //     ),
                                              //     SizedBox(width: defaultSize * 0.5),
                                              //     Text(
                                              //       widget.distance,
                                              //       style: GoogleFonts.poppins(
                                              //           fontSize: defaultSize * 1.25,
                                              //           fontWeight: FontWeight.w400,
                                              //           color: AppColor.PRIMARY_MEDIUM),
                                              //     ),
                                              // SizedBox(width: defaultSize * 0.5),
                                              // Text(
                                              //   "|",
                                              //   style: GoogleFonts.poppins(
                                              //       fontSize: defaultSize * 1.5,
                                              //       fontWeight: FontWeight.w500,
                                              //       color: AppColor.PRIMARY_MEDIUM),
                                              // ),
                                              // SizedBox(width: defaultSize * 0.5),
                                              // Icon(
                                              //   Icons.star,
                                              //   color: Color.fromRGBO(96, 127, 99, 1.0),
                                              //   size: defaultSize * 1.5,
                                              // ),
                                              // SizedBox(width: defaultSize * 0.5),
                                              // Text(
                                              //   "4.0 / 5",
                                              //   style: GoogleFonts.poppins(
                                              //       fontSize: defaultSize * 1.25,
                                              //       fontWeight: FontWeight.w400,
                                              //       color: AppColor.PRIMARY_MEDIUM),
                                              // ),
                                            ],
                                          ),
                                          // ],
                                        ),
                                      ),
                                      // ),
                                      Spacer(),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: defaultSize * 2.5),
                                        child: Column(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: defaultSize * 3.0,
                                              width: defaultSize * 3.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 3,
                                                    offset: Offset(0,
                                                        0), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  LikeButton(
                                                    isLiked: item.like,
                                                    onTap:
                                                        (bool isLiked) async {
                                                      if (isLiked) {
                                                        _onRemoveFavorite(
                                                            item.id);
                                                      } else {
                                                        _onAddFavorite(item.id);
                                                      }
                                                      return !isLiked;
                                                    },
                                                    size: defaultSize * 1.82,
                                                    circleColor: CircleColor(
                                                        start:
                                                            Color(0xff00ddff),
                                                        end: Color(0xff0099cc)),
                                                    bubblesColor: BubblesColor(
                                                      dotPrimaryColor:
                                                          Color(0xff33b5e5),
                                                      dotSecondaryColor:
                                                          Color(0xff0099cc),
                                                    ),
                                                    likeBuilder:
                                                        (bool isLiked) {
                                                      print(isLiked);
                                                      return Icon(
                                                        Icons.favorite,
                                                        color: isLiked
                                                            ? Colors.red[800]
                                                            : Colors.grey[400],
                                                        size:
                                                            defaultSize * 1.85,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // InkWell(
                                            //   splashColor: Colors.transparent,
                                            //   highlightColor: Colors.transparent,
                                            //   onTap: () {
                                            //     widget.customFunctionLike();
                                            //   },
                                            //   child: Container(
                                            //     height: defaultSize * 2.8,
                                            //     width: defaultSize * 2.8,
                                            //     decoration: BoxDecoration(
                                            //       shape: BoxShape.circle,
                                            //       color: Colors.white,
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //           color: Colors.grey.withOpacity(0.5),
                                            //           spreadRadius: 1,
                                            //           blurRadius: 3,
                                            //           offset:
                                            //               Offset(0, 0), // changes position of shadow
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     child: Icon(
                                            //       Icons.favorite,
                                            //       size: defaultSize * 1.85,
                                            //       color: widget.color,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> onLikeButtonTapped(bool isLiked) async {
  //   if (isLiked) {
  //     _onRemoveFavorite(item.id);
  //   } else {
  //     _onAddFavorite(item.id);
  //   }

  /// send your request here
  // final bool success= await sendRequest();

  /// if failed, you can do nothing
  // return success? !isLiked:isLiked;

  //   return !isLiked;
  // }

  onResfe() => Future.sync(
        () => _pagingController.refresh(),
      );
  Widget _loadingWidget() {
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              int offset = 0;
              int time = 400;
              offset += 5;
              time = 400 + offset;
              return Shimmer.fromColors(
                highlightColor: Colors.white,
                baseColor: Colors.grey[300],
                child: SalonCard(
                  title: "",
                  distance: "",
                  customFunctionLike: () {},
                  customfunction: () {},
                ),
                period: Duration(milliseconds: time),
              );
            }));
  }

  Future<SuperResponse<bool>> _onRemoveFavorite(int salonId) async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await FavoriteService.favoriteRemove(salonId);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            //user is register
            print(response.data);
            showSnackBar("Salon removed from favorites succesfully");
          } else
            showSnackBar("Something went wrong");
        } else
          showSnackBar(response.error);
      } catch (ex) {
        Navigator.of(context).pop();
        showSnackBar("Something went wrong.");
      }
    } else
      showSnackBar("No internet connected");
  }

  Future<SuperResponse<bool>> _onAddFavorite(int salonId) async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await FavoriteService.favoriteUpdate(salonId);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            //user is register
            print(response.data);
            showSnackBar("Salon added to favorites succesfully");
          } else
            showSnackBar("Something went wrong");
        } else
          showSnackBar(response.error);
      } catch (ex) {
        Navigator.of(context).pop();
        showSnackBar("Something went wrong.");
      }
    } else
      showSnackBar("No internet connected");
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(
      content: Text(errorText),
      duration: Duration(milliseconds: 500),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _title() => Container(
        child: Row(
          children: [
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    'assets/images/only_name_logo.png',
                    height: defaultOverride * 3.2,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(),
          ],
        ),
      );
}

class ShimmerList extends StatefulWidget {
  @override
  _ShimmerListState createState() => _ShimmerListState();
}

class _ShimmerListState extends State<ShimmerList> {
  double defaultOverride;

  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: Colors.transparent,
                  // pinned: true,
                  floating: true,
                  automaticallyImplyLeading: false,
                  // expandedHeight: defaultSize * 10.0,
                  title: Container(
                    child: Row(
                      children: [
                        Column(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'assets/images/only_name_logo.png',
                                height: defaultOverride * 3.2,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(),
                      ],
                    ),
                  ),
                  elevation: 2.0,
                  flexibleSpace: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.0, color: AppColor.PRIMARY_MEDIUM),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColor.PRIMARY_LIGHT,
                                  AppColor.PRIMARY_MEDIUM
                                ])),
                      ),
                    ],
                  )),
            ];
          },
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  // color: Colors.white,
                  // height: 60.0,

                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: defaultSize * 1.0,
                    bottom: defaultSize * 1.0,
                    right: defaultSize * 2.0,
                    left: defaultSize * 2.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultSize * 3.2),
                      color: Colors.white,
                      boxShadow: kElevationToShadow[2],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultSize * 2.0),
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchSalons()));
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Salons',
                          hintStyle: GoogleFonts.poppins(
                              color: AppColor.PRIMARY_MEDIUM),
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
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: AppColor.PRIMARY_DARK,
                        style:
                            GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            offset += 5;
                            time = 800 + offset;
                            return Shimmer.fromColors(
                                highlightColor: Colors.white,
                                baseColor: Colors.grey[300],
                                child: SalonCard(
                                  title: "",
                                  distance: "",
                                  customFunctionLike: () {},
                                  customfunction: () {},
                                ),
                                period: Duration(milliseconds: time));
                          })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class DelayedList extends StatefulWidget {
//   @override
//   _DelayedListState createState() => _DelayedListState();
// }

// class _DelayedListState extends State<DelayedList> {
//   bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     Timer timer = Timer(Duration(seconds: 3), () {
//       setState(() {
//         isLoading = false;
//       });
//     });

//     return isLoading
//         ? ShimmerList()
//         : RandomLikes(
//             timer: timer,
//           );
//   }
// }
