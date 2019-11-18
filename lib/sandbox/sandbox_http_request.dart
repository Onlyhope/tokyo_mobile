import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpClientWidget extends StatelessWidget {
  static const String _title = "Http Client";
  static const String _baseUrl = 'http://167.71.181.19:3000';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: Scaffold(
          appBar: AppBar(title: const Text(_title)),
          body: Center(
            child: RaisedButton(
              child: Text("Send Request"),
              onPressed: () async {
                // Send Request
                Response response = await get(_baseUrl + '/users/abc/exercise-records/');
                print("Response Body: " + response.body);
              },
            ),
          ),
        ));
  }
}
