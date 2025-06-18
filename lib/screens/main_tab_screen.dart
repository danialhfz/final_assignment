import 'package:flutter/material.dart';
import 'task_list_screen.dart';
import 'submission_history_screen.dart';
import 'profile_screen.dart';

class MainTabScreen extends StatefulWidget {
  final Map worker;

  const MainTabScreen({Key? key, required this.worker}) : super(key: key);

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabs = [
      TaskListScreen(workerId: int.parse(widget.worker['id'])),
      SubmissionHistoryScreen(workerId: int.parse(widget.worker['id'])),
      ProfileScreen(worker: widget.worker),
    ];

    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
