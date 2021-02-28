import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:geocoder/geocoder.dart';

class TestGeo extends StatefulWidget {
  @override
  _TestGeoState createState() => _TestGeoState();
}

class _TestGeoState extends State<TestGeo> {
  String address;

  void showadress() async {
    final query = address;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    print(
        'Address lat: ${addresses.first.coordinates.latitude},  long: ${addresses.first.coordinates.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) async {
                  address = value;
                },
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: AppColor.PRIMARY_DARK,
                style: GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                maxLines: 1,
              ),
              ElevatedButton(onPressed: showadress, child: Text("GEt LAT LONG"))
            ],
          ),
        ),
      ),
    );
  }
}
