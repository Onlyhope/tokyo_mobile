import 'package:flutter/material.dart';

import '../models/exercise_record.dart';
import '../models/exercise_set.dart';

class DynamicListView extends StatefulWidget {
  @override
  _ExerciseRecordListView createState() {
    return _ExerciseRecordListView();
  }
}

class _ExerciseRecordListView extends State<DynamicListView> {
  List<ExerciseRecord> exerciseRecords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) =>
            _displayExerciseRecords(exerciseRecords[i]),
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

  Widget _displayExerciseRecords(ExerciseRecord exerciseRecord) {
    return Column(
      children: <Widget>[
        ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
            title: Text(exerciseRecord.exerciseName),
            trailing: IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add a set',
              color: Colors.deepOrangeAccent,
              onPressed: () {
                setState() {}
              },
            )),
        Divider(),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int i) =>
                _displaySet(context, exerciseRecord.exerciseSets[i]),
            separatorBuilder: (BuildContext context, int i) => Divider(),
            itemCount: exerciseRecord.exerciseSets.length,
            shrinkWrap: true,
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _displaySet(BuildContext context, ExerciseSet exerciseSet) {
    return Row(
      children: <Widget>[
        _displayValue(context, exerciseSet.reps.toString()),
        Expanded(child: Center(child: Text('rep(s)'))),
        Divider(),
        _displayValue(context, exerciseSet.weight.toString()),
        Expanded(child: Center(child: Text('lbs')))
      ],
    );
  }

  Widget _displayValue(BuildContext context, String value) {
    final double width = 57;
    final double height = 35;
    return Expanded(
        child: Center(
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black38, width: 2.0))),
                padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Center(child: Text(value)),
                width: width,
                height: height)));
  }
}
