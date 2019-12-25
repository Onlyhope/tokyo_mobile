import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/workout.dart';
import 'package:tokyo_mobile/stubs/data_template.dart';
import 'package:collection/collection.dart';

class WorkoutCalendarOverview extends StatefulWidget {
  @override
  WorkoutCalendarOverviewState createState() {
    return WorkoutCalendarOverviewState();
  }
}

class WorkoutCalendarOverviewState extends State<WorkoutCalendarOverview> {

  final String _title = 'Workout Overview';

  List<ExerciseRecord> _monthOfExerciseRecords;
  Map<DateTime, List<WorkoutRecord>> _workouts;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
    _monthOfExerciseRecords = DataTemplate().monthOfExerciseRecords();
    
    Map<String, List<ExerciseRecord>> workouts = groupBy(_monthOfExerciseRecords, (exerciseRecord) => exerciseRecord.workoutId);
    var workoutList = workouts.values.map((exerciseRecords) {
      DateTime start = exerciseRecords.first.createdDate;
      DateTime end = exerciseRecords.last.createdDate;
      return WorkoutRecord(
        exerciseRecords: exerciseRecords,
        startDate: start,
        endDate: end
      );
    });
    _workouts = groupBy(workoutList, (workout) => workout.startDate);
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
          events: _workouts,
          calendarStyle: CalendarStyle(
            canEventMarkersOverflow: false
          ),
          headerStyle: HeaderStyle(
              formatButtonShowsNext: false,
              formatButtonVisible: false,
              centerHeaderTitle: true),
        ),
      floatingActionButton: FloatingActionButton(
        child: Text("Press"),
        onPressed: () {
          print("Workouts:\n$_workouts");
        },
      ),
    );
  }
}
