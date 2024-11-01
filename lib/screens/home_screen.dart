import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';
import 'package:jobfinder/provider/save_jobs_provider.dart';
import 'package:jobfinder/screens/bottom_sheets/job_details.dart';
import 'package:jobfinder/utility/time_ago_function.dart';
import 'package:jobfinder/widgets/main_text_field.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Functions functions = Functions();
  final FirebaseServices firebaseServices = FirebaseServices();
  final TextEditingController citySearchController = TextEditingController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>>? jobs; // Cache for fetched jobs
  bool isLoading = true; // Loading state to manage job fetching

  @override
  void initState() {
    super.initState();
    _fetchJobs(); // Fetch jobs only once in initState
  }

  Future<void> _fetchJobs() async {
    try {
      final fetchedJobs = await firebaseServices.fetchJobs();
      setState(() {
        jobs = fetchedJobs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show a snackbar or error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveJobProvider = Provider.of<SaveJobsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GBHires'),
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
          const SizedBox(height: 6.0),
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (jobs == null || jobs!.isEmpty)
            const Expanded(
              child: Center(child: Text('No jobs found')),
            )
          else
            Expanded(
              flex: 7,
              child: ListView.builder(
                itemCount: jobs!.length,
                itemBuilder: (context, index) {
                  final job = jobs![index];
                  final timestamp = (job['timestamp'] as Timestamp).toDate();
                  final isJobSaved = saveJobProvider.isSaved(timestamp);

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
                                icon: Icon(
                                  isJobSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  size: 35,
                                ),
                                onPressed: () {
                                  saveJobProvider.toggleFavorites(timestamp);
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
              ),
            ),
        ],
      ),
    );
  }
}
