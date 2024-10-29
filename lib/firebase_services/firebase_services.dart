import 'package:cloud_firestore/cloud_firestore.dart';

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
}
