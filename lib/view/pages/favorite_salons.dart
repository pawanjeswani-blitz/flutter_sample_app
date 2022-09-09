import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/favorite_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/appointment_salon_details.dart';
import 'package:saloonwala_consumer/model/paginated_salon_response.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/salon_services_tabview.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:shimmer/shimmer.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FavoriteSalonsScreen extends StatefulWidget {
  @override
  _FavoriteSalonsScreenState createState() => _FavoriteSalonsScreenState();
}

class _FavoriteSalonsScreenState extends State<FavoriteSalonsScreen> {
  List<SalonData> _salonData;
  SalonData _wsalonData;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _pageSize = 100;
  final PagingController<int, SalonData> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await FavoriteService.getSalonFeedForFavorite();
      final isLastPage = newItems.data.list.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data.list);
      } else {
        final nextPageKey = pageKey + newItems.data.list.length;
        _pagingController.appendPage(newItems.data.list, nextPageKey);
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
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
            height: defaultSize * 12.0,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_MEDIUM]),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60))),
            child: Center(
              child: Text(
                "Saved Salons",
                style: GoogleFonts.poppins(
                  fontSize: defaultSize * 2.25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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
                    noItemsFoundIndicatorBuilder: (context) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: defaultSize * 2.0,
                              top: defaultSize * 4.0),
                          child: Column(
                            children: [
                              Container(
                                  height: defaultSize * 10,
                                  child:
                                      Image.asset('assets/images/no_favs.png')),
                              SizedBox(
                                height: defaultSize * 2.0,
                              ),
                              Text(
                                "No Favorites Salons",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: defaultSize * 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, item, index) => FavoriteSalonCard(
                      title: item.name,
                      distance: item.address,
                      customfunction: () async {
                        await _onRemoveFavorite(item.id);
                        _onRefresh();
                      },
                      thumb: item.thumbnail1,
                      redirect: () async {
                        final userProfile =
                            await AppSessionManager.getUserProfileAfterLogin();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SalonServicesTabView(
                              salonId: item.id,
                              salonName: item.name,
                              userprofile: userProfile,
                              salonInfo: item,
                              // salonList: item,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onRefresh() => Future.sync(
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
                child: FavoriteSalonCard(
                  title: " ",
                  distance: " ",
                  redirect: () {},
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

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
