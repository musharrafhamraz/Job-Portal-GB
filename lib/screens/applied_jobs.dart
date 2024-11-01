import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';

class AppliedJobsTab extends StatefulWidget {
  const AppliedJobsTab({Key? key}) : super(key: key);

  @override
  _AppliedJobsTabState createState() => _AppliedJobsTabState();
}

class _AppliedJobsTabState extends State<AppliedJobsTab> {
  final FirebaseServices firebaseServices = FirebaseServices();
  List<Map<String, dynamic>>? appliedJobsList;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchAppliedJobs();
  }

  Future<void> _fetchAppliedJobs() async {
    try {
      final fetchedJobs = await firebaseServices.fetchAppliedJobs(uid);
      setState(() {
        appliedJobsList = fetchedJobs;
      });
    } catch (e) {
      // Handle error (e.g., show a snackbar or error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appliedJobsList == null
          ? const Center(child: CircularProgressIndicator())
          : appliedJobsList!.isEmpty
              ? const Center(child: Text('No applied jobs found'))
              : ListView.builder(
                  itemCount: appliedJobsList!.length,
                  itemBuilder: (context, index) {
                    final job = appliedJobsList![index];
                    // final applicationDate = job['applicationDate'] as DateTime?;
                    final status = job['status'] ?? 'No status';

                    return Card(
                      margin: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['name'] ?? 'No Name',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              job['company'] ?? 'No Company',
                              style: const TextStyle(
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              job['location'] ?? 'No Location',
                              style: const TextStyle(
                                  letterSpacing: 2.0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 4),
                            // Text(
                            //   'Applied on: ${applicationDate != null ? functions.formatDate(applicationDate) : 'Unknown'}',
                            //   style: TextStyle(color: Colors.grey[600]),
                            // ),
                            const SizedBox(height: 4),
                            Text(
                              'Status: $status',
                              style: TextStyle(
                                  color: status == 'pending'
                                      ? Colors.orange
                                      : Colors.green),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
