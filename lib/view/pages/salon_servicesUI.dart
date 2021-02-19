import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';

class SalonServicesUI extends StatefulWidget {
  final int salonId;

  const SalonServicesUI({Key key, this.salonId}) : super(key: key);
  @override
  _SalonServicesUIState createState() => _SalonServicesUIState();
}

class _SalonServicesUIState extends State<SalonServicesUI> {
  SaloonServices _services;
  List<Services> _selectedServiceList = [];
  double defaultOverride;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() async {
    final res = await LoadSalons.getService(widget.salonId);
    setState(() {
      _services = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return Scaffold(
      body: Column(
        children: [
          _services == null ? CircularProgressIndicator() : _getServiceWidget(),
          _selectedServiceList.length > 0
              ? Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: defaultSize * 10.0,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(defaultSize * 1.65),
                      child: Container(
                          // width: 50,
                          // height: 50,
                          decoration: BoxDecoration(
                              color: AppColor.PRIMARY_DARK,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultSize * 2.5))),
                          child: Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(left: defaultSize * 2.5),
                                child: Text(
                                    '${_selectedServiceList.length} Service Added',
                                    style: GoogleFonts.poppins(
                                        fontSize: defaultSize * 1.80,
                                        color: Colors.white)),
                              ),
                              Spacer(),
                              FlatButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                // color: Colors.transparent,
                                onPressed: () async {
                                  // print(_selectedServiceList[0]);
                                },
                                child: Text(" Book Now",
                                    style: GoogleFonts.poppins(
                                        fontSize: defaultSize * 2.0,
                                        color: AppColor.LOGIN_BACKGROUND)),
                              ),
                            ],
                          )),
                    ),
                  ))
              : Align(
                  alignment: FractionalOffset.bottomCenter, child: Text(" ")),
        ],
      ),
    );
  }

  Widget _getServiceWidget() => Expanded(
      child: ListView.builder(
          itemCount: _services.services.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: defaultOverride * 14.0,
              margin: EdgeInsets.symmetric(horizontal: defaultOverride * 1.25),
              child: Card(
                elevation: 5.0,
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: defaultOverride * 38.0),
                      child: Container(
                        margin: EdgeInsets.only(left: defaultOverride * 1.5),
                        padding: EdgeInsets.all(defaultOverride * 1.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _services.services[index].serviceName,
                              style: GoogleFonts.poppins(
                                  fontSize: defaultOverride * 2.354,
                                  color: AppColor.PRIMARY_MEDIUM,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: defaultOverride * 1.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: defaultOverride * 2.5,
                                  width: defaultOverride * 2.5,
                                  child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {},
                                      child: FaIcon(
                                        FontAwesomeIcons.male,
                                        size: defaultOverride * 2.0,
                                        color: AppColor.PRIMARY_MEDIUM,
                                      )),
                                ),
                                SizedBox(width: defaultOverride * 1.25),
                                Text(
                                  _services.services[index].maleRate.toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultOverride * 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.PRIMARY_MEDIUM),
                                ),
                                SizedBox(width: defaultOverride * 1.5),
                                Text(
                                  "|",
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultOverride * 2.5,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.PRIMARY_MEDIUM),
                                ),
                                // SizedBox(width: defaultOverride * 0.5),
                                SizedBox(
                                  height: defaultOverride * 2.5,
                                  width: defaultOverride * 2.5,
                                  child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {},
                                      child: FaIcon(
                                        FontAwesomeIcons.female,
                                        size: defaultOverride * 2.0,
                                        color: AppColor.PRIMARY_MEDIUM,
                                      )),
                                ),
                                SizedBox(width: defaultOverride * 1.25),
                                Text(
                                  _services.services[index].femaleRate
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultOverride * 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.PRIMARY_MEDIUM),
                                ),
                                Spacer(),
                                _selectedServiceList
                                        .contains(_services.services[index])
                                    ? FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            // sa = "BB";
                                            _selectedServiceList.remove(
                                                _services.services[index]);
                                          });
                                        },
                                        child: Text(
                                          " - Remove Service",
                                          style: GoogleFonts.poppins(
                                            fontSize: defaultOverride * 1.6265,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.PRIMARY_MEDIUM,
                                          ),
                                        ))
                                    : FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            // sa = "aa";
                                            _selectedServiceList
                                                .add(_services.services[index]);
                                          });
                                        },
                                        child: Text(
                                          " + Add Service",
                                          style: GoogleFonts.poppins(
                                            fontSize: defaultOverride * 1.6265,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.PRIMARY_MEDIUM,
                                          ),
                                        ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));
}
