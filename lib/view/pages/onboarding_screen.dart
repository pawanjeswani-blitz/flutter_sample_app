import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/size_config.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4; // No of Screens
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double defaultOverride;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    // Scaffold creates a new annotated region to insert
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle
            .light, // Specifies a preference for the style of the safe area
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // Mandatory for creating a gradient
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColor.PRIMARY_LIGHT, AppColor.PRIMARY_MEDIUM],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: defaultSize * 4.2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _currentPage == _numPages - 1
                        ? Container()
                        : Container(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                  3,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                ); // skip button event this navigates to the last page
                              },
                              child: Text(
                                'Skip',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: defaultSize * 2.2,
                                ),
                              ),
                            ),
                          ),
                    Container(
                      height: defaultSize * 60.0,
                      child: PageView(
                        // Creates a scrollable list that works page by page from an explicit [List] of widgets.
                        physics:
                            ClampingScrollPhysics(), // Creates scroll physics that prevent the scroll offset from exceeding the bounds of the content
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          }); // page state
                        },
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(
                              defaultSize * 4.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      //Creates an object that fetches an image from an asset bundle FOR LOCAL IMAGES
                                      'assets/images/onboarding-1.png',
                                    ),
                                    height: defaultSize * 30.0,
                                    width: defaultSize * 50.0,
                                  ),
                                ),
                                SizedBox(
                                  height: defaultSize * 3.0,
                                ), // Creates a fixed size box
                                Text(
                                  'Book Appointments from a \nWIDE RANGE of Salons!',
                                  style: GoogleFonts.poppins(
                                    fontSize: defaultSize * 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              defaultSize * 4.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/onboarding-2.png',
                                    ),
                                    height: defaultSize * 30.0,
                                    width: defaultSize * 50.0,
                                  ),
                                ),
                                SizedBox(
                                  height: defaultSize * 3.0,
                                ),
                                Text(
                                  'Book Appointment as \nINDIVIDUAL or PACKAGE service!',
                                  style: GoogleFonts.poppins(
                                    fontSize: defaultSize * 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              defaultSize * 4.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/onboarding-3.png',
                                    ),
                                    height: defaultSize * 30.0,
                                    width: defaultSize * 50.0,
                                  ),
                                ),
                                SizedBox(
                                  height: defaultSize * 3.0,
                                ),
                                Text(
                                  'Book Appointments \nthe EASY WAY now!',
                                  style: GoogleFonts.poppins(
                                    fontSize: defaultSize * 2.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: defaultSize * 4.0,
                              right: defaultSize * 4.0,
                              top: defaultSize * 6.5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/loc-pin.png',
                                    ),
                                    height: defaultSize * 30.0,
                                    width: defaultSize * 50.0,
                                  ),
                                ),
                                SizedBox(
                                  height: defaultSize * 3.0,
                                ),
                                Center(
                                  child: Text(
                                    'Hi, nice to meet you!',
                                    style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 2.3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Set your location to start exploring\nsalons near you ',
                                    style: GoogleFonts.poppins(
                                        fontSize: defaultSize * 1.75,
                                        color: Colors.grey[100],
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                    _currentPage != _numPages - 1
                        ? Expanded(
                            //Creates a widget that expands a child of a [Row], [Column], or [Flex] so that the child fills the available space along the flex widget's main axis.
                            child: Align(
                              alignment: FractionalOffset.bottomRight,
                              child: FlatButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Next',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: defaultSize * 2.2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: defaultSize * 1.0,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: defaultSize * 3.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _currentPage ==
              _numPages -
                  1 //A bottom sheet remains visible even when the user interacts with other parts of the app.
          ? Container(
              height: defaultSize * 8.1,
              width: double.infinity,
              color: AppColor.PRIMARY_DARK,
              child: GestureDetector(
                onTap: () async {
                  // LocationPermission permission =
                  //     await Geolocator.requestPermission();
                  // await Geolocator.openLocationSettings();
                  // await Geolocator.openAppSettings();
                  // LocationPermission permission =
                  //     await Geolocator.checkPermission();
                  // print(permission);
                  // if(permission == LocationPermission.whileInUse){

                  // }
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (r) => false);
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: defaultSize * 2.1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: defaultOverride * 0.8, // Slider Indicator height
      width: isActive
          ? defaultOverride * 2.4
          : defaultOverride * 1.7, // Slider Indicator width
      decoration: BoxDecoration(
        color: isActive ? Colors.white : AppColor.PRIMARY_MEDIUM,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
