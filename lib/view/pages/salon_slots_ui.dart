import 'package:flutter/material.dart';
import 'package:saloonwala_consumer/api/fetch_slots.dart';
import 'package:saloonwala_consumer/model/available_slot_response.dart';
import 'package:saloonwala_consumer/model/employee.dart';
import 'package:saloonwala_consumer/model/slots.dart';
import 'package:saloonwala_consumer/utils/date_util.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;

class SalonSlotsUI extends StatefulWidget {
  @override
  _SalonSlotsUIState createState() => _SalonSlotsUIState();
}

class _SalonSlotsUIState extends State<SalonSlotsUI> {
  DateTime _selectedDateTime;
  AvailableSlotsResponse _availableSlotsResponse;
  Slots _selectedTimeSlot;
  Employee _selectedEmployee;
  DateTime _currentDate = DateTime.now(); // DateTime.now for current Date
  DateFormat formatSelectedDate = DateFormat(
      'dd/MM/yyyy'); // Formatting the Date in the format 'day-month-year'
  String currentDateFormat;
  var dateString = "";

  @override
  void initState() {
    super.initState();

    _selectedDateTime = DateTime.now();
    _loadAvaiableTimeSlotFromApi(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Hello Lisa ,'
          '\nPlease Select date and time',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
        ),
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {},
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
                height: height * 0.4,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(172, 125, 83, 1),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.035, 0.0, width * 0.035, width * 0.035),
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
                    weekendTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    headerTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    iconColor: Colors.white,
                    childAspectRatio: 1.5,
                    weekdayTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    selectedDayButtonColor: Color.fromRGBO(204, 168, 134, 1),
                    selectedDayTextStyle: TextStyle(color: Colors.white),
                    // daysHaveCircularBorder: true,
                    // prevMonthDayBorderColor: Colors.yellow,
                    // showHeader: false,
                    // thisMonthDayBorderColor: Colors.black,
                    // headerText: "hello",
                    daysTextStyle: TextStyle(color: Colors.white),
                    minSelectedDate: DateTime.now().subtract(Duration(days: 1)),
                    maxSelectedDate: DateTime.now().add(Duration(days: 30)),
//      weekDays: null, /// for pass null when you do not want to render weekDays
                    //  headerText: Container( /// Example for rendering custom header
                    //    child: Text('Custom Header'),
                    //  ),

                    // weekFormat: false,
                    selectedDateTime: _currentDate,
                    height: height * 0.4,

                    /// null for not rendering any border, true for circular border, false for rectangular border
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.010,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.055),
                child: Row(
                  children: <Widget>[
                    Text(
                      "AVAILABLE SLOTS",
                      style: TextStyle(
                        color: Color.fromRGBO(172, 125, 83, 1),
                        fontSize: width * 0.050,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: width * 0.020),
                    Expanded(
                      child: Divider(
                        color: Color.fromRGBO(216, 206, 197, 0.32),
                        thickness: 10.0,
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
                padding: EdgeInsets.all(width * 0.055),
                child: Row(
                  children: <Widget>[
                    Text(
                      "SPECIALIST",
                      style: TextStyle(
                        color: Color.fromRGBO(172, 125, 83, 1),
                        fontSize: width * 0.050,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: width * 0.020),
                    Expanded(
                      child: Divider(
                        color: Color.fromRGBO(216, 206, 197, 0.32),
                        thickness: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (_selectedTimeSlot != null) _getEmployeeListWidget(),

              SizedBox(
                height: width * 0.055,
              ),

              //if staff is selected then show the book appointment button
              if (_selectedEmployee != null)
                Container(
                  height: height * 0.06,
                  width: width * 0.8,
                  child: TextButton(
                    onPressed: onBookAppointmentButtonClick,
                    child: Text(
                      'Book Appointemnt',
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.05),
                    ),
                    style: TextButton.styleFrom(
                      // primary: Colors.white,
                      backgroundColor: Color.fromRGBO(172, 125, 83, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: height * 0.04,
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
      height: MediaQuery.of(context).size.height * 0.15,
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
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: MediaQuery.of(context).size.height * 0.075,
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
                        style: TextStyle(
                          color: _selectedEmployee?.id ==
                                  emmployeeList[position].id
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.040,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Center(
                    child: Text(
                      emmployeeList[position].firstName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.040,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _getTimeSelectListViewWidget() => Container(
        height: MediaQuery.of(context).size.height * 0.35,
        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.04, 0,
            MediaQuery.of(context).size.width * 0.04, 0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.8),
            // scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availableSlotsResponse.slots.length,
            itemBuilder: (BuildContext context, int position) {
              DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                  _availableSlotsResponse.slots[position].startTime);
              var formatting = new DateFormat("hh:mm");
              dateString = formatting.format(date);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedEmployee = null;
                    _selectedTimeSlot = _availableSlotsResponse.slots[position];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(172, 125, 83, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: _selectedTimeSlot?.startTime ==
                            _availableSlotsResponse.slots[position].startTime
                        ? Color.fromRGBO(172, 125, 83, 1)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      dateString.toString(),
                      style: TextStyle(
                        color: _selectedTimeSlot?.startTime ==
                                _availableSlotsResponse
                                    .slots[position].startTime
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
      );

  void _loadAvaiableTimeSlotFromApi(DateTime dateTime) async {
    final res = await FetchSlots.getTitleSlot(dateTime);
    setState(() {
      _availableSlotsResponse = res.data;
    });
  }

  void onBookAppointmentButtonClick() {
    print('Selected time slot is  -> ${_selectedTimeSlot.startTime}');
    print('Selected Employee is  -> ${_selectedEmployee.firstName}');
    print(
        'Selected Date is  -> ${DateUtil.getDisplayFormatDate(_selectedDateTime)}');
  }
}
