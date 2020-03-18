import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/exercise_set.dart';
import 'package:tokyo_mobile/models/workout.dart';

class WorkoutRecordView extends StatelessWidget {
  final List<ExerciseRecord> exerciseRecords;
  final List<Color> colorPool;

  WorkoutRecordView({this.exerciseRecords, this.colorPool});

  @override
  Widget build(BuildContext context) {
    return Column(children: _toExerciseRecordView(exerciseRecords, Color(0x77ff9aa2)));
  }

  List<Widget> _toExerciseRecordView(List<ExerciseRecord> exerciseRecords, Color bgColor) {
    return exerciseRecords
        .map((exerciseRecord) => ExerciseRecordView(exerciseRecord, bgColor))
        .toList();
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
          margin: EdgeInsets.only(top: 3.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 2.0, color: bgColor))
      );
    }

    return Container(
        child: ExpansionTile(
          key: PageStorageKey<ExerciseRecord>(exerciseRecord),
          title: Text(exerciseRecord.exerciseName),
          children: exerciseRecord.exerciseSets
              .map((set) => _buildSetView(set))
              .toList(),
        ),
        margin: EdgeInsets.only(top: 3.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 2.0, color: bgColor))
    );
  }

  Widget _buildSetView(ExerciseSet exerciseSet) {
    return ListTile(
      title: Text(exerciseSet.repsAndWeight()),
      dense: true,
    );
  }
}
