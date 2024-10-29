import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';
import 'package:jobfinder/screens/bottom_sheets/job_details.dart';
import 'package:jobfinder/utility/time_ago_function.dart';
import 'package:jobfinder/widgets/main_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Functions functions = Functions();

  final FirebaseServices firebaseServices = FirebaseServices();
  final TextEditingController citySearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Listings'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchLocationTextField(),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jobs For You',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Jobs based on your profile',
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      margin: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => showJobDetails(context, job),
                                    child: Text(
                                      job['name'] ?? 'No Name',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                                  Text(
                                    'Posted: ${functions.timeAgo(job['timestamp'] as Timestamp)}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.bookmark_border,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    // Add functionality to save the job
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.report_gmailerrorred_sharp,
                                    size: 35,
                                  ),
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
          ),
        ],
      ),
    );
  }
}
