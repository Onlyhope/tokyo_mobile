import 'package:flutter/material.dart';

class DynamicTextField extends StatefulWidget {

  final String value;

  DynamicTextField(String value) {
    this.value = value;
  }

  @override
  _DynamicTextFieldState createState() {
    return _DynamicTextFieldState(this.value);
  }
}

class _DynamicTextFieldState extends State<DynamicTextField> {

  String value;
  Widget valueWidget;

  _DynamicTextFieldState(var value) {
    this.value = value;
    this.valueWidget = _valueDisplay(value);
  }

  Widget _valueDisplay(val) {
    return new GestureDetector(
      child: Text(val),
      onLongPress: () {
        setState(() {
          this.valueWidget = _valueEdit(val);
        });
      },
    );
  }

  Widget _valueEdit(value) {
    return TextFormField(
      initialValue: value,
      onFieldSubmitted: (val) {
        setState(() {
          this.value = val;
          this.valueWidget = _valueDisplay(val);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return valueWidget;
  }

}