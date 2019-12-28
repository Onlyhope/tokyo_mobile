import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/exercise_set.dart';
import 'package:tokyo_mobile/models/workout.dart';

class WorkoutRecordsView extends StatelessWidget {
  final List<WorkoutRecord> workoutRecords;
  final List<Color> colorPool;

  WorkoutRecordsView({this.workoutRecords, this.colorPool}) {
    workoutRecords
        .retainWhere((workoutRecord) => workoutRecord is WorkoutRecord);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: _buildWorkoutRecords(workoutRecords));
  }

  List<Widget> _buildWorkoutRecords(List<WorkoutRecord> workoutRecords) {
    if (workoutRecords == null) return [];
    List<Color> colors = _generateColors(workoutRecords.length, colorPool);
    var pairs = List.generate(
        workoutRecords.length, (int i) => [workoutRecords[i], colors[i]]);
    return pairs
        .map((pair) => _toExerciseRecordView(pair[0], pair[1]))
        .expand((item) => item)
        .toList();
  }

  List<Widget> _toExerciseRecordView(var workout, Color bgColor) {
    if (workout is WorkoutRecord) {
      return workout.exerciseRecords
          .map((exerciseRecord) => ExerciseRecordView(exerciseRecord, bgColor))
          .toList();
    } else {
      return [];
    }
  }

  List<Color> _generateColors(int n, List<Color> colorPool) {
    List<Color> colors = List(n);
    for (int i = 0; i < colors.length; i++) {
      colors[i] = colorPool[i % colorPool.length];
    }
    return colors;
  }
}

class ExerciseRecordView extends StatelessWidget {
  final ExerciseRecord _exerciseRecord;
  final Color _bgColor;

  ExerciseRecordView(this._exerciseRecord, this._bgColor);

  @override
  Widget build(BuildContext context) {
    return _buildExerciseRecordView(_exerciseRecord, _bgColor);
  }

  Widget _buildExerciseRecordView(
      ExerciseRecord exerciseRecord, Color bgColor) {
    if (exerciseRecord.exerciseSets.isEmpty) {
      return Container(
          child: ListTile(
            title: Text(
              exerciseRecord.exerciseName,
              style: TextStyle(color: Colors.black45),
            ),
            dense: true,
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 2.0, color: bgColor)));
    }

    return Container(
        child: ExpansionTile(
          key: PageStorageKey<ExerciseRecord>(exerciseRecord),
          title: Text(exerciseRecord.exerciseName),
          children: exerciseRecord.exerciseSets
              .map((set) => _buildSetView(set))
              .toList(),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0, color: bgColor)));
  }

  Widget _buildSetView(ExerciseSet exerciseSet) {
    return ListTile(
      title: Text(exerciseSet.repsAndWeight()),
      dense: true,
    );
  }
}
