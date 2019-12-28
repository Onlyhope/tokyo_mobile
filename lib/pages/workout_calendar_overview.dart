import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/workout.dart';
import 'package:tokyo_mobile/stubs/data_template.dart';
import 'package:collection/collection.dart';
import 'package:tokyo_mobile/widgets/ExerciseRecordView.dart';

class WorkoutCalendarOverview extends StatefulWidget {
  @override
  WorkoutCalendarOverviewState createState() {
    return WorkoutCalendarOverviewState();
  }
}

class WorkoutCalendarOverviewState extends State<WorkoutCalendarOverview> {
  final String _title = 'Workout Overview';

  List _selectedWorkouts;
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
    var workoutList = workouts.values.map((exerciseRecords) {
      DateTime start = exerciseRecords.first.createdDate;
      DateTime end = exerciseRecords.last.createdDate;
      return WorkoutRecord(
          exerciseRecords: exerciseRecords, startDate: start, endDate: end);
    });
    _workouts = groupBy(workoutList, (workout) => workout.startDate);
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List workouts) {
    setState(() {
      _selectedWorkouts = workouts;
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
          Column(
            children: _buildWorkoutRecords(_selectedWorkouts),
          ),
          const SizedBox(height: 8.0)
        ]));
  }

  List<Widget> _buildWorkoutRecords(List workoutRecords) {
    if (workoutRecords == null) return [];
    List<Color> colors = _generateColors(workoutRecords.length);
    var pairs = List.generate(
        workoutRecords.length, (int i) => [workoutRecords[i], colors[i]]);
    return pairs
        .map((pair) => _toExerciseRecordView(pair[0], pair[1]))
        .expand((item) => item)
        .toList();
  }

  List<Widget> _toExerciseRecordView(workout, Color bgColor) {
    if (workout is WorkoutRecord) {
      return workout.exerciseRecords
          .map((exerciseRecord) => ExerciseRecordView(exerciseRecord, bgColor))
          .toList();
    } else {
      return [];
    }
  }

  List<Color> _generateColors(int n) {
    List<Color> colorPool = [
      Color(0x77ff9aa2),
      Color(0x77ffb7b2),
      Color(0x77ffdac1),
      Color(0x77e2f0cb),
      Color(0x77b5ead7),
      Color(0x77c7ceea)
    ];

    List<Color> colors = List(n);
    for (int i = 0; i < colors.length; i++) {
      colors[i] = colorPool[i % 6];
    }
    return colors;
  }
}
