import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saloonwala_consumer/view/widget/custom_card.dart';

class RandomTest extends StatefulWidget {
  @override
  _RandomTestState createState() => _RandomTestState();
}

class _RandomTestState extends State<RandomTest> {
  double defaultOveride;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOveride = defaultSize;
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    pinned: true,
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
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColor.PRIMARY_LIGHT,
                                    AppColor.PRIMARY_MEDIUM
                                  ])),
                        ),
                      ],
                    )),
              ];
            },
            body: ListView.builder(
              // itemExtent: 80,
              itemBuilder: (BuildContext context, int index) {
                return SalonCard(
                  title: "he",
                  distance: "1",
                );
              },
              itemCount: 20,
            )));
  }

  Widget _title() => Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.asset(
                'assets/images/only_name_logo.png',
                height: defaultOveride * 3.2,
              ),
            ),
          ],
        ),
      );
}
