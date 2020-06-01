import 'package:flutter/material.dart';
import 'package:tokyo_mobile/services/exercise_record_service.dart';

import '../models/exercise_record.dart';
import '../models/exercise_set.dart';

class ExerciseRecordListPage extends StatefulWidget {
  final String username;

  ExerciseRecordListPage({@required this.username});

  @override
  ExerciseRecordListPageState createState() {
    return ExerciseRecordListPageState();
  }
}

enum ExRecOption { delete, info }

class ExerciseRecordListPageState extends State<ExerciseRecordListPage> {
  static final String _title = 'Workout Log';
  final ExerciseRecordService exerciseRecordService = ExerciseRecordService();
  final TextEditingController createExerciseTextController =
      TextEditingController();

  DateTime _today;
  DateTime _startOfDay;
  DateTime _endOfDay;
  String _username;
  String _workoutId;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _workoutId = null;
    _today = DateTime.now().toLocal();
    _startOfDay = DateTime(_today.year, _today.month, _today.day, 0, 0);
    _endOfDay = _startOfDay.add(Duration(days: 1));
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
      body: ListView(
        children: <Widget>[
          Center(
              child: Padding(

            child: Text('${_today.month}-${_today.day}-${_today.year}'),
            padding: EdgeInsets.only(top: 10.0),
          )),
          Divider(),
          FutureBuilder<List<ExerciseRecord>>(
            future: exerciseRecordService.fetchExerciseRecords(
                _username, _startOfDay, _endOfDay),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print("Does snapshot have error? ${snapshot.hasError}");
              print("Snapshot Error: ${snapshot.error}");

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.done:
                  List<ExerciseRecord> exerciseRecords = snapshot.data;
                  if (_workoutId == null && exerciseRecords.isNotEmpty) {
                    _workoutId = exerciseRecords.first.workoutId;
                  }
                  return _displayExerciseRecordList(exerciseRecords);
              }

              return Container();
            },
          )
        ],
        shrinkWrap: true
      ),
      floatingActionButton: _addExerciseRecordButton(),
    );
  }

  Widget _displayExerciseRecordList(List<ExerciseRecord> exerciseRecords) {
    print('Exercise Records: $exerciseRecords');
    if (exerciseRecords == null) return Container();
    return ListView.builder(
      itemBuilder: (context, index) {
        return _displayAnExerciseRecord(exerciseRecords[index]);
      },
      itemCount: exerciseRecords.length,
      shrinkWrap: true,
      primary: false
    );
  }

  Widget _displayAnExerciseRecord(ExerciseRecord exerciseRecord) {
    print('Exercise Record to display: $exerciseRecord');
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3.0,
      child: Column(
        children: <Widget>[
          ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              leading: FlutterLogo(),
              title: Text('${exerciseRecord.exerciseName}'),
              trailing: PopupMenuButton<ExRecOption>(
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                onSelected: (ExRecOption result) {
                  switch (result) {
                    case ExRecOption.info:
                      {
                        print("Option info");
                      }
                      break;
                    case ExRecOption.delete:
                      {
                        _deleteExerciseRecord(
                            _username, exerciseRecord.exerciseRecId);
                      }
                      break;
                    default:
                      {
                        print("Unknown case...");
                      }
                      break;
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<ExRecOption>>[
                  const PopupMenuItem<ExRecOption>(
                      value: ExRecOption.info,
                      child: ListTile(
                        leading: Icon(Icons.info),
                        title: Text('Exercise Info'),
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                      )),
                  const PopupMenuItem<ExRecOption>(
                      value: ExRecOption.delete,
                      child: ListTile(
                        leading: Icon(Icons.clear),
                        title: Text('Remove'),
                        dense: true,
                        contentPadding: EdgeInsets.all(0),
                      ))
                ],
              )),
          Column(
            children: displayDismissibleSets(exerciseRecord),
          ),
          Center(
              child: IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Add a set',
            onPressed: () async => await addSet(exerciseRecord),
            color: Colors.deepOrange,
          ))
        ],
      ),
    );
  }

  Future addSet(ExerciseRecord exerciseRecord) async {
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
  }

  Future _deleteExerciseRecord(String username, String exRecId) async {
    await exerciseRecordService.deleteExerciseRecord(username, exRecId);
    setState(() {});
  }

  List<Widget> displayDismissibleSets(ExerciseRecord exerciseRecord) {
    return exerciseRecord.exerciseSets.asMap().entries.map((entry) {
      ExerciseSet set = entry.value;
      return Dismissible(
        key: Key("${set.hashCode}-${entry.key}"),
        child: _displaySet(set, exerciseRecord),
        onDismissed: (direction) async {
          await exerciseRecordService.saveExerciseRecord(
              _username, exerciseRecord, exerciseRecord.exerciseRecId);
          setState(() {});
        },
        background: Container(color: Colors.red),
      );
    }).toList();
  }

  Widget _displaySet(ExerciseSet exerciseSet, ExerciseRecord parent) {
    final double width = 120;
    final double height = 45;
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
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (val) => exerciseSet.weight = int.parse(val),
                      onFieldSubmitted: (val) async {
                        await exerciseRecordService.saveExerciseRecord(
                            _username, parent, parent.exerciseRecId);
                      },
                    )),
                    width: width,
                    height: height))),
        Expanded(child: Center(child: Text('lb(s)'))),
        Expanded(
            child: Center(
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
                    child: Center(
                        child: TextFormField(
                      initialValue: exerciseSet.reps.toString(),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (val) => exerciseSet.reps = int.parse(val),
                      onFieldSubmitted: (val) async {
                        await exerciseRecordService.saveExerciseRecord(
                            _username, parent, parent.exerciseRecId);
                      },
                    )),
                    width: width,
                    height: height))),
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
        ExerciseRecord exerciseRecord =
            ExerciseRecord(exerciseName, _workoutId);
        exerciseRecord.exerciseSets.add(ExerciseSet(0, 0));
        await exerciseRecordService.createExerciseRecord(
            _username, exerciseRecord);
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
