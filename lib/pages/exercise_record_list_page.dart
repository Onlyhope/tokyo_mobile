import 'package:flutter/material.dart';
import 'package:tokyo_mobile/services/exercise_record_service.dart';

import '../models/exercise_record.dart';
import '../models/exercise_set.dart';

class ExerciseRecordListPage extends StatefulWidget {
  final String username;
  final String workoutId;

  ExerciseRecordListPage({@required this.username, @required this.workoutId});

  @override
  ExerciseRecordListPageState createState() {
    return ExerciseRecordListPageState();
  }
}

class ExerciseRecordListPageState extends State<ExerciseRecordListPage> {
  final ExerciseRecordService exerciseRecordService = ExerciseRecordService();
  final TextEditingController createExerciseTextController =
      TextEditingController();
  final String _title = 'Workout Log';

  String _username;
  String _workoutId;
  List<ExerciseRecord> _exerciseRecords = [];

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _workoutId = widget.workoutId;
  }

  @override
  void dispose() {
    createExerciseTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Container(
        child: FutureBuilder<List<ExerciseRecord>>(
          future: exerciseRecordService.fetchExerciseRecords(_username),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("Snapshot Error: ${snapshot.hasError}");

            print("Snapshot Error: ${snapshot.error}");

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container(child: Text('Loading...'));
                break;
              case ConnectionState.waiting:
                return Container(child: Text('Loading...'));
                break;
              case ConnectionState.active:
                return Container(child: Text('Loading...'));
                break;
              case ConnectionState.done:
                List<ExerciseRecord> exerciseRecords = snapshot.data;
                return _displayExerciseRecordList(exerciseRecords);
            }

            return Container();
          },
        ),
      ),
      floatingActionButton: _addExerciseRecordButton(),
    );
  }

  Widget _displayExerciseRecordList(List<ExerciseRecord> exerciseRecords) {
    print('Exercise Records: $exerciseRecords');
    return ListView.builder(
        itemBuilder: (context, index) {
          return _displayAnExerciseRecord(exerciseRecords[index]);
        },
        itemCount: exerciseRecords.length);
  }

  Widget _displayAnExerciseRecord(ExerciseRecord exerciseRecord) {
    print('Exercise Record to display: $exerciseRecord');
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          title: Text('${exerciseRecord.nameAndCreatedDate()}'),
          trailing: IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add a set',
            color: Colors.deepOrangeAccent,
            onPressed: () async {
              int weight = 0;
              int reps = 0;
              if (exerciseRecord.exerciseSets.isNotEmpty) {
                ExerciseSet lastSet = exerciseRecord.exerciseSets.last;
                weight = lastSet.weight;
                reps = lastSet.reps;
              }
              exerciseRecord.exerciseSets.add(ExerciseSet(weight, reps));
              await exerciseRecordService.saveExerciseRecord(
                  _username, exerciseRecord, exerciseRecord.exerciseRecId);
              setState(() {});
            },
          ),
        ),
        ListView.separated(
            itemBuilder: (BuildContext context, int setIndex) {
              final ExerciseSet exerciseSet =
                  exerciseRecord.exerciseSets[setIndex];
              return Dismissible(
                key: Key(exerciseSet.hashCode.toString()),
                child: _displaySet(context, exerciseSet, exerciseRecord),
                onDismissed: (direction) async {
                  exerciseRecord.exerciseSets.removeAt(setIndex);
                  await exerciseRecordService.saveExerciseRecord(
                      _username, exerciseRecord, exerciseRecord.exerciseRecId);
                  setState(() {});
                },
                background: Container(color: Colors.red),
              );
            },
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int) => Divider(),
            itemCount: exerciseRecord.exerciseSets.length)
      ],
    );
  }

  Widget _displaySet(
      BuildContext context, ExerciseSet exerciseSet, ExerciseRecord parent) {
    final double width = 70;

    final double height = 35;
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                    child: Center(
                        child: TextFormField(
                      initialValue: exerciseSet.weight.toString(),
                      onChanged: (val) => exerciseSet.weight = int.parse(val),
                      onEditingComplete: () async {
                        await exerciseRecordService.saveExerciseRecord(
                            _username, parent, parent.exerciseRecId);
                      },
                    )),
                    width: width,
                    height: height))),
        Expanded(child: Center(child: Text('weight'))),
        Divider(),
        Expanded(
            child: Center(
                child: Container(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
          child: Center(
              child: TextFormField(
            initialValue: exerciseSet.reps.toString(),
            onChanged: (val) => exerciseSet.reps = int.parse(val),
            onEditingComplete: () async {
              await exerciseRecordService.saveExerciseRecord(
                  _username, parent, parent.exerciseRecId);
            },
          )),
          width: width,
          height: height,
        ))),
        Expanded(child: Center(child: Text('rep(s)')))
      ],
    );
  }

  FloatingActionButton _addExerciseRecordButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepOrangeAccent,
      onPressed: () async {
        String exerciseName =
            await _getExerciseName(context, createExerciseTextController);
        if (exerciseName == null || exerciseName.isEmpty) return;
        await exerciseRecordService.createExerciseRecord(
            _username, ExerciseRecord(exerciseName, _workoutId));
        setState(() {});
      },
    );
  }

  Future<String> _getExerciseName(
      BuildContext context, TextEditingController exerciseNameText) async {
    String exerciseName = await showDialog<String>(
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
                            Navigator.pop(context, exerciseNameText.text);
                          },
                          child: const Text('Ok')),
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
    exerciseNameText.clear();
    return exerciseName;
  }
}
