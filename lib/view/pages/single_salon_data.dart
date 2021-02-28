import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/load_salons.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/salon_data.dart';

class SingleStoreData extends StatefulWidget {
  final SalonData salonInfo;

  const SingleStoreData({Key key, this.salonInfo}) : super(key: key);
  @override
  _SingleStoreDataState createState() => _SingleStoreDataState();
}

class _SingleStoreDataState extends State<SingleStoreData> {
  SalonData _salonData;
  @override
  void initState() {
    super.initState();
    // controller = TabController(length: 2, vsync: this);
    _loadServices();
  }

  void _loadServices() async {
    final res = await LoadSalons.getSingleStore(widget.salonInfo.id);
    setState(() {
      _salonData = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: defaultSize * 2.5,
          top: defaultSize * 2.0,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: defaultSize * 2.5,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.phone_iphone,
                    color: AppColor.PRIMARY_MEDIUM,
                    size: defaultSize * 3.0,
                  ),
                  Text(
                    _salonData.phoneNumber.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: defaultSize * 2.0,
                      color: AppColor.PRIMARY_MEDIUM,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: AppColor.PRIMARY_MEDIUM,
                  size: defaultSize * 3.0,
                ),
                Text(
                  _salonData.address.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: defaultSize * 2.0,
                    color: AppColor.PRIMARY_MEDIUM,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
