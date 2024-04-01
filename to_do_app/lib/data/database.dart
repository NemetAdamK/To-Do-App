import 'package:hive/hive.dart';
import 'package:to_do_app/model/quote.dart';

class ToDoDataBase {

  List toDoList = [];

  final _box = Hive.openBox('box');

  void createInitialData(List<Quote> quotes) {
    toDoList = quotes.map((quote) => [quote.text, false]).toList();
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