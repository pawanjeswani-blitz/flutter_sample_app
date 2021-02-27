import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/pages/favorite_salons.dart';
import 'package:saloonwala_consumer/view/pages/home_page.dart';
import 'package:saloonwala_consumer/view/pages/user_profile_ui.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedPosition = 0;
  final _widgetList = [
    HomePage(),
    Center(child: Text("Favorite Salons")),
    UserProfileUI()
  ];
  double defaultOverride;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _selectedPosition,
                children: _widgetList,
              ),
            ),
            _getBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _getBottomBar() => Container(
        padding: EdgeInsets.symmetric(
            horizontal: defaultOverride * 0.0,
            vertical: defaultOverride * 0.75),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.PRIMARY_MEDIUM, AppColor.PRIMARY_DARK])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: defaultOverride * 1.25),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedPosition = 0;
                    _widgetList.removeAt(1);
                  });
                },
                child: Image.asset(
                  'assets/images/transparent_small_logo.png',
                  color: _selectedPosition == 0
                      ? AppColor.LOGIN_BACKGROUND
                      : Colors.white,
                  height: defaultOverride * 5.0,
                  width: defaultOverride * 5.0,
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  _selectedPosition == 1
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  size: defaultOverride * 3.2,
                  color: _selectedPosition == 1
                      ? AppColor.LOGIN_BACKGROUND
                      : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPosition = 1;
                    _widgetList.insert(1, FavoriteSalonsScreen());
                  });
                }),
            Container(
              margin: EdgeInsets.only(right: defaultOverride * 2.5),
              child: InkWell(
                onTap: () {
                  setState(() {
                    // _widgetList.removeAt(1);

                    _selectedPosition = 2;
                    _widgetList.insert(2, UserProfileUI());
                  });
                },
                child: Image.asset(
                  'assets/images/gp.png',
                  color: _selectedPosition == 2
                      ? AppColor.LOGIN_BACKGROUND
                      : Colors.white,
                  height: defaultOverride * 3.0,
                  width: defaultOverride * 3.0,
                ),
              ),
            ),
          ],
        ),
      );
}
