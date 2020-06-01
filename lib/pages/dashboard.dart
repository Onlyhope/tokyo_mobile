import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';
import 'package:tokyo_mobile/models/personal_record.dart';
import 'package:tokyo_mobile/models/user_profile.dart';
import 'package:tokyo_mobile/pages/exercise_record_list_page.dart';
import 'package:tokyo_mobile/pages/workout_calendar_overview.dart';
import 'package:tokyo_mobile/services/exercise_record_service.dart';
import 'package:tokyo_mobile/services/unit_converter.dart';
import 'package:uuid/uuid.dart';

class Dashboard extends StatefulWidget {
  final String username;

  Dashboard(this.username);

  @override
  DashboardState createState() {
    return DashboardState(username);
  }
}

class DashboardState extends State<Dashboard> {
  List<ExerciseRecord> _lastWorkout = [];
  ExerciseRecordService exerciseRecordService = ExerciseRecordService();
  UserProfile userProfile;
  String username;

  DashboardState(String username) {
    this.username = username;
  }

  @override
  void initState() {
    super.initState();

    PersonalRecords mockPrs = PersonalRecords(
        squat: UnitConverter.lbsToGrams(408),
        bench: UnitConverter.lbsToGrams(315),
        deadLift: UnitConverter.lbsToGrams(495));

    UserProfile mockUserProfile = UserProfile(
        age: 26,
        weight: UnitConverter.lbsToGrams(163),
        height: UnitConverter.inchesToMillimeters(65),
        username: username,
        prs: mockPrs);

    userProfile = mockUserProfile;

    _loadLastWorkout();
  }

  void _loadLastWorkout() async {
    
    DateTime now = DateTime.now();
    DateTime nowMinus60Days = now.subtract(Duration(days: 60));
    List<ExerciseRecord> exerciseRecords = await exerciseRecordService
        .fetchExerciseRecords(username, nowMinus60Days, now);

    ExerciseRecord mostRecentExerciseRecord = exerciseRecords.first;
    if (mostRecentExerciseRecord == null) return;
    String lastWorkoutId = mostRecentExerciseRecord.workoutId;

    List<ExerciseRecord> lastWorkouts = [];
    for (int i = 0; i < exerciseRecords.length; i++) {
      if (exerciseRecords[i].workoutId != lastWorkoutId) break;
        lastWorkouts.add(exerciseRecords[i]);
    }

    setState(() {
      _lastWorkout = lastWorkouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 8.0),
          PersonalRecordsView(prs: userProfile.prs),
          Divider(),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Center(
                  child: Text(
                'Last Workout',
                style: TextStyle(fontSize: 18.0),
              ))),
//          WorkoutRecordView(
//              workoutRecords: [lastWorkout], colorPool: [Colors.black38])
        ],
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      ),
      drawer: Drawer(
          child: ListView(children: [
        UserAccountsDrawerHeader(
          accountName: Text(userProfile.username),
          accountEmail: Text(userProfile.username),
          currentAccountPicture: CircleAvatar(
              child: Image(
                image: AssetImage('assets/avatars/avatar.png'),
                height: 50.0,
              ),
              backgroundColor: Colors.blue),
        ),
        InkWell(
          child: ListTile(
            title: Text('Workout Overview'),
            trailing: Icon(Icons.arrow_right),
          ),
          onTap: () {
            _goToExerciseOverview(context, userProfile.username);
          },
        ),
        InkWell(
          child: ListTile(
              title: Text('Weight Loss'), trailing: Icon(Icons.arrow_right)),
          onTap: () {
            print('Going to Weight Loss...');
          },
        ),
        InkWell(
          child: ListTile(
            title: Text('Graphs'),
            trailing: Icon(Icons.arrow_right),
          ),
          onTap: () {
            print('Going to graphs');
          },
        )
      ])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () {
          _goToWorkoutCreationPage(context, userProfile.username);
        },
      ),
    );
  }

  void _goToExerciseOverview(BuildContext context, String username) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return WorkoutCalendarOverview(username: username);
    }));
  }

  void _goToWorkoutCreationPage(BuildContext context, String username) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return ExerciseRecordListPage(username: username);
    }));
  }
}

class PersonalRecordsView extends StatelessWidget {
  final PersonalRecords prs;

  PersonalRecordsView({this.prs});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        ListTile(
          leading: SizedBox(
            child: Text('Squat'),
            width: 50.0,
          ),
          trailing: Text(UnitConverter.gramsToLbs(prs.squat).toString()),
          title: PrsProgressBar(25, 100),
          dense: true,
        ),
        ListTile(
            leading: SizedBox(
              child: Text('Bench'),
              width: 50.0,
            ),
            trailing: Text(UnitConverter.gramsToLbs(prs.bench).toString()),
            title: PrsProgressBar(50, 100),
            dense: true),
        ListTile(
          leading: SizedBox(
            child: Text('Deadlift'),
            width: 50.0,
          ),
          trailing: Text(UnitConverter.gramsToLbs(prs.deadLift).toString()),
          title: PrsProgressBar(45, 100),
          dense: true,
        )
      ],
    ));
  }
}

class PrsProgressBar extends StatelessWidget {
  final int currentValue;
  final int overallValue;

  PrsProgressBar(this.currentValue, this.overallValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LinearProgressIndicator(
        value: currentValue / overallValue,
      ),
      height: 12.0,
    );
  }
}
