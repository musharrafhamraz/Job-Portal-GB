import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfinder/utility/send_email_function.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void showApplicantDetails(
    BuildContext context, Map<String, dynamic> applicant) async {
  final applicantName = applicant['name'];
  final applicantEmail = applicant['email'];
  final applicationDate = applicant['applicationDate'];
  final coverLetter = applicant['coverLetter'] ?? 'No cover letter';
  final resumeUrl = Uri.parse(applicant['resumeUrl']);
  final userId = applicant['userId'];

  // Fetch user details (name, skills, phone, email) from Firestore
  final userDetails = await getApplicantDetails(userId);

  if (userDetails == null) {
    // If user details are not found, display a message and exit
    return;
  }

  // Extract user details
  final skills =
      userDetails['skills'].join(', '); // Combine skills into a string
  final phone = userDetails['phone'];
  final email = userDetails['email'];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                  Text(
                    '$applicantName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$email',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$phone',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$skills',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Applied on: ${formatDate(applicationDate)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cover Letter: $coverLetter',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Add container to display PDF
                  SizedBox(
                    height: 500, // You can adjust the height as needed
                    child: SfPdfViewer.network(resumeUrl.toString()),
                  ),

                  const SizedBox(height: 16),
                  CustomButton(
                    onPress: () {
                      final TextEditingController passwordController =
                          TextEditingController();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Enter Password'),
                            content: TextField(
                              controller: passwordController,
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true, // Hide input
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Validate password
                                  if (passwordController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: 'Password cannot be empty.',
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    return;
                                  }

                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  sendEmail(
                                    applicantEmail,
                                    "Call for interview",
                                    "You are requested to reach for the interview on a specific date.",
                                    passwordController
                                        .text, // Pass the validated password
                                  );
                                },
                                child: const Text('Send Email'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    buttonTxt: const Text(
                      'Select Candidate',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

// Fetch applicant details (name, skills, phone, email)
Future<Map<String, dynamic>?> getApplicantDetails(String userId) async {
  try {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch the user document from the 'users' collection using userId
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();

    // Check if the document exists and return the required fields if it does
    if (userDoc.exists && userDoc.data() != null) {
      return {
        'name': userDoc.get('name'),
        'skills': List<String>.from(userDoc.get('skills')),
        'phone': userDoc.get('phone'),
        'email': userDoc.get('email'),
      };
    }
  } catch (e) {
    print('Error fetching applicant details: $e');
  }
  return null; // Return null if there's an error or the user does not exist
}

// Helper function to format date into a readable format
String formatDate(Timestamp timestamp) {
  final date = timestamp.toDate();
  return '${date.day}-${date.month}-${date.year}';
}
