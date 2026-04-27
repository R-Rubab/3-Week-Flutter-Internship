import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week3_task_manager/core/theme/theme_provider.dart';
import 'package:week3_task_manager/presentation/screens/login_screen.dart';
import '../../data/models/task_model.dart';
import '../../data/datasource/local_storage.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];
  TextEditingController controller = TextEditingController();
  List<TaskModel> filteredTasks = [];
  List<TaskModel> trashTasks = [];
  String selectedTime = "";
  String selectedDate = "";
  int selectedIndex = 0;
  List<TaskModel> backupTasks = [];
  bool isFabOpen = false;
  bool showOnlyIncomplete = false;
  TextEditingController searchController = TextEditingController();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    searchController.addListener(() {
      setState(() {});
    });
  }
  // ================= Tasks =================

  void _loadTasks() async {
    tasks = await LocalStorage.getTasks();
    filteredTasks = tasks;

    setState(() {});
  }

  void _saveTasks() async {
    await LocalStorage.saveTasks(tasks);
  }
 
 void _addTask(String text) {
    if (text.trim().isEmpty || selectedTime.isEmpty || selectedDate.isEmpty)
      return;

    setState(() {
      tasks.add(TaskModel(title: text, time: selectedTime, date: selectedDate));
      filteredTasks = tasks;
    });

    controller.clear();
    selectedTime = "";
    selectedDate = "";

    _saveTasks();
  }

  void _editTask(int index, String newText) {
    if (newText.trim().isEmpty) return;

    setState(() {
      tasks[index] = TaskModel(
        title: newText,
        time: tasks[index].time,
        date: tasks[index].date,
        isDone: tasks[index].isDone,
      );

      filteredTasks = tasks;
    });

    _saveTasks();
  }

  void _deleteTask(int index) {
    final removedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
      filteredTasks = tasks;
    });

    _saveTasks();

    // SNACKBAR (UNDO)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task deleted"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              tasks.insert(index, removedTask);
              trashTasks.add(removedTask);
              filteredTasks = tasks;
            });
            _saveTasks();
          },
        ),
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
    _saveTasks();
  }


  void _searchTasks(String query) {
    setState(() {
      filteredTasks =
          tasks
              .where(
                (task) =>
                    task.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  void _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text("Delete All Tasks?"),
            ],
          ),
          content: Text("Are you sure you want to delete all tasks?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final backup = List<TaskModel>.from(tasks);

    // 🗑️ CLEAR
    setState(() {
      tasks.clear();
      filteredTasks.clear();
    });

    _saveTasks();

    // 🔄 SNACKBAR UNDO
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("All tasks deleted"),
        duration: Duration(seconds: 4),

        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              tasks = backup;
              filteredTasks = backup;
            });
            _saveTasks();
          },
        ),
      ),
    );
  }
  
  // ================= PICKERS =================

  Future<void> _pickTime(StateSetter setModal) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setModal(() => selectedTime = picked.format(context));
    }
  }

  Future<void> _pickDate(StateSetter setModal) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final day =
          ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][picked.weekday - 1];

      setModal(() {
        selectedDate = "$day ${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }



  // ================= UI HELPERS =================

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                49,
                16,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Task",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Enter task...",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),

                  // TIME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime.isEmpty ? "No time" : "⏰ $selectedTime",
                      ),
                      TextButton(
                        onPressed: () => _pickTime(setModal),
                        child: Text("Pick Time"),
                      ),
                    ],
                  ),

                  // DATE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate.isEmpty ? "No date" : "📅 $selectedDate",
                      ),
                      TextButton(
                        onPressed: () => _pickDate(setModal),
                        child: Text("Pick Date"),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      _addTask(controller.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openEditSheet(int index) {
    controller.text = tasks[index].title;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            40,
            16,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              TextField(
                controller: controller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  _editTask(index, controller.text);
                  Navigator.pop(context);
                },
                child: Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }

  
    // ================= Widgets =================

  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;

    String name = "User";

    if (user != null && user.email != null) {
      name = user.email!.split("@")[0]; // 👈 ali@gmail.com → ali
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello $name 👋",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text("Manage your daily tasks", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFabItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(label, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            heroTag: label,
            onPressed: onTap,
            child: Icon(icon),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    int completed = tasks.where((t) => t.isDone).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statCard("Total", tasks.length, Colors.blue),
        _statCard("Done", completed, Colors.green),
        _statCard("Pending", tasks.length - completed, Colors.orange),
      ],
    );
  }

  Widget _statCard(String title, int count, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text("$count", style: TextStyle(fontSize: 18, color: color)),
            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Manager",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "Stay organized ✨",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),

        actions: [
          // 🗑️ CLEAR ALL
          IconButton(
            icon: Icon(Icons.delete_sweep_rounded),
            tooltip: "Clear All",
            onPressed: _clearAll,
          ),

          // 🌙 DARK MODE TOGGLE (OPTIONAL 🔥)
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: () {
              // toggle theme (if using provider)
            },
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //  ADD TASK
          if (isFabOpen)
            _buildFabItem(
              icon: Icons.add_task,
              label: "Add Task",
              onTap: _openAddTaskSheet,
            ),

          //  TRASH
          if (isFabOpen)
            _buildFabItem(
              icon: Icons.delete_outline,
              label: "Trash",
              onTap: () {
                // navigate to trash
              },
            ),

          // SEARCH (optional)
          if (isFabOpen)
            _buildFabItem(icon: Icons.search, label: "Search", onTap: () {}),

          SizedBox(height: 10),

          // MAIN FAB
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isFabOpen = !isFabOpen;
              });
            },
            child: Icon(isFabOpen ? Icons.close : Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                ),
              ),
              accountName: Text(
                "Welcome 👋",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? "No Email",
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
              ),
            ),

         
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),

            SwitchListTile(
              title: Text("Dark Mode"),
              secondary: Icon(Icons.dark_mode),
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (value) {
                context.read<ThemeProvider>().toggleTheme(value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? "Dark Mode ON 🌙" : "Light Mode ☀️"),
                  ),
                );
              },
            ),

           
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);

                _showSnack("Settings coming soon!");
              },
            ),

          
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: "Task Manager Pro",
                  applicationVersion: "1.0.0",
                  applicationLegalese: "© 2026 Your Name",
                );
              },
            ),

            Spacer(),

          
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
            ),

            SizedBox(height: 10),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            //  SEARCH 
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor.withValues(alpha: 0.6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: TextField(
                controller: searchController,
                onChanged: _searchTasks,

                style: TextStyle(fontSize: 14),

                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  hintStyle: TextStyle(color: Colors.grey),

                  //  ICON
                  prefixIcon: Icon(Icons.search_rounded),

                  // CLEAR BUTTON
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              _searchTasks("");
                              setState(() {});
                            },
                          )
                          : null,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    // borderSide: BorderSide.none,
                  ),

                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       padding: EdgeInsets.all(13),
            //       decoration: BoxDecoration(
            //         // color: Colors.white,
            //         border: Border.all(
            //           color: const Color.fromARGB(255, 118, 118, 118),
            //         ),
            //         borderRadius: BorderRadius.all(Radius.circular(15)),
            //       ),
            //       child: Text(
            //         'Incomplete Only',
            //         style: TextStyle(fontSize: 15),
            //       ),
            //     ),
            //     SizedBox(width: 25),
            //     Text('0 Pending', style: TextStyle(fontSize: 14)),
            //   ],
            // ),
            SizedBox(height: 8),
            Text(
              "Task Schedule",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            ),
         
            SizedBox(
              height: 95,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = selectedIndex == index;

                  final dayName =
                      [
                        "Mon",
                        "Tue",
                        "Wed",
                        "Thu",
                        "Fri",
                        "Sat",
                        "Sun",
                      ][date.weekday - 1];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },

                    child: AnimatedContainer(
                      // width: 57,
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),

                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purpleAccent,
                                  ],
                                )
                                : LinearGradient(
                                  colors: [
                                    Colors.deepPurple.withValues(alpha: 0.23),
                                    Colors.purpleAccent.withValues(alpha: 0.23),
                                  ],
                                ),

                        color: isSelected ? null : Theme.of(context).cardColor,

                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: Colors.deepPurple.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                                : [],
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color!
                                          .withValues(alpha: 0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "${date.day}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color!
                                          .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),

            // 📋 Task LIST
            Container(
              height: 365,
              decoration: BoxDecoration(
                // color: Colors.white,
                border: Border.all(
                  color:
                      isDarkMode
                          ? const Color.fromARGB(255, 222, 221, 221)
                          : const Color.fromARGB(255, 194, 191, 191),
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child:
                  filteredTasks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.task_alt, size: 80, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              "No tasks yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Tap + to add your first task",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];

                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                [
                                  "Monday",
                                  "Tuesday",
                                  "Wednesday",
                                  "Thursday",
                                  "Friday",
                                  "Saturday",
                                  "Sunday",
                                ][DateTime.now().weekday - 1],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              _buildStats(),
                              TaskTile(
                                task: task,
                                onDelete: () => _deleteTask(tasks.indexOf(task)),
                                onToggle: () => _toggleTask(tasks.indexOf(task)),
                                onEdit:
                                    () => _openEditSheet(tasks.indexOf(task)),
                              ),
                            ],
                          );
                        },
                      ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                "⏰ Current Time: ${DateTime.now().hour}:${DateTime.now().minute}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
