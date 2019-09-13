import 'package:flutter/material.dart';

import '../models/exercise_record.dart';
import 'exercise_record_view.dart';

class DynamicListView extends StatefulWidget {
  @override
  ExerciseRecordListView createState() {
    return ExerciseRecordListView();
  }
}

class ExerciseRecordListView extends State<DynamicListView> {

  List<ExerciseRecord> exerciseRecords;

  ExerciseRecordListView() {
    ExerciseRecord squat = ExerciseRecord();
    squat.exercise_name = "Squat";
//    exerciseRecords.add(squat);

    ExerciseRecord bench = ExerciseRecord();
    bench.exercise_name = "Bench";
//    exerciseRecords.add(bench);

    this.exerciseRecords = [squat, bench];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int i) => displayItem(exerciseRecords[i]),
                itemCount: exerciseRecords.length,
                shrinkWrap: true,
              )
          );
        },
        itemCount: exerciseRecords.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          print(exerciseRecords.length);
          _addExerciseRecord();
        },
      ),
    );
  }

  void _addExerciseRecord() {
    print('Adding exercise record...');
  }

  Widget displayItem(ExerciseRecord exerciseRecord) {

    String exerciseName = exerciseRecord.exercise_name;

    return ExerciseRecordView(exerciseRecord);
  }

}

