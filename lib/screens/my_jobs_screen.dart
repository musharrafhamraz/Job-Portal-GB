import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jobfinder/provider/save_jobs_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';
import 'package:jobfinder/screens/bottom_sheets/job_details.dart';
import 'package:jobfinder/utility/time_ago_function.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs: Saved, Applied, Archived
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Jobs'),
          bottom: TabBar(
            tabs: [
              Consumer<SaveJobsProvider>(
                builder: (context, saveJobProvider, child) {
                  int savedJobCount = saveJobProvider.savedJobItem.length;
                  return Tab(
                    text: 'Saved Jobs (${savedJobCount})',
                  );
                },
              ),
              const Tab(text: 'Applied Jobs'),
              const Tab(text: 'Archived'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SavedJobsTab(),
            AppliedJobsTab(),
            ArchivedJobsTab(),
          ],
        ),
      ),
    );
  }
}

class SavedJobsTab extends StatefulWidget {
  const SavedJobsTab({super.key});

  @override
  State<SavedJobsTab> createState() => _SavedJobsTabState();
}

class _SavedJobsTabState extends State<SavedJobsTab> {
  final FirebaseServices firebaseServices = FirebaseServices();
  final Functions functions = Functions();
  List<Map<String, dynamic>>? savedJobsList;

  @override
  void initState() {
    super.initState();
    _fetchSavedJobs();
  }

  Future<void> _fetchSavedJobs() async {
    final savedTimestamps =
        Provider.of<SaveJobsProvider>(context, listen: false).savedJobItem;

    try {
      final fetchedJobs = await firebaseServices.fetchJobs();
      setState(() {
        savedJobsList = fetchedJobs
            .where((job) => savedTimestamps
                .contains((job['timestamp'] as Timestamp).toDate()))
            .toList();
      });
    } catch (e) {
      // Handle error (e.g., show a snackbar or error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveJobProvider = Provider.of<SaveJobsProvider>(context);

    return Scaffold(
      body: savedJobsList == null
          ? const Center(child: CircularProgressIndicator())
          : savedJobsList!.isEmpty
              ? const Center(child: Text('No saved jobs found'))
              : ListView.builder(
                  itemCount: savedJobsList!.length,
                  itemBuilder: (context, index) {
                    final job = savedJobsList![index];
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
                                    setState(() {
                                      savedJobsList!.removeAt(index);
                                    });
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
    );
  }
}

class AppliedJobsTab extends StatelessWidget {
  const AppliedJobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Applied Jobs yet'),
    );
  }
}

class ArchivedJobsTab extends StatelessWidget {
  const ArchivedJobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Archived Jobs yet'),
    );
  }
}
