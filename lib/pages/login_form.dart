import 'package:flutter/material.dart';
import 'package:tokyo_mobile/pages/dashboard.dart';
import 'package:tokyo_mobile/pages/signup_form.dart';
import 'package:tokyo_mobile/sandbox/sandbox_view.dart';

class LogInForm extends StatefulWidget {
  @override
  LogInFormState createState() {
    return LogInFormState();
  }
}

class LogInFormState extends State<LogInForm> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.email), labelText: 'Email'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Missing email";
                    }

                    if (!value.contains("@")) {
                      return "Not a valid email";
                    }

                    return null;
                  },
                  onChanged: (val) {
                    _username = val;
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
                  obscureText: true,
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
                                _goToDashboard(context, _username);
                              }
                            },
                          ),
                        ),
                        Spacer(flex: 1),
                        Expanded(
                          flex: 5,
                          child: RaisedButton(
                              child: Text('Sign Up'),
                              onPressed: () {
                                goToSignUp(context);
                              }),
                        )
                      ],
                    )),
                FloatingActionButton(
                  onPressed: () {
                    goToSandbox(context);
                  },
                )
              ],
            )));
  }
}

void goToSignUp(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
    return Scaffold(body: Center(child: SignUpForm()));
  }));
}

void _goToDashboard(BuildContext context, String username) {
  Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
    return Dashboard(username);
  }));
}

void goToSandbox(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute<void>(builder: (BuildContext context) {
    return Sandbox();
  }));
}
