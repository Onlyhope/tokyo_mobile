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
    squat.exerciseName = "Squat";//    exerciseRecords.add(squat);

    ExerciseRecord bench = ExerciseRecord();
    bench.exerciseName = "Bench";

    this.exerciseRecords = [squat, bench];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) => displayItem(exerciseRecords[i]),
        itemCount: exerciseRecords.length,
        shrinkWrap: true,
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
    return ExerciseRecordView(exerciseRecord);
  }

}

