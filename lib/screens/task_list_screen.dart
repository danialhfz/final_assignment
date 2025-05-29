import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'submit_work_screen.dart';

class TaskListScreen extends StatefulWidget {
  final int workerId;

  const TaskListScreen({Key? key, required this.workerId}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<dynamic> taskList = [];

  Future<void> fetchTasks() async {
    var url = Uri.parse('http://10.0.2.2/wtms/get_works.php');
    var response = await http.post(url, body: {
      'worker_id': widget.workerId.toString(),
    });

    if (response.statusCode == 200) {
      setState(() {
        taskList = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load tasks')));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Assigned Tasks")),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          final task = taskList[index];
          return ListTile(
            title: Text(task['title']),
            subtitle: Text("Due: ${task['due_date']}"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SubmitWorkScreen(
                    workId: int.parse(task['id']),
                    workerId: widget.workerId,
                    taskTitle: task['title'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
