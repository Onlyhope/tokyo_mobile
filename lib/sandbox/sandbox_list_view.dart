import 'package:flutter/material.dart';

class SandboxListView extends StatelessWidget {
  static const String _title = 'Sandboxing List View';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: Scaffold(
            appBar: AppBar(title: const Text(_title)),
            body: StatefulListView()));
  }
}

// Actual Implementation

class _ItemRow extends StatefulWidget {

  String value;

  _ItemRow(String value) {
    this.value = value;
  }

  @override
  _ItemRowState createState() {
    return _ItemRowState(value);
  }
}

class _ItemRowState extends State<_ItemRow> {

  String value;
  Widget valueWidget;


  _ItemRowState(String value) {
    this.value = value;
    this.valueWidget = _valueDisplay(value);
  }

  _valueDisplay(String value) {
    return new GestureDetector(
      child: Text(value),
      onTap: () {
        print("Tapped value display: " + this.value);
        setState(() {
          this.valueWidget = _valueEdit(value);
        });
      },
    );
  }

  _valueEdit(String value) {
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

class StatefulListView extends StatefulWidget {
  @override
  _ItemListView createState() {
    return _ItemListView();
  }
}

class _ItemListView extends State<StatefulListView> {

  List<_ItemRow> itemRows = [];

  _ItemListView() {
    this.itemRows.add(new _ItemRow("To be changed"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            child: Center(
                child: _ItemRow(itemRows[i].value)
            ),
            onLongPress: () {
              setState(() {
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, int i) {
          return Divider();
        },
        itemCount: itemRows.length,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
        onPressed: () {
            setState(() {
              itemRows.add(new _ItemRow("Needs to be changed"));
            });
        },
      ),

    );
  }
}
