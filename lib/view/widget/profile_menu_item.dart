import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData iconSrc;
  final Function press;
  final bool hasNavigation;

  const ProfileMenuItem(
      {Key key,
      this.title,
      this.iconSrc,
      this.press,
      this.hasNavigation = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return SingleChildScrollView(
      child: Container(
        height: defaultSize * 5.5,
        margin: EdgeInsets.symmetric(
          horizontal: defaultSize * 3.0,
        ).copyWith(
          bottom: defaultSize * 2.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: defaultSize * 2.0,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultSize * 1.5),
            color: Color.fromRGBO(216, 206, 197, 0.3)),
        child: InkWell(
          onTap: press,
          child: SafeArea(
            child: Row(
              children: [
                Icon(
                  iconSrc,
                  size: defaultSize * 2.2,
                  color: AppColor.PRIMARY_DARK,
                ),
                SizedBox(width: defaultSize * 2),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: defaultSize * 1.8,
                    color: AppColor.PRIMARY_DARK,
                  ),
                ),
                Spacer(),
                if (this.hasNavigation)
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: defaultSize * 2.2,
                    color: AppColor.PRIMARY_DARK,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
