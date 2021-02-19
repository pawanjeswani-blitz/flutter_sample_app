import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:saloonwala_consumer/view/pages/salon_servicesUI.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, SalonData> _pagingController =
      PagingController(firstPageKey: 1);
  double defaultOverride;

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
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: defaultSize * 15.0,
                title: _title(),
                elevation: 0.0,
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
        body: Container(
          child: PagedListView<int, SalonData>(
            padding: const EdgeInsets.all(0.0),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<SalonData>(
                firstPageProgressIndicatorBuilder: (context) =>
                    _getLoaderView(),
                itemBuilder: (context, item, index) => SalonCard(
                      title: item.name.toString(),
                      distance: item.distance.toStringAsFixed(1),
                      customfunction: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SalonServicesUI(
                                  salonId: item.id,
                                )));
                      },
                    )),
          ),
        ),
      ),
    );
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
