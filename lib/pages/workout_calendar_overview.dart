import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/workout.dart';
import 'package:tokyo_mobile/stubs/data_template.dart';
import 'package:collection/collection.dart';
import 'package:tokyo_mobile/widgets/workout_records_view.dart';

class WorkoutCalendarOverview extends StatefulWidget {
  @override
  WorkoutCalendarOverviewState createState() {
    return WorkoutCalendarOverviewState();
  }
}

class WorkoutCalendarOverviewState extends State<WorkoutCalendarOverview> {
  final String _title = 'Workout Overview';
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
  Map<DateTime, List<WorkoutRecord>> _workouts;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _monthOfExerciseRecords = DataTemplate().monthOfExerciseRecords();

    Map<String, List<ExerciseRecord>> workouts = groupBy(
        _monthOfExerciseRecords, (exerciseRecord) => exerciseRecord.workoutId);
    var workoutList = workouts.values.map((exerciseRecords) =>
        WorkoutRecord.fromExerciseRecords(exerciseRecords: exerciseRecords));
    _workouts = groupBy(workoutList, (workout) => workout.startDate);
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
              events: _workouts,
              onDaySelected: _onDaySelected,
              onDayLongPressed: _onDayLongPressed,
              calendarStyle: CalendarStyle(canEventMarkersOverflow: false),
              headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  formatButtonVisible: false,
                  centerHeaderTitle: true)),
          const SizedBox(height: 8.0),
          WorkoutRecordsView(workoutRecords: _selectedWorkouts, colorPool: colorPool),
          const SizedBox(height: 8.0)
        ]));
  }

}
