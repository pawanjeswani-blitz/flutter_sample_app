import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/api/favorite_service.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/salon_services_tabview.dart';
import 'package:saloonwala_consumer/view/pages/search_salons.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class RandomTestSearchBAR extends StatefulWidget {
  @override
  _RandomTestSearchBARState createState() => _RandomTestSearchBARState();
}

class _RandomTestSearchBARState extends State<RandomTestSearchBAR> {
  final PagingController<int, SalonData> _pagingController =
      PagingController(firstPageKey: 1);
  double defaultOverride;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const historyLength = 5;

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  List<String> filteredSearchHistory;

  String selectedTerm;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;
  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
      controller = FloatingSearchBarController();
      filteredSearchHistory = filterSearchTerms(filter: null);
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                    child: PagedListView<int, SalonData>(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0.0),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<SalonData>(
                          firstPageProgressIndicatorBuilder: (context) =>
                              _getLoaderView(),
                          itemBuilder: (context, item, index) => SalonCard(
                                title: item.name.toString(),
                                distance: item.distance.toStringAsFixed(1),
                                customfunction: () async {
                                  final userProfile = await AppSessionManager
                                      .getUserProfileAfterLogin();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SalonServicesTabView(
                                            salonId: item.id,
                                            salonName: item.name,
                                            userprofile: userProfile,
                                          )));
                                },
                                customFunctionLike: () {
                                  _onAddFavorite(item.id);
                                },
                              )),
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

  var _getTextFormFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintStyle: GoogleFonts.poppins(color: AppColor.PRIMARY_LIGHT),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: Colors.transparent, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: Colors.transparent, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
    disabledBorder: InputBorder.none,
    errorStyle:
        GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
    contentPadding: EdgeInsets.only(left: 15, bottom: 14, top: 14, right: 15),
    // hintText: hint,
  );
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
    final snackBar = SnackBar(content: Text(errorText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Widget _reachedEnd() {
    return Text("you've reached the end",
        style: GoogleFonts.poppins(
            fontSize: defaultOverride * 2.0, color: AppColor.PRIMARY_LIGHT));
  }

  Widget _getLoaderView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
