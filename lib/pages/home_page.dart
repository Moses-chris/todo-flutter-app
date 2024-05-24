import 'package:flutter/material.dart';
import 'package:myapp/data/database.dart';
import 'package:myapp/widgets/todo_list.dart';
//import 'package:myapp/database/todo_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoDataBase db = TodoDataBase();  // Initialize the database

  String newTaskName = '';

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          autofocus: true,
          style: const TextStyle(fontSize: 25),  // Set the font size here
          onChanged: (value) {
            setState(() {
              newTaskName = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (newTaskName.isNotEmpty) {
                  db.addTodo([newTaskName, false]);  // Add task to the database
                }
              });
              Navigator.pop(context);
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.green),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 124, 109, 105),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Page'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(225, 44, 66, 78),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.blueGrey[500],
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) => TodoList(
          taskName: db.todoList[index][0],
          taskCompleted: db.todoList[index][1],
          onChanged: (value) => setState(() {
            db.todoList[index][1] = value;
            db.updateHive();
            db.updateTodoStatus(index, value!);  // Update the database
          }),
          onDelete: () => setState(() {
            db.removeTodo(index);  // Remove task from the database
          }),
        ),
      ),
    );
  }
}
