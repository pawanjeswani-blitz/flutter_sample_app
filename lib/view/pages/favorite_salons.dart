import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/favorite_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/salon_services_tabview.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';

class FavoriteSalonsScreen extends StatefulWidget {
  @override
  _FavoriteSalonsScreenState createState() => _FavoriteSalonsScreenState();
}

class _FavoriteSalonsScreenState extends State<FavoriteSalonsScreen> {
  List<SalonData> _salonData;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _loadSalons();
  }

  void _loadSalons() async {
    final res = await FavoriteService.getSalonFeedForFavorite();
    setState(() {
      _salonData = res.data.list;
    });
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
            child: _salonData != null
                ? ListView.builder(
                    // itemCount: _salonData.length,
                    itemBuilder: (BuildContext context, int position) {
                      return FavoriteSalonCard(
                        title: _salonData[position].name,
                        distance:
                            _salonData[position].distance.toStringAsFixed(1),
                        customfunction: () async {
                          await _onRemoveFavorite(_salonData[position].id);
                          _loadSalons();
                        },
                        redirect: () async {
                          final userProfile = await AppSessionManager
                              .getUserProfileAfterLogin();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SalonServicesTabView(
                                salonId: _salonData[position].id,
                                salonName: _salonData[position].name,
                                userprofile: userProfile,
                                // salonInfo: ,
                                salonList: _salonData,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: _salonData.length,
                  )
                : Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
