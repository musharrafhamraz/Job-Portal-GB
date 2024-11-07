import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobfinder/screens/bottom_sheets/applicant_details.dart';

class ApplicantsListScreen extends StatelessWidget {
  final String jobId;

  const ApplicantsListScreen({super.key, required this.jobId});

  Future<List<Map<String, dynamic>>> fetchApplicants() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(jobId)
        .collection('applicants')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicants'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchApplicants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading applicants'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No applicants found'));
          }

          final applicants = snapshot.data!;

          return ListView.builder(
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final applicant = applicants[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue,
                  child: Text(
                    applicant['name'][0].toUpperCase(),
                  ),
                ),
                title: Text('${applicant['name']}'),
                subtitle: Text(DateFormat.yMMMd().format(
                    (applicant['applicationDate'] as Timestamp).toDate())),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => showApplicantDetails(context, applicant),
              );
            },
          );
        },
      ),
    );
  }
}
