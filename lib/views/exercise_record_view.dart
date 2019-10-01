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
        ListTile(
          title: Text(_exerciseName),
          trailing: IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add a set',
            color: Colors.deepOrangeAccent,
            onPressed: () {
              _sets.add(new ExerciseSet());
              setState(() {});
            },
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int i) =>
                displaySet(context, i),
            separatorBuilder: (BuildContext context, index) {
              return Divider();
            },
            itemCount: _sets.length,
            shrinkWrap: true,
          ),
        ),
        Divider()
      ],
    );
  }

  Widget displaySet(BuildContext context, int i) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black38, width: 2.0))),
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(child: Text(_sets[i].reps.toString())),
                  width: 57,
                  height: 35
                )
            )
        ),
        Expanded(
          child: Center(
            child: Text('rep(s)')
          )
        ),
        Divider(),
        Expanded(
            child: Center(
                child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          child: Center(child: Text(_sets[i].weights.toString())),
          width: 57,
          height: 35,
        ))),
        Expanded(
          child: Center(
            child: Text('lbs')
          )
        )
      ],
    );
  }
}
