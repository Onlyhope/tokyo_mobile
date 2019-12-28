import 'package:tokyo_mobile/models/personal_record.dart';

class UserProfile {
  String username;
  int height; // in millimeters
  int weight; // in grams
  int age;
  PersonalRecords prs;

  UserProfile({this.username, this.height, this.weight, this.age, this.prs});
}
