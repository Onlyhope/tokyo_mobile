import 'package:tokyo_mobile/models/personal_record.dart';

class UserProfile {
  String username;
  int height; // in millimeters
  int weight; // in grams
  int age;
  PersonalRecord pr;

  UserProfile({this.username, this.height, this.weight, this.age, this.pr});
}
