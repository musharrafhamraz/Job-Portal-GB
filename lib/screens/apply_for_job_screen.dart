import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';
import 'package:jobfinder/widgets/main_button.dart';

class ApplyForJobScreen extends StatefulWidget {
  final String jobId;
  const ApplyForJobScreen({super.key, required this.jobId});

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isTimeFeasible = false;
  String? selectedResume;
  DateTime? availableDate;
  bool isUsingSignupResume = false;
  bool isUploading = false;
  final FirebaseServices firebaseServices = FirebaseServices();

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        isUploading = true;
      });

      // Assuming file picked is the resume.
      final file = result.files.single;
      final ref = FirebaseStorage.instance.ref().child('resumes/${file.name}');
      await ref.putData(file.bytes!);
      final url = await ref.getDownloadURL();

      setState(() {
        selectedResume = url;
        isUsingSignupResume = false; // Reset using signup resume
        isUploading = false;
      });
    }
  }

  Future<void> _submitApplication() async {
    if (coverLetterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    // Use the signup resume if selected
    if (isUsingSignupResume) {
      selectedResume = await firebaseServices.fetchUserResume();
      if (selectedResume == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No resume found for the current user.')),
        );
        return;
      }
    }

    // Ensure a resume is selected
    if (selectedResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload or select a resume.')),
      );
      return;
    }

    // Submit form data to Firebase or backend as required.
    // final applicationData = {
    //   'coverLetter': coverLetterController.text,
    //   'resumeUrl': selectedResume,
    //   'isTimeFeasible': isTimeFeasible,
    //   'availableDate': availableDate?.toIso8601String(),
    //   'candidateUID': FirebaseAuth.instance.currentUser!.uid,
    // };

    firebaseServices.applyForJob(
      availableDate: availableDate,
      coverLetter: coverLetterController.text,
      resumeUrl: selectedResume!,
      isTimeFeasible: isTimeFeasible,
      jobId: widget.jobId,
    );

    // Example: Print or send `applicationData`
    // print(applicationData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application submitted successfully.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Cover Letter',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: coverLetterController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your cover letter here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Resume',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                      onPress: _pickResume,
                      buttonTxt: const Text(
                        'Upload Resume',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(selectedResume != null
                      ? 'Resume Selected'
                      : 'No Resume Selected'),
                ),
              ],
            ),
            if (isUploading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Use my existing resume?'),
              value: isUsingSignupResume,
              onChanged: (bool? value) {
                setState(() {
                  isUsingSignupResume = value ?? false;
                  if (isUsingSignupResume) {
                    firebaseServices.fetchUserResume().then((url) {
                      setState(() {
                        selectedResume = url;
                      });
                    });
                  } else {
                    selectedResume = null; // Reset if unchecked
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Is the time feasible?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Yes, the timing is feasible'),
              value: isTimeFeasible,
              onChanged: (bool value) {
                setState(() {
                  isTimeFeasible = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Available Starting Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPress: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          availableDate = date;
                        });
                      }
                    },
                    buttonTxt: const Text(
                      'Pick Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(availableDate != null
                      ? '${availableDate!.day}/${availableDate!.month}/${availableDate!.year}'
                      : 'No Date Chosen'),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Message (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your short message here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPress: () => _submitApplication(),
                buttonTxt: const Text(
                  'Submit Application',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
