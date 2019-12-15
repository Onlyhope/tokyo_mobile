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

    exerciseRecordService
        .fetchExerciseRecords(widget.username)
        .then((exerciseRecords) {
      setState(() {
        _exerciseRecords = exerciseRecords;
      });
    });
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
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final ExerciseRecord exerciseRecord = _exerciseRecords[index];
          return Dismissible(
            key: Key(exerciseRecord.hashCode.toString()),
            child: _displayExerciseRecords(index),
            onDismissed: (direction) async {
              int status = await exerciseRecordService.deleteExerciseRecord(
                  _username, _exerciseRecords[index].exerciseRecId);
              if (status >= 300) {
                print('Error; $status');
              } else if (status >= 200) {
                await _updateExerciseRecords();
              } else {
                print('Illegal state: $status');
              }
            },
          );
        },
        itemCount: _exerciseRecords.length,
        shrinkWrap: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () async {
          String exerciseName =
              await _getExerciseName(context, createExerciseTextController);
          if (exerciseName == null) return;

          int status = await exerciseRecordService.createExerciseRecord(
              _username, ExerciseRecord(exerciseName, _workoutId));
          if (status >= 300) {
            print('Error: $status');
          } else if (status >= 200) {
            await _updateExerciseRecords();
          } else {
            print('Illegal State: $status');
          }
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
            title: Text('${exerciseRecord.nameAndCreatedDate()}'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add a set',
              color: Colors.deepOrangeAccent,
              onPressed: () async {
                ExerciseSet exerciseSet = ExerciseSet(0, 0);
                if (exerciseRecord.exerciseSets.isNotEmpty) {
                  ExerciseSet lastSet = exerciseRecord.exerciseSets.last;
                  exerciseSet.weight = lastSet.weight;
                  exerciseSet.reps = lastSet.reps;
                }
                exerciseRecord.exerciseSets.add(exerciseSet);
                int status = await exerciseRecordService.saveExerciseRecord(
                    _username, exerciseRecord, exerciseRecord.exerciseRecId);

                if (status >= 300) {
                  print('Error: $status');
                } else if (status >= 200) {
                  _exerciseRecords[recordIndex] =
                      await exerciseRecordService.fetchExerciseRecord(
                          _username, exerciseRecord.exerciseRecId);
                  setState(() {});
                } else {
                  print('Illegal State: $status');
                }
              },
            ),
            onLongPress: () async {
              String exerciseName =
                  await _getExerciseName(context, createExerciseTextController);
              if (exerciseName == null) return;
              exerciseRecord.exerciseName = exerciseName;
              int status = await exerciseRecordService.saveExerciseRecord(
                  _username, exerciseRecord, exerciseRecord.exerciseRecId);
              if (status >= 300) {
                print('Error: $status');
              } else if (status >= 200) {
                _exerciseRecords[recordIndex] =
                    await exerciseRecordService.fetchExerciseRecord(
                        _username, exerciseRecord.exerciseRecId);
                setState(() {});
              } else {
                print('Illegal State: $status');
              }
            },
            onTap: () {
              print(exerciseRecord);
            }),
        ListView.separated(
          itemBuilder: (BuildContext context, int setIndex) {
            final ExerciseSet exerciseSet =
                exerciseRecord.exerciseSets[setIndex];

            return Dismissible(
              key: Key(exerciseSet.hashCode.toString()),
              child: _displaySet(context, recordIndex, setIndex),
              onDismissed: (direction) async {
                ExerciseSet exerciseSetToRemove =
                    exerciseRecord.exerciseSets[setIndex];
                exerciseRecord.exerciseSets.removeAt(setIndex);
                int status = await exerciseRecordService.saveExerciseRecord(
                    _username, exerciseRecord, exerciseRecord.exerciseRecId);
                if (status >= 300) {
                  print('Error: $status');
                  print('Adding back removed exercised');
                  exerciseRecord.exerciseSets.insert(setIndex, exerciseSetToRemove);
                } else if (status >= 200) {
                  _exerciseRecords[recordIndex] =
                  await exerciseRecordService.fetchExerciseRecord(
                      _username, exerciseRecord.exerciseRecId);
                  setState(() {});
                } else {
                  print('Illegal state: $status');
                }
              },
              background: Container(color: Colors.red),
            );
          },
          separatorBuilder: (BuildContext context, int i) => Divider(),
          itemCount: exerciseRecord.exerciseSets.length,
          shrinkWrap: true,
        ),
        Divider()
      ],
    );
  }

  Widget _displaySet(BuildContext context, int recordIndex, int setIndex) {
    ExerciseSet exerciseSet =
        _exerciseRecords[recordIndex].exerciseSets[setIndex];
    final double width = 70;
    final double height = 35;
    return Row(
      children: <Widget>[
        Expanded(
            child: Center(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                        child: TextFormField(
                      initialValue: exerciseSet.weight.toString(),
                      onChanged: (val) {
                        exerciseSet.weight = int.parse(val);
                      },
                      onEditingComplete: () async {
                        ExerciseRecord exerciseRecord =
                            _exerciseRecords[recordIndex];
                        int status =
                            await exerciseRecordService.saveExerciseRecord(
                                _username,
                                exerciseRecord,
                                exerciseRecord.exerciseRecId);
                        if (status >= 300) {
                          print('Error: $status');
                        } else if (status >= 200) {
                          await _updateExerciseRecords();
                        } else {
                          print('Illegal State: $status');
                        }
                      },
                    )),
                    width: width,
                    height: height))),
        Expanded(child: Center(child: Text('weight'))),
        Divider(),
        Expanded(
            child: Center(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                        child: TextFormField(
                      initialValue: exerciseSet.reps.toString(),
                      onChanged: (val) {
                        exerciseSet.reps = int.parse(val);
                      },
                      onEditingComplete: () async {
                        ExerciseRecord exerciseRecord =
                            _exerciseRecords[recordIndex];
                        int status =
                            await exerciseRecordService.saveExerciseRecord(
                                _username,
                                exerciseRecord,
                                exerciseRecord.exerciseRecId);
                        if (status >= 300) {
                          print('Error: $status');
                        } else if (status >= 200) {
                          await _updateExerciseRecords();
                        } else {
                          print('Illegal State: $status');
                        }
                      },
                    )),
                    width: width,
                    height: height))),
        Expanded(child: Center(child: Text('rep(s)')))
      ],
    );
  }

  Future _updateExerciseRecords() async {
    List<ExerciseRecord> exerciseRecords =
        await exerciseRecordService.fetchExerciseRecords(_username);
    setState(() {
      _exerciseRecords = exerciseRecords;
    });
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
