import 'package:flutter/material.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Todo List', home: new TodoList());
  }
}

class TodoTask {
  String name;
  bool isCompleted;
  NestedClass nested;

  TodoTask({this.name, this.isCompleted}) {
    nested = NestedClass(count: 0);
  }
}

class NestedClass {
  int count;

  NestedClass({this.count});
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<TodoTask> _todoItems = [];

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        return _buildTodoItem(index);
      },
      itemCount: _todoItems.length,
    );
  }

  Widget _buildTodoItem(int index) {
    return new ListTile(
      title: new Text(_todoItems[index].name),
      onTap: () {
        setState(() {
          _todoItems[index].name = "new value";
        });
      },
      onLongPress: () {
        for(var x in _todoItems) {
          print('${x.name} + ${x.nested.count}');
        }
        setState(() {
          _todoItems[index].nested.count++;
        });
      },
    );
  }

  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add(TodoTask(name: task, isCompleted: false)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Todo List')),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Add a new task')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
