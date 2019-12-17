import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/stubs/data_template.dart';

class WorkoutCalendarOverview extends StatefulWidget {
  @override
  WorkoutCalendarOverviewState createState() {
    return WorkoutCalendarOverviewState();
  }
}

class WorkoutCalendarOverviewState extends State<WorkoutCalendarOverview> {

  final String _title = 'Workout Overview';

  List<ExerciseRecord> monthOfExerciseRecords = DataTemplate().monthOfExerciseRecords();
  CalendarController _calendarController;

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
