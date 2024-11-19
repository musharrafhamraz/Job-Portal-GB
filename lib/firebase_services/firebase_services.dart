import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobfinder/local_storage/job_data_prefernces.dart';

Future<void> postJobToFirestore({
  required String company,
  required String name,
  required String location,
  required String jobType,
  required int experience,
  required String requirements,
}) async {
  try {
    // Get a reference to the Firestore collection
    CollectionReference jobs = FirebaseFirestore.instance.collection('jobs');

    // Add the job data to Firestore and get the document reference
    DocumentReference jobRef = await jobs.add({
      'company': company,
      'name': name,
      'location': location,
      'jobType': jobType,
      'experience': experience,
      'requirements': requirements,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Get the document ID and update the job document with this ID as jobId
    String jobId = jobRef.id;
    await jobRef.update({
      'jobId': jobId,
    });

    // Create an empty 'applicants' sub-collection within the job document
    await jobRef.collection('applicants').add({
      'init': true, // A dummy field to initialize the sub-collection
    });

    print('Job posted successfully with jobId and applicants sub-collection!');
  } catch (e) {
    print('Error posting job: $e');
  }
}

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> applyForJob({
    required String jobId, // The job document ID for which the user is applying
    required String coverLetter,
    required String resumeUrl,
    required bool isTimeFeasible,
    required DateTime? availableDate,
  }) async {
    try {
      // Reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the current user's UID
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String? userEmail = FirebaseAuth.instance.currentUser!.email;

      // Fetch the user's name from Firestore
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      String userName = userDoc['name'] ??
          'Unknown'; // Fallback in case 'name' field is missing

      // Prepare application data
      final applicationData = {
        'userId': userId,
        'userEmail': userEmail,
        'name': userName,
        'coverLetter': coverLetter,
        'resumeUrl': resumeUrl,
        'isTimeFeasible': isTimeFeasible,
        'availableDate': availableDate?.toIso8601String(),
        'applicationDate': FieldValue.serverTimestamp(),
        'status': 'pending',
      };

      // Reference to the specific job's 'applicants' sub-collection
      DocumentReference jobRef = firestore.collection('jobs').doc(jobId);
      await jobRef.collection('applicants').add(applicationData);

      // Add a reference to the applied job in the job seeker's document within 'users' collection
      DocumentReference userRef = firestore.collection('users').doc(userId);
      await userRef.update({
        'appliedJobs': FieldValue.arrayUnion(
            [jobId]) // Add jobId to 'appliedJobs' array in user's document
      });

      print('Application submitted successfully!');
      JobApplicationPreferences.saveAppliedJob(jobId);
    } catch (e) {
      print('Error submitting application: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAppliedJobs(String userId) async {
    List<Map<String, dynamic>> appliedJobsList = [];
    try {
      final querySnapshot = await _firestore.collection('jobs').get();

      for (var jobDoc in querySnapshot.docs) {
        final applicantsSnapshot = await jobDoc.reference
            .collection('applicants')
            .where('userId', isEqualTo: userId)
            .get();

        for (var applicantDoc in applicantsSnapshot.docs) {
          final jobData = jobDoc.data();
          jobData['applicationDate'] =
              (applicantDoc['applicationDate'] as Timestamp).toDate();
          jobData['status'] = applicantDoc['status'];
          appliedJobsList.add(jobData);
        }
      }
    } catch (e) {
      // Handle any errors here
    }
    return appliedJobsList;
  }

  Future<int> getAppliedJobsCount(String userId) async {
    int appliedJobsCount = 0;
    try {
      final querySnapshot = await _firestore.collection('jobs').get();

      for (var jobDoc in querySnapshot.docs) {
        final applicantsSnapshot = await jobDoc.reference
            .collection('applicants')
            .where('userId', isEqualTo: userId)
            .get();

        appliedJobsCount += applicantsSnapshot.docs.length;
      }
    } catch (e) {
      // Handle any errors here
    }
    return appliedJobsCount;
  }

  Future<void> reportJob(String jobId, String userId) async {
    DocumentReference jobRef = _firestore.collection('jobs').doc(jobId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot jobSnapshot = await transaction.get(jobRef);

      if (jobSnapshot.exists) {
        List<dynamic> reportedBy = jobSnapshot['reportedBy'] ?? [];

        if (!reportedBy.contains(userId)) {
          reportedBy.add(userId);
          transaction.update(jobRef, {'reportedBy': reportedBy});
        }
      }
    });
  }

  Future<bool> isJobReported(String jobId, String userId) async {
    DocumentSnapshot jobSnapshot =
        await _firestore.collection('jobs').doc(jobId).get();
    List<dynamic> reportedBy = jobSnapshot['reportedBy'] ?? [];
    return reportedBy.contains(userId);
  }
}
