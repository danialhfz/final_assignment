import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Map worker;

  const ProfileScreen({Key? key, required this.worker}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  final _formKey = GlobalKey<FormState>();

  Future<void> loadProfile() async {
    var url = Uri.parse("http://10.0.2.2/wtms/get_profile.php");
    var response = await http.post(url, body: {
      "worker_id": widget.worker['id'].toString(),
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _nameController.text = data['full_name'];
        _phoneController.text = data['phone'];
        _addressController.text = data['address'];
      });
    }
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse("http://10.0.2.2/wtms/update_profile.php");
      var response = await http.post(url, body: {
        "worker_id": widget.worker['id'].toString(),
        "full_name": _nameController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
      });

      var result = jsonDecode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Update failed")),
        );
      }
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.blueAccent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        SizedBox(height: 12),
                        Text("Worker ID: ${widget.worker['id']}", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  ),
                  SizedBox(height: 12),
                  Text("Phone", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) => value!.isEmpty ? 'Enter phone number' : null,
                  ),
                  SizedBox(height: 12),
                  Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _addressController,
                    validator: (value) => value!.isEmpty ? 'Enter address' : null,
                    maxLines: 2,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("Update Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    onPressed: updateProfile,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    onPressed: logout,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
