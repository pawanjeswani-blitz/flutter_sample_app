import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/fetch_slots.dart';
import 'package:saloonwala_consumer/app/app_color.dart';
import 'package:saloonwala_consumer/app/session_manager.dart';
import 'package:saloonwala_consumer/app/size_config.dart';
import 'package:saloonwala_consumer/model/available_slot_response.dart';
import 'package:saloonwala_consumer/model/book_slot.dart';
import 'package:saloonwala_consumer/model/employee.dart';
import 'package:saloonwala_consumer/model/salon_services.dart';
import 'package:saloonwala_consumer/model/slots.dart';
import 'package:saloonwala_consumer/model/super_response.dart';
import 'package:saloonwala_consumer/model/user_profile.dart';
import 'package:saloonwala_consumer/model/user_profile_after_login.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:saloonwala_consumer/utils/internet_util.dart';
import 'package:saloonwala_consumer/view/pages/booking_details.dart';
import 'package:saloonwala_consumer/view/widget/progress_dialog.dart';
import 'package:saloonwala_consumer/view/widget/rounded_button.dart';

class SalonSlotsUI extends StatefulWidget {
  final List<Services> selectedServiceList;
  final int salonId;
  final String salonName;
  final UserProfileLogin userProfile;
  const SalonSlotsUI(
      {Key key,
      this.selectedServiceList,
      this.salonId,
      this.salonName,
      this.userProfile})
      : super(key: key);

  @override
  _SalonSlotsUIState createState() => _SalonSlotsUIState();
}

class _SalonSlotsUIState extends State<SalonSlotsUI> {
  DateTime _selectedDateTime;
  AvailableSlotsResponse _availableSlotsResponse;
  List<Slots> _selectedTimeSlot = [];
  Employee _selectedEmployee;
  DateTime _currentDate = DateTime.now(); // DateTime.now for current Date
  DateFormat formatSelectedDate = DateFormat(
      'dd/MM/yyyy'); // Formatting the Date in the format 'day-month-year'
  String currentDateFormat, error;
  var dateString = "";
  double defaultSizeOveride;
  List<int> service = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _selectedDateTime = DateTime.now();
    _loadAvaiableTimeSlotFromApi(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double defaultSize = SizeConfig.defaultSize;
    defaultSizeOveride = defaultSize;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: new Text(
          '${widget.userProfile.firstName} ,'
          '\nPlease Select date and time',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400, fontSize: defaultSize * 1.5),
        ),
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            widget.selectedServiceList.clear();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(172, 125, 83, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: defaultSize * 34.0,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(172, 125, 83, 1),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(45.0),
                      bottomRight: Radius.circular(45.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultSize * 2.0,
                      vertical: defaultSize * 1.5),
                  child: CalendarCarousel<Event>(
                    onDayPressed: (DateTime date, List<Event> events) {
                      this.setState(() {
                        _currentDate = date;
                        currentDateFormat =
                            formatSelectedDate.format(_currentDate);
                        _selectedDateTime = _currentDate;
                      });
                      print(currentDateFormat);
                      if (_selectedDateTime != null) {
                        _availableSlotsResponse = null;
                        _selectedEmployee = null;
                        _selectedTimeSlot.clear();
                        _loadAvaiableTimeSlotFromApi(_selectedDateTime);
                        setState(() {});
                      }
                    },
                    todayButtonColor: Colors.transparent,
                    // customGridViewPhysics: NeverScrollableScrollPhysics(),
                    pageScrollPhysics: BouncingScrollPhysics(),
                    customGridViewPhysics: BouncingScrollPhysics(),
                    weekendTextStyle: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                    headerTextStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: defaultSize * 2.154,
                    ),
                    iconColor: Colors.white,
                    childAspectRatio: 1.525685845,
                    weekdayTextStyle: GoogleFonts.poppins(
                      color: Colors.white,
                    ),
                    selectedDayButtonColor: Color.fromRGBO(204, 168, 134, 1),
                    selectedDayTextStyle:
                        GoogleFonts.poppins(color: Colors.black),
                    daysTextStyle: GoogleFonts.poppins(color: Colors.white),
                    minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
                    maxSelectedDate: DateTime.now().add(Duration(days: 30)),
                    selectedDateTime: _currentDate,
                  ),
                ),
              ),
              SizedBox(
                height: defaultSize * 2.0,
              ),
              Padding(
                padding: EdgeInsets.all(defaultSize * 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Text(
                          "AVAILABLE SLOTS",
                          style: GoogleFonts.poppins(
                            color: Color.fromRGBO(172, 125, 83, 1),
                            fontSize: defaultSize * 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: defaultSize * 1.85),
                        Expanded(
                          child: Divider(
                            color: Color.fromRGBO(216, 206, 197, 0.32),
                            thickness: defaultSize * 1.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: defaultSize * 1.0,
                    ),
                    Text(
                      "you can select multilple time slots",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(172, 125, 83, 1),
                        fontSize: defaultSize * 1.5,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              //show the avaiable time slot if the data is present else show the laoder
              _availableSlotsResponse == null
                  ? CircularProgressIndicator()
                  : _getTimeSelectListViewWidget(),

              //show employee if the slot is selected
              //NOTE: this kidnd of condition writing is only supported in dart 2.2.2 and above
              Padding(
                padding: EdgeInsets.all(defaultSize * 2.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "SPECIALIST",
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(172, 125, 83, 1),
                        fontSize: defaultSize * 2.32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: defaultSize * 1.0),
                    Expanded(
                      child: Divider(
                        color: Color.fromRGBO(216, 206, 197, 0.32),
                        thickness: defaultSize * 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedTimeSlot.isNotEmpty) _getEmployeeListWidget(),

              SizedBox(
                height: defaultSize * 0.0,
              ),

              //if staff is selected then show the book appointment button
              if (_selectedEmployee != null)
                GestureDetector(
                  onTap: () {
                    onBookAppointmentButtonClick();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: defaultSize * 1.8),
                    child: RoundedButtonSlot(
                      buttontext: 'Book Appointment',
                    ),
                  ),
                ),
              SizedBox(
                height: defaultSize * 2.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEmployeeListWidget() {
    final List<Employee> emmployeeList = _availableSlotsResponse
        .slotMap[_selectedTimeSlot.first.startTime.toString()];

    return Container(
      height: defaultSizeOveride * 15.0,
      child: emmployeeList.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emmployeeList.length,
              itemBuilder: (BuildContext context, int position) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmployee = emmployeeList[position];
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        height: defaultSizeOveride * 5.25,
                        width: defaultSizeOveride * 5.25,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(172, 125, 83, 1)),
                          color: _selectedEmployee?.id ==
                                  emmployeeList[position].id
                              ? Color.fromRGBO(172, 125, 83, 1)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Stack(
                            children: [
                              if (emmployeeList[position].profileUrl != null)
                                Image.network(
                                  emmployeeList[position].profileUrl,
                                  width: defaultSizeOveride * 10,
                                  height: defaultSizeOveride * 10,
                                  fit: BoxFit.cover,
                                ),
                              if (emmployeeList[position].profileUrl == null ||
                                  emmployeeList[position].profileUrl == " ")
                                emmployeeList[position].gender == "M"
                                    ? Image.asset(
                                        'assets/images/avatar.png',
                                        width: defaultSizeOveride * 10,
                                        height: defaultSizeOveride * 10,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/favatar.png',
                                        width: defaultSizeOveride * 10,
                                        height: defaultSizeOveride * 10,
                                        fit: BoxFit.cover,
                                      ),
                            ],
                          ),
                        ),
                        // child: Center(
                        //   child: Text(
                        //     emmployeeList[position].firstName[0],
                        //     style: GoogleFonts.poppins(
                        //       color: _selectedEmployee?.id ==
                        //               emmployeeList[position].id
                        //           ? Colors.white
                        //           : Colors.black,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: defaultSizeOveride * 1.85,
                        //     ),
                        //   ),
                        // ),
                      ),
                      SizedBox(height: defaultSizeOveride * 1.5),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultSizeOveride * 2.0,
                              vertical: 0.0),
                          child: Text(
                            emmployeeList[position].firstName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: defaultSizeOveride * 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: defaultSizeOveride * 0.8),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultSizeOveride * 2.0,
                              vertical: 0.0),
                          child: Text(
                            emmployeeList[position].description == null
                                ? ""
                                : emmployeeList[position].description,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: defaultSizeOveride * 1.35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
          : Container(
              margin: EdgeInsets.only(top: defaultSizeOveride * 1.0),
              child: Text("No Specialist available currently",
                  style: GoogleFonts.poppins(
                      fontSize: defaultSizeOveride * 1.75,
                      color: AppColor.PRIMARY_MEDIUM,
                      fontWeight: FontWeight.w500)),
            ),
    );
  }

  Widget _getTimeSelectListViewWidget() => Container(
        margin: EdgeInsets.only(
          left: defaultSizeOveride * 2.25,
          right: defaultSizeOveride * 2.25,
        ),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.5,
                mainAxisSpacing: 8.0,
                childAspectRatio: defaultSizeOveride * 0.27),
            shrinkWrap: true,
            // scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availableSlotsResponse.slots.length,
            itemBuilder: (BuildContext context, int position) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEmployee = null;
                    if (_selectedTimeSlot
                        .contains(_availableSlotsResponse.slots[position])) {
                      //Remove Time Slots From Lists
                      if (_selectedTimeSlot.length > 1 &&
                          _availableSlotsResponse.slots[position].startTime >
                              _selectedTimeSlot.last.startTime) {
                        showSnackBar("Cannot remove slot");
                      } else {
                        _selectedTimeSlot
                            .remove(_availableSlotsResponse.slots[position]);
                      }
                    } else {
                      //add time slots to list
                      //to do check sequencing
                      if (_selectedTimeSlot.isEmpty) {
                        if (_availableSlotsResponse.slots[position].startTime >
                            DateTime.now().millisecondsSinceEpoch) {
                          _selectedTimeSlot
                              .add(_availableSlotsResponse.slots[position]);
                        } else {
                          showSnackBar("Time Slot Cannot be selected");
                        }
                      } else {
                        if ((_availableSlotsResponse.slots[position].startTime >
                                    _selectedTimeSlot.last.startTime ||
                                _availableSlotsResponse
                                        .slots[position].endTime <
                                    _selectedTimeSlot.first.endTime) &&
                            _availableSlotsResponse.slots[position].startTime !=
                                _selectedTimeSlot.last.endTime) {
                          _selectedTimeSlot.clear();
                          _selectedTimeSlot
                              .add(_availableSlotsResponse.slots[position]);
                        } else if (_selectedTimeSlot.last.endTime ==
                            _availableSlotsResponse.slots[position].startTime) {
                          _selectedTimeSlot
                              .add(_availableSlotsResponse.slots[position]);
                        } else {
                          showSnackBar(
                              "Please Select slots in sequence manner");
                        }
                      }
                    }
                    // _selectedTimeSlot = _availableSlotsResponse.slots[position];
                  });
                },
                child: Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(172, 125, 83, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: _availableSlotsResponse.slots[position].startTime <
                            DateTime.now().millisecondsSinceEpoch
                        ? Colors.grey[200]
                        : _selectedTimeSlot.contains(
                                _availableSlotsResponse.slots[position])
                            ? Color.fromRGBO(172, 125, 83, 1)
                            : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      "${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(_availableSlotsResponse.slots[position].startTime))}",
                      style: GoogleFonts.poppins(
                          color: _availableSlotsResponse
                                      .slots[position].startTime <
                                  DateTime.now().millisecondsSinceEpoch
                              ? Colors.grey[400]
                              : _selectedTimeSlot.contains(
                                      _availableSlotsResponse.slots[position])
                                  ? Colors.white
                                  : Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              );
            }),
      );

  void _loadAvaiableTimeSlotFromApi(DateTime dateTime) async {
    final res = await FetchSlots.getTitleSlot(dateTime, widget.salonId);
    setState(() {
      _availableSlotsResponse = res.data;
    });
  }

  void onBookAppointmentButtonClick() async {
    _onSlotBook();
  }

  Future<SuperResponse<BookSlot>> _onSlotBook() async {
    for (int index = 0; index < widget.selectedServiceList.length; index++) {
      service.add(widget.selectedServiceList[index].id);
      print(service);
    }
    final isInternetConnected = await InternetUtil.isInternetConnected();
    if (isInternetConnected) {
      ProgressDialog.showProgressDialog(context);
      try {
        final response = await FetchSlots.bookSlot(
            DateUtil.getDisplayFormatDate(_selectedDateTime),
            _selectedEmployee.id,
            _selectedTimeSlot.last.endTime,
            widget.salonId,
            _selectedTimeSlot.first.startTime,
            service);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            // final userProfile = await AppSessionManager.getUserProfile();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingDetails(
                      salonId: widget.salonId,
                      salonName: widget.salonName,
                      selectedServiceList: widget.selectedServiceList,
                      employeeName:
                          "${_selectedEmployee.firstName.toString()} ${_selectedEmployee.lastName.toString()}",
                      dateString:
                          " ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(_selectedTimeSlot.first.startTime))} - ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(_selectedTimeSlot.last.endTime))}",
                      dayMonth: DateUtil.getDisplayFormatDay(_selectedDateTime),
                      userProfile: widget.userProfile,
                    )));
            print(response.data);
          } else
            showSnackBar("Slot not available please try another one");
        } else
          showSnackBar(response.error);
      } catch (ex) {
        Navigator.of(context).pop(ProgressDialog.showProgressDialog(context));
        showSnackBar(
            "This Slot is not available , kindly choose another slot.");
      }
    } else
      showSnackBar("No internet connected");
  }

  void showSnackBar(String errorText) {
    final snackBar = SnackBar(content: Text(errorText));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
