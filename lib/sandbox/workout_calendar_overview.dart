import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WorkoutCalendarOverview extends StatefulWidget {
  @override
  WorkoutCalendarOverviewState createState() {
    return WorkoutCalendarOverviewState();
  }
}

class WorkoutCalendarOverviewState extends State<WorkoutCalendarOverview> {
  String _title = 'Workout Overview';
  CalendarController _calendarController;
  List<CalendarFormat> _availableCalendarFormats = [CalendarFormat.month];

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: TableCalendar(
          calendarController: _calendarController,
          headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
              formatButtonVisible: false,
              centerHeaderTitle: true),
        ));
  }
}
