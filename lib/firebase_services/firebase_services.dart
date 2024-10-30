import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> postJobToFirestore({
  required String name,
  required String location,
  required String jobType,
  required int experience,
  required String requirements,
}) async {
  try {
    // Get a reference to the Firestore collection
    CollectionReference jobs = FirebaseFirestore.instance.collection('jobs');

    // Add the job data to Firestore
    await jobs.add({
      'name': name,
      'location': location,
      'jobType': jobType,
      'experience': experience,
      'requirements': requirements,
      'timestamp': FieldValue.serverTimestamp(), // Optional: add timestamp
    });

    print('Job posted successfully!');
  } catch (e) {
    print('Error posting job: $e');
  }
}

class FirebaseServices {
  Future<List<Map<String, dynamic>>> fetchJobs() async {
    List<Map<String, dynamic>> jobs = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('jobs') // Specify the correct collection name here
          .get();

      jobs = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching jobs: $e');
    }

    return jobs;
  }

  // fetch the resume url form firebase
  Future<String?> fetchUserResume() async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // User is not logged in
        return null;
      }

      String uid = user.uid;

      // Fetch the user document from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Extract the resume URL from the user document
        Map<String, dynamic>? userData = userDoc.data()
            as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        String? resumeUrl = userData?['resume_url']; // Access the resume_url
        print(resumeUrl);
        return resumeUrl;
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      print("Error fetching resume URL: $e");
      return null;
    }
  }
}
