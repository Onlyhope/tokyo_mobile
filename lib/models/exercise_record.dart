import 'exercise_set.dart';

class ExerciseRecord {

  int exerciseRecId;
  String exerciseName;
  List<ExerciseSet> exerciseSets;

}

/*
Exercise Record is the Observable
The widget is the Observer

Exercise Record adds a refrence to the Observer
Change occurs in Exercise Record -> Updates what the observer sees

ExerciseRecordListView is the widget

ExerciseRecordListView contains List<ExerciseRecord>
ExerciseRecordView contains ExerciseRecord

*/
