import 'package:hive_flutter/hive_flutter.dart';

class TodoDataBase {
  List todoList = [];

  final _myBox = Hive.box('myBox');

  TodoDataBase() {
    if (_myBox.get('TODOLIST') == null || _myBox.get('TODOLIST').isEmpty) {
      // Add default tasks
      todoList = [
        ['Add ToDo', false],
        ['Code a Project', false]
      ];
      _myBox.put('TODOLIST', todoList);
    } else {
      todoList = List.from(_myBox.get('TODOLIST'));
    }
  }

  void addTodo(List todo) {
    todoList.insert(0, todo);  // Insert new task at the beginning
    sortTodoList();  // Sort the list
    _myBox.put('TODOLIST', todoList);
  }

  void removeTodo(int index) {
    todoList.removeAt(index);
    _myBox.put('TODOLIST', todoList);
  }

  void updateTodoStatus(int index, bool status) {
    todoList[index][1] = status;
    sortTodoList();  // Sort the list
    _myBox.put('TODOLIST', todoList);
  }

  void clearTodo() {
    todoList.clear();
    _myBox.put('TODOLIST', todoList);
  }

  List getTodo() {
    return List.from(_myBox.get('TODOLIST'));
  }

  void updateHive() {
    _myBox.put('TODOLIST', todoList);
  }

  void sortTodoList() {
    todoList.sort((a, b) => a[1] ? 1 : -1);  // Move completed tasks to the bottom
  }
}
