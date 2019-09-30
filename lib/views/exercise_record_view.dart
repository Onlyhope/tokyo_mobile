import 'package:flutter/material.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/exercise_set.dart';

class ExerciseRecordView extends StatefulWidget {
  ExerciseRecord _exerciseRecord;

  ExerciseRecordView(ExerciseRecord exerciseRecord) {
    this._exerciseRecord = exerciseRecord;
  }

  @override
  ExerciseRecordViewState createState() {
    return ExerciseRecordViewState(_exerciseRecord.exerciseName);
  }
}

class ExerciseRecordViewState extends State<ExerciseRecordView> {
  String _exerciseName;
  List<ExerciseSet> _sets;

  ExerciseRecordViewState(String exerciseName) {
    this._exerciseName = exerciseName;
    this._sets = [];

    ExerciseSet setOne = new ExerciseSet();
    setOne.weights = 135;
    setOne.reps = 5;
    _sets.add(setOne);

    ExerciseSet setTwo = new ExerciseSet();
    setTwo.weights = 155;
    setTwo.reps = 5;
    _sets.add(setTwo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text(_exerciseName),
            subtitle: GestureDetector(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int i) =>
                    displaySet(context, i),
                itemCount: _sets.length,
                shrinkWrap: true,
              ),
              onLongPress: () {
                _sets.add(new ExerciseSet());
                setState(() {});
              },
            ),
          )
        ),
      ],
    );
  }

  Widget displaySet(BuildContext context, int i) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(_sets[i].reps.toString())),
        Expanded(child: Text(_sets[i].weights.toString())),
      ],
    );
  }
}
