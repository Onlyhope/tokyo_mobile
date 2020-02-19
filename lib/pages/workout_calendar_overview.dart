import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/workout.dart';
import 'package:tokyo_mobile/services/exercise_record_service.dart';
import 'package:tokyo_mobile/stubs/data_template.dart';
import 'package:collection/collection.dart';
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
  List<ExerciseRecord> _monthOfExerciseRecords;
  Map<DateTime, List<ExerciseRecord>> _exerciseRecordsByCreatedDate;
  CalendarController _calendarController;
  DateTime startOfMonth;
  DateTime endOfMonth;

  WorkoutCalendarOverviewState({@required this.username});

  @override
  void initState() async {
    super.initState();
    _calendarController = CalendarController();

    DateTime today = DateTime.now().toLocal();
    startOfMonth = DateTime(today.year, today.month);
    endOfMonth = DateTime(today.year, today.month);

    List<ExerciseRecord> _monthOfExerciseRecords = await exerciseRecordService
        .fetchExerciseRecords(username, startOfMonth, endOfMonth);

    _exerciseRecordsByCreatedDate =
        groupBy(_monthOfExerciseRecords, (exerciseRecord) {
      DateTime createdDate = exerciseRecord.createdDate;
      return DateTime(createdDate.year, createdDate.month, createdDate.day);
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List workouts) {
    setState(() {
      _selectedWorkouts = workouts.map((workoutRecord) {
        if (workoutRecord is WorkoutRecord) {
          return workoutRecord;
        } else {
          return null;
        }
      }).toList();
      _selectedWorkouts.removeWhere((workout) => workout == null);
    });
  }

  void _onDayLongPressed(DateTime day, List workouts) {
    // TODO - Go to Workout or Create new Workout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: ListView(children: <Widget>[
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
        ]));
  }
}
