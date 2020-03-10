import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/workout.dart';
import 'package:tokyo_mobile/services/exercise_record_service.dart';
import 'package:tokyo_mobile/widgets/workout_records_view.dart';

class WorkoutCalendarOverview extends StatefulWidget {
  final String username;

  WorkoutCalendarOverview({@required this.username});

  @override
  WorkoutCalendarOverviewState createState() {
    return WorkoutCalendarOverviewState(username: username);
  }
}

class WorkoutCalendarOverviewState extends State<WorkoutCalendarOverview> {
  final ExerciseRecordService exerciseRecordService = ExerciseRecordService();
  final String _title = 'Workout Overview';
  final String username;
  final List<Color> colorPool = [
    Color(0x77ff9aa2),
    Color(0x77ffb7b2),
    Color(0x77ffdac1),
    Color(0x77e2f0cb),
    Color(0x77b5ead7),
    Color(0x77c7ceea)
  ];

  List<WorkoutRecord> _selectedWorkouts;
  Map<DateTime, List<ExerciseRecord>> _exerciseRecordsByCreatedDate;
  CalendarController _calendarController;
  DateTime _startOfMonth;
  DateTime _endOfMonth;

  WorkoutCalendarOverviewState({@required this.username});

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    DateTime today = DateTime.now().toLocal();
    _startOfMonth = DateTime(today.year, today.month).toUtc();
    _endOfMonth = DateTime(today.year, today.month + 1).toUtc();
    loadExerciseRecords();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List exerciseRecords) {
    setState(() {

    });
  }

  void _onDayLongPressed(DateTime day, List workouts) {
    // TODO - Go to Workout or Create new Workout
  }

  void loadExerciseRecords() async {
    List<ExerciseRecord> exerciseRecords = await exerciseRecordService.fetchExerciseRecords(
        username, _startOfMonth, _endOfMonth);

    setState(() {
      _exerciseRecordsByCreatedDate =
          groupBy(exerciseRecords, (exerciseRecord) {
            DateTime createdDate = exerciseRecord.createdDate;
            return DateTime(createdDate.year, createdDate.month, createdDate.day);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
//    loadExerciseRecords();
  print("Building... ${_exerciseRecordsByCreatedDate.toString()}");
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: _displayCalendarOverview()
    );
  }

  Widget _displayCalendarOverview() {
    return ListView(
        children: <Widget>[
          TableCalendar(
              calendarController: _calendarController,
              events: _exerciseRecordsByCreatedDate,
              onDaySelected: _onDaySelected,
              onDayLongPressed: _onDayLongPressed,
              calendarStyle: CalendarStyle(canEventMarkersOverflow: false),
              headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  formatButtonVisible: false,
                  centerHeaderTitle: true)),
          const SizedBox(height: 8.0),
          WorkoutRecordsView(
              workoutRecords: _selectedWorkouts, colorPool: colorPool),
          const SizedBox(height: 8.0)
        ]
    );
  }
}
