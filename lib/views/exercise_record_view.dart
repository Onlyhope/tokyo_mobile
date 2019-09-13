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
    return ExerciseRecordViewState(_exerciseRecord.exercise_name);
  }


}

class ExerciseRecordViewState extends State<ExerciseRecordView> {

  String exerciseName;
  List<ExerciseSet> sets;

  ExerciseRecordViewState(String exerciseName) {
    this.exerciseName = exerciseName;
    this.sets = [];

    ExerciseSet setOne = new ExerciseSet();
    setOne.weights = 135;
    setOne.reps = 5;
    sets.add(setOne);

    ExerciseSet setTwo = new ExerciseSet();
    setTwo.weights = 155;
    setTwo.reps = 5;
    sets.add(setTwo);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Container(
              child: Text(exerciseName),
              height: 45,
            color: Colors.amber,
          ),
          Container(
            height: 30,
            color: Colors.amberAccent,
            child: GestureDetector(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int i) => displaySet(context, i),
                  itemCount: sets.length,
                  shrinkWrap: true,
              ),
              onLongPress: () {
                sets.add(new ExerciseSet());
                setState(() {});
              },
            ),

          )
        ],
    );
  }

  Widget displaySet(BuildContext context, int i) {

    return Row(
      children: <Widget>[
        Expanded(
            child: Text(sets[i].reps.toString())
        ),
        Expanded(
            child: Text(sets[i].weights.toString())
        ),
      ],
    );
  }

}