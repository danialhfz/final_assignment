import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'task_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Map worker;

  const ProfileScreen({Key? key, required this.worker}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text("Worker Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  worker['full_name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(height: 30, thickness: 1.2),
                buildInfoRow(Icons.badge, "ID", worker['id'].toString()),
                buildInfoRow(Icons.email, "Email", worker['email']),
                buildInfoRow(Icons.phone, "Phone", worker['phone']),
                buildInfoRow(Icons.home, "Address", worker['address']),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.task_alt),
                  label: Text("View Assigned Tasks"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskListScreen(
                          workerId: int.parse(worker['id']),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: Size(double.infinity, 48),
                  ),
                  onPressed: () => logout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
