import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];

  TextEditingController controller = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  /// LOAD
  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tasks');

    if (data != null) {
      List decoded = jsonDecode(data);
      tasks = decoded.map((e) => Task.fromMap(e)).toList();
      filteredTasks = tasks;
      setState(() {});
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List mapped = tasks.map((e) => e.toMap()).toList();
    prefs.setString('tasks', jsonEncode(mapped));
  }

  /// ADD TASK
  void addTask(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      tasks.add(Task(title: text));
      filteredTasks = tasks;
    });

    saveTasks();
  }


  
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      filteredTasks = tasks;
    });
    saveTasks();
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    saveTasks();
  }

 
  void clearAllTasks() {
    setState(() {
      tasks.clear();
      filteredTasks.clear();
    });
    saveTasks();
  }

  /// ADD / EDIT SHEET
  void openTaskSheet({int? index}) {
    if (index != null) {
      controller.text = tasks[index].title;
    } else {
      controller.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                index == null ? "Add Task" : "Edit Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Enter task...",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                    addTask(controller.text);
                  
                  Navigator.pop(context);
                },
                // child: Text(index == null ? "Add" : "Update"),
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    foreground:
                        Paint()
                          ..color = Colors.white
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.8
                        ,
                    letterSpacing: 1.7,
                   
                  
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do App"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.delete_sweep), onPressed: clearAllTasks),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => openTaskSheet(),
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
      
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt, size: 80, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            "No tasks found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];

                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            onLongPress: () => openTaskSheet(index: index),

                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (_) => toggleTask(index),
                            ),

                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                decoration:
                                    task.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                              ),
                            ),

                            subtitle: Text(
                              task.isDone ? "Completed" : "Pending",
                              style: TextStyle(
                                color:
                                    task.isDone ? Colors.green : Colors.orange,
                              ),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                               
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteTask(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
