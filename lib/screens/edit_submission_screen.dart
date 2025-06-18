import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSubmissionScreen extends StatefulWidget {
  final int submissionId;
  final String originalText;

  const EditSubmissionScreen({
    Key? key,
    required this.submissionId,
    required this.originalText,
  }) : super(key: key);

  @override
  State<EditSubmissionScreen> createState() => _EditSubmissionScreenState();
}

class _EditSubmissionScreenState extends State<EditSubmissionScreen> {
  late TextEditingController _submissionController;

  @override
  void initState() {
    super.initState();
    _submissionController = TextEditingController(text: widget.originalText);
  }

  Future<void> updateSubmission() async {
    var url = Uri.parse('http://10.0.2.2/wtms/edit_submission.php');
    var response = await http.post(url, body: {
      'submission_id': widget.submissionId.toString(),
      'submission_text': _submissionController.text,
    });

    if (response.statusCode == 200 && response.body.contains('success')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission updated")));
      Navigator.pop(context); // return to history screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Submission")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit your submission:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            TextField(
              controller: _submissionController,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter updated submission...",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateSubmission,
              child: Text("Update Submission"),
            ),
          ],
        ),
      ),
    );
  }
}
