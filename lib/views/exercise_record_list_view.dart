import 'package:flutter/material.dart';

import 'models/exercise_record.dart';

class DynamicListView extends StatefulWidget {
  @override
  ExerciseRecordListView createState() {
    return ExerciseRecordListView();
  }
}

class ExerciseRecordListView extends State<DynamicListView> {

  List<ExerciseRecord> exerciseRecords = [];

  final TextEditingController eCtrl = new TextEditingController();

  Widget displayExerciseRecord(BuildContext context, int i) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.amber[600]
      ),
      height: 30,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(exerciseRecords[i].exercise_name),
            flex: 3,
          ),
          Expanded(
            child: Text(
                exerciseRecords[i].reps.toString() + " @ " +
                    exerciseRecords[i].weights.toString()),
            flex: 1
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Records'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onSubmitted: (text) {
              ExerciseRecord exRec = ExerciseRecord();
              exRec.exercise_name = text;
              exRec.reps = 5;
              exRec.weights = 135;
              exerciseRecords.add(exRec);
              eCtrl.clear();
              setState((){});
            },
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (BuildContext context, int i) => displayExerciseRecord(context, i),
                itemCount: exerciseRecords.length,
            )
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          print("Hello Aaron. You look beautiful!");
        },
      ),
    );
  }
}