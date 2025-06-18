import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'edit_submission_screen.dart';

class SubmissionHistoryScreen extends StatefulWidget {
  final int workerId;

  const SubmissionHistoryScreen({Key? key, required this.workerId}) : super(key: key);

  @override
  State<SubmissionHistoryScreen> createState() => _SubmissionHistoryScreenState();
}

class _SubmissionHistoryScreenState extends State<SubmissionHistoryScreen> {
  List<dynamic> submissions = [];

  Future<void> fetchSubmissions() async {
    final url = Uri.parse('http://10.0.2.2/wtms/get_submissions.php');
    final response = await http.post(url, body: {
      'worker_id': widget.workerId.toString(),
    });

    if (response.statusCode == 200) {
      setState(() {
        submissions = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load submissions")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submission History")),
      body: submissions.isEmpty
          ? Center(child: Text("No submissions found."))
          : ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final sub = submissions[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(sub['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text("Submitted at: ${sub['submitted_at']}"),
                        SizedBox(height: 4),
                        Text("Submission: ${sub['submission_text']}"),
                      ],
                    ),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditSubmissionScreen(
                            submissionId: int.parse(sub['id']),
                            originalText: sub['submission_text'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
