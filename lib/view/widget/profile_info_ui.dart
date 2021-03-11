import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/view/widget/custom_clipper.dart';

class ProfileInfoUI extends StatelessWidget {
  final String name, email, title, image;
  final bool showBackButton;
  final Function customFunction;

  const ProfileInfoUI(
      {Key key,
      this.name,
      this.email,
      this.title,
      this.image,
      this.showBackButton = false,
      this.customFunction})
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
                child: GestureDetector(
                  onTap: () => customFunction(),
                  child: Container(
                    height: defaultSize * 14,
                    width: defaultSize * 14,
                    margin: EdgeInsets.only(top: defaultSize * 3),
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: defaultSize * 14,
                          backgroundImage: NetworkImage(image),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: defaultSize * 3.0,
                            width: defaultSize * 3.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                              heightFactor: defaultSize * 2.5,
                              widthFactor: defaultSize * 2.5,
                              child: Icon(Icons.edit,
                                  color: AppColor.PRIMARY_MEDIUM,
                                  size: defaultSize * 2.2),
                            ),
                          ),
                        ),
                      ],
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
