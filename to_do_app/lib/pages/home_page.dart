import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/dialog_box.dart';
import 'package:to_do_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  ToDoDataBase db = ToDoDataBase();

@override
  void initState() {
    super.initState();
    loadDataIfNeeded();
  }

  void loadDataIfNeeded() async {
  final box = await Hive.openBox('box');
  setState(() {
    if (box.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  });
}
final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateData();
  }

  void createNewTask() {
    showDialog(
      context: context, 
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
}
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text("TO DO"),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        elevation: 0, // Remove shadow from top bar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),

        child: Icon(
          Icons.add),
          backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged: (value)=> checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
           );
        },
      )
      ,
    );
  }
}