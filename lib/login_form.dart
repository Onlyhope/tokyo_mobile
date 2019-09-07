import 'package:flutter/material.dart';

class LogInForm extends StatefulWidget {
  @override
  LogInFormState createState() {
    return LogInFormState();
  }
}

class LogInFormState extends State<LogInForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration:
                  InputDecoration(icon: Icon(Icons.email), labelText: 'Email'),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Missing email";
                }

                if (!value.contains("@")) {
                  return "Not a valid email";
                }

                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  icon: Icon(Icons.lock), labelText: 'Password'),
              validator: (String value) {
                if (value.isEmpty) {
                  return "Missing password";
                }

                return null;
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: RaisedButton(
                        child: Text('Login'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            // Process data
                          }
                        },
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 5,
                      child: RaisedButton(
                          child: Text('Register'), onPressed: () {}),
                    )
                  ],
                )),
          ],
        ));
  }
}
