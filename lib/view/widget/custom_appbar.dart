import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  const CustomAppBar({Key key, this.title, this.showBackButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.1,
      width: double.infinity,
      child: Row(
        children: [
          if (showBackButton)
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.only(left: 12, top: 20),
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.chevron_left,
                  color: AppColor.LOGIN_BACKGROUND,
                  size: width * 0.070,
                ),
              ),
            ),
          Expanded(
              child: Center(
            child: Text(title,
                style: GoogleFonts.poppins(
                    color: AppColor.LOGIN_BACKGROUND,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ))
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.0, color: AppColor.PRIMARY_MEDIUM),
        ),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_MEDIUM]),
      ),
    );
  }
}
