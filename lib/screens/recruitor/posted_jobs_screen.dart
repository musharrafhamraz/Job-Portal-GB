import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/screens/bottom_sheets/job_details_recruiter.dart';
import 'package:jobfinder/screens/recruitor/job_seekers_list_screen.dart';
import 'package:jobfinder/screens/recruitor/post_job_screen.dart';
import 'package:jobfinder/utility/time_ago_function.dart';

class AllJobsPostedScreen extends StatefulWidget {
  final String companyName;

  const AllJobsPostedScreen({Key? key, required this.companyName})
      : super(key: key);

  @override
  State<AllJobsPostedScreen> createState() => _AllJobsPostedScreenState();
}

class _AllJobsPostedScreenState extends State<AllJobsPostedScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> jobs;
  final Functions functions = Functions();

  @override
  void initState() {
    super.initState();
    jobs = _fetchJobsByCompanyName(widget.companyName);
  }

  Future<List<Map<String, dynamic>>> _fetchJobsByCompanyName(
      String companyName) async {
    final querySnapshot = await _firestore
        .collection('jobs')
        .where('company', isEqualTo: companyName)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GBHires'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PostJobScreen(
                      companyName: widget.companyName,
                    );
                  }));
                },
                child: const Text('Post a Job'),
              ),
              PopupMenuItem(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const JobSeekersListScreen();
                  }));
                },
                child: const Text('Go to'),
              ),
            ];
          })
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: jobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No jobs posted by this company.'));
          } else {
            final jobsList = snapshot.data!;
            return ListView.builder(
              itemCount: jobsList.length,
              itemBuilder: (context, index) {
                final job = jobsList[index];
                return GestureDetector(
                  onTap: () => showJobDetailsRec(context, job),
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle job title tap event
                                },
                                child: Text(
                                  job['name'] ?? 'No Name',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'You Posted: ${job['timestamp'] != null ? functions.timeAgo(job['timestamp'] as Timestamp) : 'Unknown time'}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 28,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Handle edit action
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 28,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // Handle delete action
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Post A Job'),
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PostJobScreen(
              companyName: widget.companyName,
            );
          }));
        },
      ),
    );
  }
}
