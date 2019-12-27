import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/exercise_set.dart';
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

  List _selectedWorkouts;
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

  void _onDaySelected(DateTime day, List workouts) {
    print("Today is ${day.toIso8601String()}");
    print("You have done the following workout: ");
    for (var workoutRecord in workouts) {
      print("Workout: $workoutRecord");
    }
    setState(() {
      _selectedWorkouts = workouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: ListView(
          children: <Widget>[
            TableCalendar(
              calendarController: _calendarController,
              events: _workouts,
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: false
              ),
              headerStyle: HeaderStyle(
                  formatButtonShowsNext: false,
                  formatButtonVisible: false,
                  centerHeaderTitle: true),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 8.0),
            Column(
              children: _buildWorkoutRecords(_selectedWorkouts),
            ),
            const SizedBox(height: 8.0)
          ]
        ),
      floatingActionButton: FloatingActionButton(
        child: Text("Press"),
        onPressed: () {
          print("Selected Workout:\n$_selectedWorkouts");
        }
      ),
    );
  }

  // Flatten the Workout Records into a list of Exercise Records
  // Display a list of Exercise Record as Expansion Tiles
  // Color code each exercise record to its respective workout
  List<Widget> _buildWorkoutRecords(List workoutRecords) {
    if (workoutRecords == null) return [];
    return workoutRecords
        .map((workout) => _toExerciseRecordView(workout))
        .expand((item) => item)
        .toList();
  }

  List<Widget> _toExerciseRecordView(workout) {
    if (workout is WorkoutRecord) {
      return workout.exerciseRecords.map((exerciseRecord) => ExerciseRecordView(exerciseRecord)).toList();
    } else {
      return [];
    }
  }
}

class ExerciseRecordView extends StatelessWidget {

  final ExerciseRecord _exerciseRecord;

  ExerciseRecordView(this._exerciseRecord);

  @override
  Widget build(BuildContext context) {
    return _buildExerciseRecordView(_exerciseRecord);
  }

  Widget _buildExerciseRecordView(ExerciseRecord exerciseRecord) {

    if (exerciseRecord.exerciseSets.isEmpty) {
      return ListTile(title: Text(exerciseRecord.exerciseName));
    }

    return ExpansionTile(
      key: PageStorageKey<ExerciseRecord>(exerciseRecord),
      title: Text(exerciseRecord.exerciseName),
      children: exerciseRecord.exerciseSets.map(_buildSetView).toList(),
    );
  }

  Widget _buildSetView(ExerciseSet exerciseSet) {
    return ListTile(title: Text(exerciseSet.repsAndWeight()));
  }

}
