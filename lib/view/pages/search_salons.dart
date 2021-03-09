import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/view/pages/salon_services_tabview.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class SearchSalons extends StatefulWidget {
  @override
  _SearchSalonsState createState() => _SearchSalonsState();
}

class _SearchSalonsState extends State<SearchSalons> {
  static const historyLength = 5;

  List<String> _searchHistory = [];

  List<String> filteredSearchHistory;

  String selectedTerm;

  final PagingController<int, SalonData> _pagingController =
      PagingController(firstPageKey: 1);
  double defaultOverride;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  String name = " ";
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await LoadSalons.getSalonSearchFeed(pageKey, selectedTerm);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: FloatingSearchAppBar(
            alwaysOpened: true,
            iconColor: Colors.grey[500],
            controller: controller,
            colorOnScroll: Colors.white,
            hintStyle: GoogleFonts.poppins(),
            transitionCurve: Curves.easeInOut,
            // progress: 70.0,
            // clearQueryOnClose: true,
            // alwaysOpened:true,
            body: selectedTerm == null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: defaultSize * 40.0,
                          child: Image.asset('assets/images/search.png'),
                        ),
                        Text('Search Salons',
                            style: GoogleFonts.poppins(
                              fontSize: defaultSize * 3.0,
                              color: Colors.grey[600],
                            ))
                      ],
                    ),
                  )
                : Container(
                    child: PagedListView<int, SalonData>(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<SalonData>(
                          firstPageProgressIndicatorBuilder: (context) =>
                              Center(child: CircularProgressIndicator()),
                          itemBuilder: (context, item, index) =>
                              SearchSalonCard(
                                title: item.name.toString(),
                                distance: item.address,
                                thumb: item.thumbnail1,
                                customfunction: () async {
                                  final userProfile = await AppSessionManager
                                      .getUserProfileAfterLogin();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SalonServicesTabView(
                                            salonId: item.id,
                                            salonName: item.name,
                                            userprofile: userProfile,
                                            salonInfo: item,
                                          )));
                                },
                                customFunctionLike: () {
                                  // _onAddFavorite(item.id);
                                },
                              )),
                    ),
                  ),
            // transition: CircularFloatingSearchBarTransition(),

            title: Text(
              selectedTerm ?? 'Start Typing...',
              style: GoogleFonts.poppins(
                fontSize: defaultSize * 1.5,
                // letterSpacing: 1.0,
                color: Colors.grey[500],
              ),
            ),
            hint: 'Search and find out...',
            actions: [
              FloatingSearchBarAction.searchToClear(),
            ],
            onQueryChanged: (query) {
              setState(() {
                filteredSearchHistory = filterSearchTerms(filter: query);
              });
            },
            onSubmitted: (query) {
              setState(() {
                addSearchTerm(query);
                selectedTerm = query;
              });

              controller.close();
              _fetchPage(1);
            },
          ),
        ),
      ),
    );
  }
}
