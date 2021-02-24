import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saloonwala_consumer/view/pages/dialog/no_internet_dialog.dart';
import 'package:saloonwala_consumer/view/pages/salon_servicesUI.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class RandomTest extends StatefulWidget {
  @override
  _RandomTestState createState() => _RandomTestState();
}

class _RandomTestState extends State<RandomTest>
    with SingleTickerProviderStateMixin {
  double defaultOveride;
  TabController controller;
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOveride = defaultSize;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: defaultSize * 15.0,
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
            child: ListView.builder(
                itemCount: 20,
                itemBuilder: (BuildContext context, int position) {
                  return FavoriteSalonCard(
                    title: "Hair Salon",
                    distance: "1.0",
                    customfunction: () {
                      print("object");
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
