import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubmitWorkScreen extends StatefulWidget {
  final int workId;
  final int workerId;
  final String taskTitle;

  const SubmitWorkScreen({
    Key? key,
    required this.workId,
    required this.workerId,
    required this.taskTitle,
  }) : super(key: key);

  @override
  State<SubmitWorkScreen> createState() => _SubmitWorkScreenState();
}

class _SubmitWorkScreenState extends State<SubmitWorkScreen> {
  final TextEditingController _submission = TextEditingController();

  Future<void> submitWork() async {
    var url = Uri.parse('http://10.0.2.2/wtms/submit_work.php');
    var response = await http.post(url, body: {
      'work_id': widget.workId.toString(),
      'worker_id': widget.workerId.toString(),
      'submission_text': _submission.text,
    });

    if (response.statusCode == 200 && response.body.contains('success')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Work Submitted")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit Work")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Task: ${widget.taskTitle}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextField(
              controller: _submission,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Your Work Details",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitWork,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
