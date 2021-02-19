import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/custom_clipper.dart';

class ProfileInfoUI extends StatelessWidget {
  final String name, email, title, image;
  final bool showBackButton;

  const ProfileInfoUI(
      {Key key,
      this.name,
      this.email,
      this.title,
      this.image,
      this.showBackButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return SizedBox(
      height: defaultSize * 34,
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomClipperShape(),
            child: Container(
              child: Stack(
                children: [
                  if (showBackButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            margin: EdgeInsets.only(
                              top: defaultSize * 3.5,
                            ),
                            child: Icon(
                              Icons.chevron_left,
                              size: defaultSize * 4.5,
                              color: AppColor.LOGIN_BACKGROUND,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: defaultSize * 3.5,
                        ),
                        child: Text(title,
                            style: GoogleFonts.poppins(
                              color: AppColor.LOGIN_BACKGROUND,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                              fontSize: defaultSize * 3.5,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              height: defaultSize * 25,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_MEDIUM]),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: defaultSize), //10
                  height: defaultSize * 14, //140
                  width: defaultSize * 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.8, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image),
                    ),
                  ),
                ),
              ),
              Text(
                name,
                style: GoogleFonts.poppins(
                    fontSize: defaultSize * 2.2, color: AppColor.PRIMARY_DARK),
              ),
              SizedBox(height: defaultSize / 2),
              Text(
                email,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  color: AppColor.PRIMARY_LIGHT,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
