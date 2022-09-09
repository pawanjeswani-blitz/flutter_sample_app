import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saloonwala_consumer/api/user_profile_service.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/bottom_navbar.dart';
import 'package:saloonwala_consumer/view/pages/dialog/select_gender_dialog.dart';
import 'package:saloonwala_consumer/view/pages/user_profile_ui.dart';
import 'package:saloonwala_consumer/view/widget/custom_clipper.dart';
import 'package:saloonwala_consumer/view/widget/profile_info_ui.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class EditProfile extends StatefulWidget {
  final UserProfileLogin userProfile;
  final bool refresh;
  const EditProfile({Key key, this.userProfile, this.refresh})
      : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool readOnly = true;
  bool _inProcess = false;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _fullNameFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey<FormState>();
  // final GlobalKey<FormState> _genderFormKey = GlobalKey<FormState>();
  String firstName,
      lastName,
      email,
      gender,
      name,
      number,
      selectedgender,
      fname,
      address;
  String fsname = "aa";
  double defaultOverride;
  CroppedFile selectedImage;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultOverride = defaultSize;
    return WillPopScope(
      onWillPop: () => _onwillPop(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _fullNameFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: defaultSize * 34,
                        child: Stack(
                          children: [
                            ClipPath(
                              clipper: CustomClipperShape(),
                              child: Container(
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: defaultSize * 3.5,
                                          ),
                                          child: Text("Edit Profile",
                                              style: GoogleFonts.poppins(
                                                color:
                                                    AppColor.LOGIN_BACKGROUND,
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
                                      colors: [
                                        AppColor.PRIMARY_LIGHT,
                                        AppColor.PRIMARY_MEDIUM
                                      ]),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: _getImageDisplayWidget(),
                                ),
                                Text(
                                  widget.userProfile.firstName,
                                  style: GoogleFonts.poppins(
                                      fontSize: defaultSize * 2.2,
                                      color: AppColor.PRIMARY_DARK),
                                ),
                                SizedBox(height: defaultSize / 2),
                                Text(
                                  ' ',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.PRIMARY_LIGHT,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ProfileInfoUI(
                      //   title: 'Edit Profile',
                      //   image: widget.userProfile.gender == "M"
                      //       ? 'assets/images/avatar.png'
                      //       : 'assets/images/favatar.png',
                      //   name: widget.userProfile.firstName,
                      //   email: ' ',
                      //   showBackButton: true,
                      //   customFunction: () async {
                      //     final file = await ImagePicker.pickImage(
                      //         source: ImageSource.gallery);
                      //     _selectedImage = file;
                      //     debugPrint('File is file ${file.path}');
                      //     setState(() {});
                      //   },
                      // ),
                      SizedBox(
                        height: defaultSize * 3.0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ).copyWith(
                          bottom: defaultSize * 2.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ),
                        child: TextFormField(
                          readOnly: readOnly,
                          // validator: _validatePhoneNumber,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          onChanged: (value) {
                            List<String> split = value.split(' ');
                            Map<int, String> values = {
                              for (int i = 0; i < split.length; i++) i: split[i]
                            };
                            final value1 = values[0];
                            final value2 = values[1];
                            firstName = value1;
                            lastName = value2;
                          },
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: widget.userProfile.firstName +
                                " " +
                                widget.userProfile.lastName,
                            hintStyle: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK),
                            suffixIcon: TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                                onPressed: () async {
                                  setState(() {
                                    readOnly = false;
                                  });
                                },
                                child: Text(
                                  'Edit Name',
                                  style: GoogleFonts.poppins(
                                      color: AppColor.PRIMARY_DARK,
                                      fontSize: defaultSize * 1.75,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ).copyWith(
                          bottom: defaultSize * 2.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ),
                        child: TextFormField(
                          readOnly: readOnly,
                          // validator: _validatePhoneNumber,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          onChanged: (value) => email = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: widget.userProfile.email,
                            hintStyle: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK),
                            suffixIcon: TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                                onPressed: () async {
                                  setState(() {
                                    readOnly = false;
                                  });
                                },
                                child: Text(
                                  'Edit Email',
                                  style: GoogleFonts.poppins(
                                      color: AppColor.PRIMARY_DARK,
                                      fontSize: defaultSize * 1.75,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ).copyWith(
                          bottom: defaultSize * 2.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ),
                        child: TextFormField(
                          readOnly: true,
                          // validator: _validatePhoneNumber,
                          cursorColor: AppColor.PRIMARY_DARK,

                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 1,
                          // onChanged: (value) => gender = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: widget.userProfile.gender == "M"
                                ? 'Male'
                                : 'Female',
                            suffixIcon: TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                                onPressed: () async {
                                  // _requestOTP();
                                  // setState(() {
                                  //   // readOnly = false;
                                  // });
                                  _onEditGender();
                                },
                                child: Text(
                                  'Edit Gender',
                                  style: GoogleFonts.poppins(
                                      color: AppColor.PRIMARY_DARK,
                                      fontSize: defaultSize * 1.75,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ).copyWith(
                          bottom: defaultSize * 2.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultSize * 1.0,
                        ),
                        child: TextFormField(
                          readOnly: readOnly,
                          // validator: _validatePhoneNumber,
                          cursorColor: AppColor.PRIMARY_DARK,
                          style:
                              GoogleFonts.poppins(color: AppColor.PRIMARY_DARK),
                          maxLines: 4,
                          onChanged: (value) => address = value,
                          decoration: _getTextFormFieldInputDecoration.copyWith(
                            hintText: widget.userProfile.address,
                            hintStyle: GoogleFonts.poppins(
                                color: AppColor.PRIMARY_DARK),
                            suffixIcon: TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.transparent),
                                onPressed: () async {
                                  setState(() {
                                    readOnly = false;
                                  });
                                },
                                child: Text(
                                  'Edit Address',
                                  style: GoogleFonts.poppins(
                                      color: AppColor.PRIMARY_DARK,
                                      fontSize: defaultSize * 1.75,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                readOnly = true;
                              });
                            },
                            child: GestureDetector(
                              onTap: () {
                                _showCancel();
                              },
                              child: RoundedButtonOutlineBorder(
                                buttontext: 'Cancel',
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_fullNameFormKey.currentState.validate()) {
                                await _onEditProfileClick();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BottomNavBar()));
                              } else {
                                showSnackBar("try agian");
                              }
                            },
                            child: RoundedButtonDarkSave(
                              buttontext: 'save',
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: defaultSize * 2.5,
                      )
                    ],
                  ),
                ),
              ),
            ),
            (_inProcess)
                ? Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'Selecting Image',
                      ),
                    ),
                  )
                : Center()
          ],
        ),
      ),
    );
  }

  Widget _showCancel() {
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: GoogleFonts.poppins(
          fontSize: defaultOverride * 1.39,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes",
        style: GoogleFonts.poppins(
          fontSize: defaultOverride * 1.39,
        ),
      ),
      onPressed: () async {
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BottomNavBar()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Are you sure you want to Cancel",
        style: GoogleFonts.poppins(
          fontSize: defaultOverride * 1.49,
          color: Colors.grey[500],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onEditGender() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SelectGenderDialog();
        }).then((val) {
      setState(() {
        gender = val;
      });
    });
  }

  Future<SuperResponse<bool>> _onEditProfileClick() async {
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response =
            await UserProfileService.updateUserProfileFromEditProfile(
          firstName == null ? widget.userProfile.firstName : firstName,
          lastName == null ? widget.userProfile.lastName : lastName,
          widget.userProfile.dob,
          widget.userProfile.cityName,
          widget.userProfile.stateName,
          gender,
          email == null ? widget.userProfile.email : email,
          address == null ? widget.userProfile.address : address,
        );
        print(response.data);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            //user is register
            print(response.data);
          } else
            showSnackBar("Something went wrong");
        } else
          showSnackBar(response.error);
      } catch (ex) {
        Navigator.of(context).pop();
        showSnackBar("Something went wrong.");
      }
    } else
      showSnackBar("No internet connected");
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone Number is required';
    } else if (value.length < 10) {
      return 'Please enter 10-digit Phone Number';
    }
    return null;
  }

  var _getTextFormFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintStyle: GoogleFonts.poppins(color: AppColor.PRIMARY_LIGHT),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: AppColor.PRIMARY_MEDIUM, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: AppColor.PRIMARY_MEDIUM, width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: AppColor.PRIMARY_MEDIUM, width: 2.0)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    errorStyle: GoogleFonts.poppins(
        color: AppColor.PRIMARY_DARK,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5),
    disabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.only(left: 15, bottom: 14, top: 14, right: 15),
    // hintText: hint,
  );
  Widget _bottomSheet() {
    _cropImage(XFile picked) async {
      CroppedFile cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        maxWidth: 700,
        maxHeight: 700,
      );
      if (cropped != null) {
        setState(() {
          selectedImage = cropped;
        });
      }
    }

    void takePhotoByCamera() async {
      this.setState(() {
        _inProcess = true;
      });
      XFile image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        _cropImage(image);
        this.setState(() {
          _inProcess = false;
        });
      } else {
        Navigator.pop(context);
        this.setState(() {
          _inProcess = false;
        });
      }
    }

    void takePhotoByGallery() async {
      this.setState(() {
        _inProcess = true;
      });
      XFile image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _cropImage(image);
        this.setState(() {
          _inProcess = false;
        });
      } else {
        Navigator.pop(context);
        this.setState(() {
          _inProcess = false;
        });
      }
    }

    return Container(
      height: defaultOverride * 25.0,
      width: double.infinity,
      margin: EdgeInsets.only(top: defaultOverride * 2.5),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: GoogleFonts.poppins(fontSize: defaultOverride * 2.2),
          ),
          SizedBox(
            height: defaultOverride * 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(
                  Icons.camera,
                  color: AppColor.PRIMARY_MEDIUM,
                  size: defaultOverride * 3.0,
                ),
                onPressed: takePhotoByCamera,
                label: Text(
                  "Camera",
                  style: GoogleFonts.poppins(
                      color: AppColor.PRIMARY_MEDIUM,
                      fontSize: defaultOverride * 2.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: defaultOverride * 2.0),
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.image,
                  color: AppColor.PRIMARY_MEDIUM,
                  size: defaultOverride * 3.0,
                ),
                onPressed: takePhotoByGallery,
                label: Text(
                  "Gallery",
                  style: GoogleFonts.poppins(
                      color: AppColor.PRIMARY_MEDIUM,
                      fontSize: defaultOverride * 2.0),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: defaultOverride * 4.0,
                left: defaultOverride * 2.8,
                right: defaultOverride * 2.8),
            child: GestureDetector(
                onTap: () {
                  uploadProfile();
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: defaultOverride * 1.35),
                  margin:
                      EdgeInsets.symmetric(horizontal: defaultOverride * 1.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: defaultOverride * 1.0,
                      ),
                      Text("Upload Profile Pic",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: defaultOverride * 1.55,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.PRIMARY_DARK),
                )),
          ),
        ],
      ),
    );
  }

  void uploadProfile() async {
    var docPath1 = "";

    if (selectedImage != null) {
      docPath1 = selectedImage.path;
    }

    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      final response = await UserProfileService.uploadProfileImage(docPath1);
      //close the progress dialog
      Navigator.of(context).pop();
      if (response.data != null) {
        print(response.data);
        showSnackBar("Profile pic uploaded Successfully");
      } else
        showSnackBar("Please try again");
    } else
      showSnackBar("No internet connected");
  }

  Widget _getImageDisplayWidget() {
    return Stack(
      children: [
        if (selectedImage == null && widget.userProfile.profileUrl != null)
          Container(
            margin: EdgeInsets.only(bottom: defaultOverride), //10
            height: defaultOverride * 14, //140
            width: defaultOverride * 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: defaultOverride * 0.8, //8
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.userProfile.profileUrl),
              ),
            ),
          ),

        if (selectedImage != null)
          Container(
            margin: EdgeInsets.only(bottom: defaultOverride), //10
            height: defaultOverride * 14, //140
            width: defaultOverride * 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: defaultOverride * 0.8, //8
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(selectedImage.path)),
              ),
            ),
          ),

        //file and url is null
        if (selectedImage == null && widget.userProfile.profileUrl == null)
          Container(
            margin: EdgeInsets.only(bottom: defaultOverride), //10
            height: defaultOverride * 14, //140
            width: defaultOverride * 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: defaultOverride * 0.8, //8
              ),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.userProfile.gender == "M"
                      ? AssetImage('assets/images/avatar.png')
                      : AssetImage(
                          'assets/images/favatar.png',
                        )),
            ),
          ),

        Positioned(
          bottom: defaultOverride * 1.5,
          right: defaultOverride * 1.5,
          child: InkWell(
            child: Container(
              height: defaultOverride * 3.2,
              width: defaultOverride * 3.2,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                heightFactor: defaultOverride * 2.5,
                widthFactor: defaultOverride * 2.5,
                child: Icon(Icons.edit,
                    color: AppColor.PRIMARY_MEDIUM,
                    size: defaultOverride * 2.2),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => _bottomSheet()));
            },
          ),
        ),
      ],
    );
  }

  _onwillPop() {
    Navigator.of(context).pop();
  }
}
