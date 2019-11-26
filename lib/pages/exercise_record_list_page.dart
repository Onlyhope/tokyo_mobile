import 'package:flutter/material.dart';

import '../models/exercise_record.dart';
import '../models/exercise_set.dart';

class ExerciseRecordListPage extends StatefulWidget {
  @override
  ExerciseRecordListPageState createState() {
    return ExerciseRecordListPageState();
  }
}

class ExerciseRecordListPageState extends State<ExerciseRecordListPage> {
  final TextEditingController createExerciseTextController =
      TextEditingController();

  List<ExerciseRecord> _exerciseRecords = [];

  @override
  void dispose() {
    createExerciseTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            _displayExerciseRecords(index),
        itemCount: _exerciseRecords.length,
        shrinkWrap: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          _createExercise(context, createExerciseTextController);
        },
      ),
    );
  }

  Widget _displayExerciseRecords(int recordIndex) {
    ExerciseRecord exerciseRecord = _exerciseRecords[recordIndex];
    return Column(
      children: <Widget>[
        ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            title: Text(exerciseRecord.exerciseName),
            trailing: IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add a set',
              color: Colors.deepOrangeAccent,
              onPressed: () {
                setState(() {
                  exerciseRecord.exerciseSets.add(ExerciseSet(135, 5));
                  print('${exerciseRecord.exerciseSets.length}');
                });
              },
            ),
          onLongPress: () {
              print(exerciseRecord);
          },
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.separated(
            itemBuilder: (BuildContext context, int setIndex) =>
                _displaySet(context, recordIndex, setIndex),
            separatorBuilder: (BuildContext context, int i) => Divider(),
            itemCount: exerciseRecord.exerciseSets.length,
            shrinkWrap: true,
          ),
        ),
        Divider()
      ],
    );
  }

  Widget _displaySet(BuildContext context, int recordIndex, int setIndex) {
    ExerciseSet exerciseSet = _exerciseRecords[recordIndex].exerciseSets[setIndex];
    final double width = 57;
    final double height = 35;
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
                child: Container(
//                decoration: BoxDecoration(
//                    border: Border(
//                        bottom: BorderSide(color: Colors.black38, width: 2.0))),
                    padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                        child: TextFormField(
                          initialValue: exerciseSet.weight.toString(),
                          onChanged: (val) {
                            setState(() {exerciseSet.weight = int.parse(val);});
                          },
                          onTap: () {
                            print('${_exerciseRecords[recordIndex]}');
                          },
                        )
                    ),
                    width: width,
                    height: height))),
        Expanded(child: Center(child: Text('weight'))),
        Divider(),
        Expanded(
            child: Center(
                child: Container(
//                decoration: BoxDecoration(
//                    border: Border(
//                        bottom: BorderSide(color: Colors.black38, width: 2.0))),
                    padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                        child: TextFormField(
                          initialValue: exerciseSet.reps.toString(),
                          onChanged: (val) {
                            setState(() {exerciseSet.reps = int.parse(val);});
                          },
                          onTap: () {
                            print('${_exerciseRecords[recordIndex]}');
                          },
                        )
                    ),
                    width: width,
                    height: height))),
        Expanded(child: Center(child: Text('rep(s)')))
      ],
    );
  }

  Future<void> _createExercise(
      BuildContext context, TextEditingController exerciseNameText) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text('Select an exercise'),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 9.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(),
                    ),
                    controller: exerciseNameText,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: FlatButton(
                          onPressed: () {
                            _exerciseRecords
                                .add(ExerciseRecord(exerciseNameText.text));
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Create')),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: FlatButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ]);
        });
  }
}
