import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';

class ExerciseRecordService {

  static const String _baseUrl = '167.71.181.19:3000';

  DateTime defaultStart = DateTime(1970, 1, 1);
  final logger = Logger();

  Future<List<ExerciseRecord>> fetchExerciseRecords(
      String username, DateTime from, DateTime to) async {
    Map<String, String> queryParams = {
      'createdFrom': (from ?? defaultStart).toUtc().toIso8601String(),
      'createdTo': (to ?? DateTime.now()).toUtc().toIso8601String()
    };

    Uri uri =
        Uri.http(_baseUrl, '/users/$username/exercise-records', queryParams);
    logger.v('Fetching exercises for $username ... $uri');
    Map<String, String> headers = defaultHeaders();

    Response response = await get(uri, headers: headers);
    logger.v('Response: ${response.body}');

    var data = json.decode(response.body) as List;
    List<ExerciseRecord> exRecords = [];
    for (dynamic record in data) {
      exRecords.add(ExerciseRecord.fromJson(record));
    }

    logger.v('Response Status: ${response.statusCode}');
    logger.v('Exercise Records: ${exRecords.toString()}');

    return exRecords;
  }

  Future<ExerciseRecord> fetchExerciseRecord(
      String username, String exRecId) async {
    Uri uri = Uri.http(_baseUrl, '/users/$username/exercise-records/$exRecId');
    logger.v('Fetching exercises for $username ... $uri');
    Map<String, String> headers = defaultHeaders();

    Response response = await get(uri, headers: headers);
    logger.v('Response: ${response.body}');

    return ExerciseRecord.fromJson(json.decode(response.body));
  }

  Future<int> createExerciseRecord(
      String username, ExerciseRecord exerciseRecord) async {
    final String createExerciseRecordsUrl =
        '$_baseUrl/users/$username/exercise-records/';

    Uri uri = Uri.http(_baseUrl, '/users/$username/exercise-records/');
    logger.v('Creating exercise with $username... $createExerciseRecordsUrl');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    Response response = await post(
        uri, headers: headers, body: jsonEncode(exerciseRecord));
    logger.v('Post response status code: ${response.statusCode}');

    return response.statusCode;
  }

  Future<int> saveExerciseRecord(
      String username, ExerciseRecord exerciseRecord, String id) async {

    Uri uri = Uri.http(_baseUrl, '/users/$username/exercise-records/$id');
    Map<String, String> headers = defaultHeaders();

    Response response = await put(uri,
        headers: headers, body: jsonEncode(exerciseRecord));

    return response.statusCode;
  }

  Future<int> deleteExerciseRecord(String username, String id) async {
    Uri uri = Uri.http(_baseUrl, '/users/$username/exercise-records/$id');
    Response response = await delete(uri);
    return response.statusCode;
  }

  List jsonToExerciseRecords(var exerciseRecordsAsJson) {
    if (exerciseRecordsAsJson == null) return [];
    var exerciseRecords = [];
    return exerciseRecords;
  }

  Map<String, String> defaultHeaders() {
    return {
      HttpHeaders.contentTypeHeader: 'application/json'
    };
  }
}
