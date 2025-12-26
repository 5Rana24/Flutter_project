import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_project/api/reservation_service.dart';
import 'package:flutter_project/components/CustomNavBar.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/data/models/reservation.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  final House house;
  ReservationPage({required this.house});
  State<ReservationPage> createState() => _Reservation();
}

class _Reservation extends State<ReservationPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay =
      DateTime.now(); //Day to focus on cuz table claendar doesnot work without it and let the calen know which month is showing and which is going to move
  DateTime?
  _selectedDay; //the day user selected when selecting one day!!!!! work with selectedDayPredicate to calender know which day the user select
  DateTime? _rangeStart;
  //both being null when the user select one day
  DateTime? _rangeEnd;
  final GlobalKey _calendarKey = GlobalKey();
  OverlayEntry? _rangeErrorOverlay; //tp show the problem msg
  late Future<void> _reservationsFuture;
  late List<DateTime> bookedDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _reservationsFuture = _loadBookedDates();

  }

  @override
  void dispose() {
    super.dispose();
  }

  ///////////////////////////////////////////////////////To get the reservation of the house
  Future<void> _loadBookedDates() async {
    try {
    print("🎉 تحميل الحجوزات");
    await widget.house.loadReservations();
    bookedDates = widget.house.getBookedDays();
  } catch (e) {
    print("❌ Failed to load reservations: $e");

  }
  }
  // the reason to need those when i select one day(RangeSelectionMode.toggledOn) table calender do:
  //_rangeStart = selectedDay
  // _rangeEnd   = null
  // _selectedDay = null and the end day is the same selected Day

  DateTime? getStartDate() {
    return _rangeStart ?? _selectedDay;
  }

  DateTime? getEndDate() {
    if (_rangeStart != null && _rangeEnd == null) {
      return _rangeStart; // One Day so _rangeEnd =_rangeStart
    }
    return _rangeEnd ?? _selectedDay; // selectedDay here is the end
  }

  //oneday Selected works when there is no range
  void _onDaySelected(DateTime selectedDay, DateTime foucsedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay;
    });
  }

  //To check if the user selected range conatins reserrved Days
  bool _rangeContainsBookedDay(DateTime start, DateTime end) {
    DateTime day = start;

    while (!day.isAfter(end)) {
      if (bookedDates.any((d) => isSameDay(d, day))) {
        return true;
      }
      day = day.add(const Duration(days: 1));
    }

    return false;
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (start != null && end != null) {
      if (_rangeContainsBookedDay(start, end)) {
        // رفض الـ range
        setState(() {
          _rangeStart = null;
          _rangeEnd = null;
          _selectedDay = null;
          _focusedDay = focusedDay;
        });

        _showRangeErrorOverlay("This range contains booked days");
        return;
      }
    }

    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  //Showing msg about the problem
  void _showRangeErrorOverlay(String msg) {
    if (_rangeErrorOverlay != null) return;

    final overlay = Overlay.of(context);
    final renderBox =
        _calendarKey.currentContext!.findRenderObject() as RenderBox;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    _rangeErrorOverlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: position.dy - position.dy / 4,
        //bottom: position.dy + size.height / 2 - 20, // ✅ منتصف التقويم
        left: position.dx,
        right: position.dx,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_rangeErrorOverlay!);

    Future.delayed(const Duration(seconds: 5), () {
      _rangeErrorOverlay?.remove();
      _rangeErrorOverlay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _reservationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return  Scaffold(
            appBar: AppBar(),
            body: Center(child: Text("Downliading Reservations Failed")),
          );
        }

        //the data exist
        return Scaffold(body: ReservationWidget(bookedDates));
      },
    );
  }

  Widget ReservationWidget(List<DateTime> bookedDates) {
    DateTime? start = getStartDate();
    DateTime? end = getEndDate();int days = 0;

    if (start != null && end != null) {
      days = end.difference(start).inDays + 1;
    }
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            ////////////////////////////Select Date
            Container(
              alignment: Alignment.center,
              width: screenWidth * 0.9,
              height: screenHeight * 0.08,
              decoration: Shadow(Colors.white, 12),
              child: Text(
                "Select Date",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ////////////////////////////Calender
            Calender(),
            SizedBox(height: screenHeight * 0.04),
            ////////////////////////////Start & end date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShowDate(
                  screenWidth * 0.42,
                  screenHeight * 0.06,
                  getStartDate(),
                ),
                ShowDate(screenWidth * 0.42, screenHeight * 0.06, getEndDate()),
              ],
            ),
            Expanded(child: SizedBox()),
            ////////////////////////////////price & book button
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.04),
              padding: EdgeInsets.all(screenWidth * 0.01),
              width: screenWidth * 0.9,
              height: screenHeight * 0.08,
              decoration: Shadow(Theme.of(context).colorScheme.secondary, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /////price
                  Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.035),
                    child: Text( start != null && end != null
                    ? "${(widget.house.price! * days).floor()} SYP /day"
                    : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  //////Book Button
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: Shadow(Colors.white, 18),
                    child: MaterialButton(
                      onPressed: () async {
                        final userModel = context.read<UserModel>();
                        final start = getStartDate();
                        final end = getEndDate();

                        if (start == null || end == null) {
                          _showRangeErrorOverlay("Select Date");
                          return;
                        }

                        try {

                          // making reservation
                          await userModel.createReservation(
                            start,
                            end,
                            widget.house.id!,
                          );
                          _showRangeErrorOverlay(
                            "Your request has been sent to the owner \n you will get the response through a notification ",
                          );
                          ///////////////////////Dealing with this reservation after that the buttons should be changed
                        }  on ApiException catch (e) {
                          //For exceptions from Api
                          _showRangeErrorOverlay("$e");
                          // after u see the exception u know now there is a change in  house reservation  so update the caledar
                            await _loadBookedDates();
                            setState(() {});
                        } catch (e) {
                          //else Excpetions
                          _showRangeErrorOverlay("we have a problem with the server , try again later");
                          print("Unexpected error: $e");
                        }
                      },
                      child: Text("Book"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ShowDate(double width, double height, DateTime? date) {
    return Container(
      decoration: Shadow(Colors.white, 12),
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.start,
              date == null
                  ? " "
                  : DateFormat('yyyy-MM-dd').format(date!).toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget Calender() {
    return Container(
      key: _calendarKey,

      /// to put overlay on the calendar
      decoration: Shadow(Colors.white, 12),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 50,
        firstDay: DateTime.now(),

        /// cant select a day before Today
        lastDay: DateTime.now().add(Duration(days: 365 * 3)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(
          _selectedDay,
          day,
        ), //asking caledar is the is the selected Day??
        onDaySelected: _onDaySelected, // when the user select one day
        //Range
        onRangeSelected: _onRangeSelected, //can select a range
        rangeSelectionMode: RangeSelectionMode.toggledOn,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        enabledDayPredicate: (day) {
          return !bookedDates.any((d) => isSameDay(d, day));
        }, //not to let u  select range with a booked days //checking days btw start & end dayrange
        //////////////////////////////////////////////////////////////////////Formating
        onFormatChanged: (format) {
          ///No change Format even the size is Changed
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF437e76), // secondary
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF74a29c)),
          rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF74a29c)),
        ),
        //Days Format
        daysOfWeekStyle: DaysOfWeekStyle(
          decoration: BoxDecoration(),
          weekdayStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF74a29c),
          ),
          weekendStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF74a29c),
          ),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(fontSize: 14, color: Colors.black),
          weekendTextStyle: TextStyle(fontSize: 14, color: Colors.black),
          //outRange
          outsideTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.withOpacity(0.4),
          ),
          //before firstday and after Lastday
          disabledTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.withOpacity(0.4),
          ),
          //the day selected
          selectedDecoration: BoxDecoration(
            color: Color(0xFF74a29c), // secondary
            shape: BoxShape.circle,
          ),
          //Range
          withinRangeTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          rangeHighlightColor: Color(0xFF74a29c),
          rangeStartDecoration: BoxDecoration(
            color: Color(0xFF437e76), // secondary
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: Color(0xFF437e76), // secondary
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          todayDecoration: BoxDecoration(
            color: Color.fromARGB(76, 222, 208, 50), // tertiary
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

BoxDecoration Shadow(Color color, double border) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15), // لون الظل
        blurRadius: 12, // مدى انتشار الظل
        spreadRadius: 2, // مدى تمدد الظل
        offset: Offset(0, 4), // اتجاه الظل للأسفل
      ),
    ],
  );
}
