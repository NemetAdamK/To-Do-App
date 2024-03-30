import 'package:hive/hive.dart';

class ToDoDataBase {

  List toDoList = [];

  final _box = Hive.openBox('box');

  void createInitialData() {
    toDoList = [
      ["First task" , false],
      ["second tas", false],
    ];
  }

  Future<void> loadData() async {
    final box = await _box;
    toDoList = box.get("TODOLIST", defaultValue: []);
  }

  Future<void> updateData() async {
    final box = await _box;
    await box.put("TODOLIST", toDoList);
  }
}