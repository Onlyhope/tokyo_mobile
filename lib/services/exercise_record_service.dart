import 'dart:convert';

import 'package:http/http.dart';
import 'package:tokyo_mobile/models/exercise_record.dart';

class ExerciseRecordService {
  static const String _baseUrl = 'http://167.71.181.19:3050';

  Future<List<ExerciseRecord>> fetchExerciseRecords(String username) async {
    final String fetchExerciseRecordsUrl =
        _baseUrl + '/users/$username/exercise-records/';
    Response response = await get(fetchExerciseRecordsUrl);

    List<ExerciseRecord> exerciseRecords = [];
    var data = json.decode(response.body) as List;
    List<ExerciseRecord> exRecords = [];
    for (dynamic record in data) {
      exRecords.add(ExerciseRecord.fromJson(record));
    }

    print('Response Status: ${response.statusCode}');
    print(exRecords);

    return exRecords;
  }

  Future<int> createExerciseRecord(String username, ExerciseRecord exerciseRecord) async {
    final String createExerciseRecordsUrl =
        _baseUrl + '/users/$username/exercise-records/';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Response response = await post(createExerciseRecordsUrl,
        headers: headers, body: jsonEncode(exerciseRecord));

    print('Post response status code: ${response.statusCode}');

    return response.statusCode;
  }

  Future<int> saveExerciseRecord(String username, ExerciseRecord exerciseRecord, String id) async {
    final String saveExerciseRecordUrl =
        _baseUrl + '/users/$username/exercise-records/$id';
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Response response = await post(saveExerciseRecordUrl,
        headers: headers, body: jsonEncode(exerciseRecord));

    return response.statusCode;
  }

  Future<int> deleteExerciseRecord(String username, String id) async {
    final String deleteExerciseRecordsUrl =
        _baseUrl + '/users/$username/exercise-records/$id';

    Response response = await delete(deleteExerciseRecordsUrl);

    return response.statusCode;
  }
}
