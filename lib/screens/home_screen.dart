import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';
import 'package:jobfinder/screens/bottom_sheets/job_details.dart';
import 'package:jobfinder/utility/time_ago_function.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Functions functions = Functions();

  final FirebaseServices firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firebaseServices.fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching jobs'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs found'));
          }

          List<Map<String, dynamic>> jobs = snapshot.data!;
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['company'] ?? 'No Company',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () => showJobDetails(context, job),
                              child: Text(
                                job['name'] ?? 'No Name',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                                'Posted: ${functions.timeAgo(job['timestamp'] as Timestamp)}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {
                              // Add functionality to save the job
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.report_gmailerrorred_sharp),
                            onPressed: () {
                              // Add functionality to report the job
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
