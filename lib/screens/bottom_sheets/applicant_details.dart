import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:url_launcher/url_launcher.dart';

void showApplicantDetails(
    BuildContext context, Map<String, dynamic> applicant) async {
  final applicantName = applicant['name'];
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

  Future<void> _openResume(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
              Text(
                '$applicantName',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Email: $email'),
              const SizedBox(height: 8),
              Text('Phone: $phone'),
              const SizedBox(height: 8),
              Text('Skills: $skills'),
              const SizedBox(height: 8),
              Text('Applied on: ${formatDate(applicationDate)}'),
              const SizedBox(height: 8),
              Text('Cover Letter: $coverLetter'),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              CustomButton(
                onPress: () => _openResume(resumeUrl),
                buttonTxt: const Text('View Resume'),
              ),
            ],
          ),
        ),
      );
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
