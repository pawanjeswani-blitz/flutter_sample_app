import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
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
    Center(child: Text("Favorite Screen")),
    UserProfileUI()
  ];
  double defaultOverride;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      body: Column(
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
    );
  }

  Widget _getBottomBar() => Container(
        padding: EdgeInsets.symmetric(
            horizontal: defaultOverride * 2.0,
            vertical: defaultOverride * 0.75),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.PRIMARY_MEDIUM, AppColor.PRIMARY_DARK])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _selectedPosition = 0;
                });
              },
              child: Image.asset(
                'assets/images/transparent_small_logo.png',
                color: Colors.white,
                height: defaultOverride * 5.0,
                width: defaultOverride * 5.0,
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: defaultOverride * 3.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedPosition = 1;
                  });
                }),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedPosition = 2;
                });
              },
              child: Image.asset(
                'assets/images/gp.png',
                color: Colors.white,
                height: defaultOverride * 3.0,
                width: defaultOverride * 3.0,
              ),
            ),
          ],
        ),
      );
}
