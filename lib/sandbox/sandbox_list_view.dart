import 'package:flutter/material.dart';
import 'package:tokyo_mobile/components/dynamic_text_field.dart';

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

class StatefulListView extends StatefulWidget {
  @override
  _ItemListView createState() {
    return _ItemListView();
  }
}

class _ItemListView extends State<StatefulListView> {
  List<DynamicTextField> itemRows = [];

  _ItemListView() {
    this.itemRows.add(DynamicTextField("To be changed"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            child: Center(child: DynamicTextField(itemRows[i].value)),
            onLongPress: () {
              setState(() {});
            },
            onDoubleTap: () {
              for (DynamicTextField dtf in itemRows) {
                print(dtf.value);
              }
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
            itemRows.add(DynamicTextField("Needs to be changed"));
          });
        },
      ),
    );
  }
}
