import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloonwala_consumer/api/fetch_slots.dart';
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
import 'package:saloonwala_consumer/view/widget/multi_select_chip.dart';

class RandomTestUI extends StatefulWidget {
  final List<Services> selectedServiceList;
  final int salonId;
  final String salonName;
  final UserProfileLogin userProfile;
  const RandomTestUI(
      {Key key,
      this.selectedServiceList,
      this.salonId,
      this.salonName,
      this.userProfile})
      : super(key: key);

  @override
  _RandomTestUIState createState() => _RandomTestUIState();
}

class _RandomTestUIState extends State<RandomTestUI> {
  DateTime _selectedDateTime;
  AvailableSlotsResponse _availableSlotsResponse;
  Slots _selectedTimeSlot;
  Employee _selectedEmployee;
  DateTime _currentDate = DateTime.now(); // DateTime.now for current Date
  DateFormat formatSelectedDate = DateFormat(
      'dd/MM/yyyy'); // Formatting the Date in the format 'day-month-year'
  String currentDateFormat, error;
  var dateString = "";
  double defaultSizeOveride;
  List<int> service = [];
  List<Slots> seletcedSlots = [];
  List<Slots> hi = [];
  bool _checked = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
          '${widget.userProfile.firstName},'
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
                        _selectedTimeSlot = null;
                        _selectedEmployee = null;
                        _loadAvaiableTimeSlotFromApi(_selectedDateTime);
                        setState(() {});
                      }
                    },
                    todayButtonColor: Colors.transparent,
                    // customGridViewPhysics: NeverScrollableScrollPhysics(),
                    pageScrollPhysics: NeverScrollableScrollPhysics(),
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
                child: Row(
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
              ),
              //show the avaiable time slot if the data is present else show the laoder
              _availableSlotsResponse == null
                  ? CircularProgressIndicator()
                  : _getTimeSelectListViewWidget(),

              // SizedBox(
              //   height: width * 0.045,
              // ),
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
              if (_selectedTimeSlot != null) _getEmployeeListWidget(),

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
    final List<Employee> emmployeeList =
        _availableSlotsResponse.slotMap[_selectedTimeSlot.startTime.toString()];

    return Container(
      height: defaultSizeOveride * 15.0,
      child: ListView.builder(
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
                      border:
                          Border.all(color: Color.fromRGBO(172, 125, 83, 1)),
                      color: _selectedEmployee?.id == emmployeeList[position].id
                          ? Color.fromRGBO(172, 125, 83, 1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        emmployeeList[position].firstName[0],
                        style: GoogleFonts.poppins(
                          color: _selectedEmployee?.id ==
                                  emmployeeList[position].id
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: defaultSizeOveride * 1.85,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: defaultSizeOveride * 1.5),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultSizeOveride * 2.0, vertical: 0.0),
                      child: Text(
                        emmployeeList[position].firstName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: defaultSizeOveride * 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  // Widget _getTimeSelectListViewWidget() => Container(
  //       height: defaultSizeOveride * 25.0,
  //       margin: EdgeInsets.symmetric(horizontal: defaultSizeOveride * 2.0),
  //       child: GridView.builder(
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 4,
  //               crossAxisSpacing: 4.0,
  //               mainAxisSpacing: 8.0,
  //               childAspectRatio: 2.8),
  //           // scrollDirection: Axis.horizontal,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: _availableSlotsResponse.slots.length,
  //           itemBuilder: (BuildContext context, int position) {
  //             DateTime date = new DateTime.fromMillisecondsSinceEpoch(
  //                 _availableSlotsResponse.slots[position].startTime);
  //             var formatting = new DateFormat("hh:mm a");
  //             dateString = formatting.format(date);
  //             return GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   _selectedEmployee = null;
  //                   _selectedTimeSlot = _availableSlotsResponse.slots[position];
  //                 });
  //               },
  //               child: Container(
  //                 // margin: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 decoration: BoxDecoration(
  //                   border: Border.all(
  //                     color: Color.fromRGBO(172, 125, 83, 1),
  //                   ),
  //                   borderRadius: BorderRadius.all(Radius.circular(20)),
  //                   color: _selectedTimeSlot?.startTime ==
  //                           _availableSlotsResponse.slots[position].startTime
  //                       ? Color.fromRGBO(172, 125, 83, 1)
  //                       : Colors.transparent,
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     dateString.toString(),
  //                     style: GoogleFonts.poppins(
  //                       color: _selectedTimeSlot?.startTime ==
  //                               _availableSlotsResponse
  //                                   .slots[position].startTime
  //                           ? Colors.white
  //                           : Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //     );
  void _loadAvaiableTimeSlotFromApi(DateTime dateTime) async {
    final res = await FetchSlots.getTitleSlot(dateTime, widget.salonId);
    setState(() {
      _availableSlotsResponse = res.data;
    });
  }

  // List<Slots> _selectedValues = [];
  // List<Slots> onItemCheckedChange(
  //     List<Slots> selectedValues, Slots itemValue, bool checked) {
  //   if (checked) {
  //     selectedValues.add(itemValue);
  //   } else {
  //     selectedValues.remove(itemValue);
  //   }
  //   return selectedValues;
  // }

  // void Function(List) onSelectionChanged;
  // Widget _getTimeSelectListViewWidget() => SizedBox(
  //       height: defaultSizeOveride * 25.0,
  //       child: ListView.builder(
  //         itemCount: _availableSlotsResponse.slots.length,
  //         itemBuilder: (context, index) {
  //           return CheckboxListTile(
  //             value: _selectedValues.contains(_availableSlotsResponse.slots),
  //             title: Text(
  //               DateUtil.getDisplayFormatHour(
  //                   DateTime.fromMillisecondsSinceEpoch(
  //                       _availableSlotsResponse.slots[index].startTime)),
  //             ),
  //             activeColor: Colors.pink,
  //             onChanged: (checked) {
  //               print(checked);
  //               setState(() {
  //                 _selectedValues = onItemCheckedChange(
  //                     _selectedValues, _selectedTimeSlot, checked);
  //               });
  //             },
  //           );
  //         },
  //       ),
  //     );
  dynamic getdata(Slots value) {
    List<String> hed = [];
    for (int i = 0; i < _availableSlotsResponse.slots.length; i++) {
      hed.add(hi[i].startTime.toString());
    }
    return hed;
  }

  List<String> hed = [];
  Widget _getTimeSelectListViewWidget() => SizedBox(
        height: defaultSizeOveride * 25.0,
        child: MultiSelectDialog(
          items: _availableSlotsResponse.slots
              .map(
                (slot) => MultiSelectItem<Slots>(slot,
                    " ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(slot.startTime))} - ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(slot.endTime))}"),
              )
              .toList(),
          itemsTextStyle:
              GoogleFonts.poppins(fontSize: defaultSizeOveride * 1.75),
          selectedItemsTextStyle:
              GoogleFonts.poppins(fontSize: defaultSizeOveride * 1.5),
          // listType: List<Slots>,
          unselectedColor: Color.fromRGBO(172, 125, 83, 1),
          selectedColor: Color.fromRGBO(172, 125, 83, 1),
          initialValue: [],
          // listType: MultiSelectListType.CHIP,
          onSelectionChanged: (_selectedValues) {
            setState(() {
              _selectedEmployee = null;
              seletcedSlots = _selectedValues.cast<Slots>();
            });
            for (int i = 0; i < seletcedSlots.length; i++) {
              setState(() {
                _selectedTimeSlot = seletcedSlots[i];
              });
              print(
                  "${seletcedSlots[i].startTime} - ${seletcedSlots[i].endTime}");
            }
          },
        ),
      );

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
            seletcedSlots.last.endTime,
            widget.salonId,
            seletcedSlots.first.startTime,
            service);
        //close the progress dialog
        Navigator.of(context).pop();
        if (response.error == null) {
          //check the user is already register or not
          if (response.data == null) {
            final userProfile = await AppSessionManager.getUserProfile();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookingDetails(
                      salonId: widget.salonId,
                      salonName: widget.salonName,
                      selectedServiceList: widget.selectedServiceList,
                      employeeName: _selectedEmployee.firstName.toString(),
                      dateString:
                          " ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(seletcedSlots.first.startTime))} - ${DateUtil.getDisplayFormatHour(DateTime.fromMillisecondsSinceEpoch(seletcedSlots.last.endTime))}",
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
