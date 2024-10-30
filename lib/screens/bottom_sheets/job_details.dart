import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/screens/apply_for_job_screen.dart';
import 'package:jobfinder/utility/time_ago_function.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/outline_button.dart';

void showJobDetails(BuildContext context, Map<String, dynamic> job) {
  bool showMore = false;
  var functions = Functions();

  // Helper Text Style function
  Text buildText(String text, {TextStyle? style}) {
    return Text(text, style: style ?? const TextStyle());
  }

  // Helper Row with Icon and Text
  Widget buildIconRow(IconData icon, String text, {TextStyle? style}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 8),
        buildText(text, style: style),
      ],
    );
  }

  // Helper function for Section Title
  Text buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close and Share Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Share logic can be implemented here
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Job Title and Company Information
                buildText(job['name'] ?? 'No Name',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                buildText(job['company'] ?? 'No Company',
                    style: const TextStyle(fontSize: 20)),
                buildText(job['location'] ?? 'No Location',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 16),

                // Job Details Section
                buildSectionTitle('Job details'),
                buildText(
                  'Here’s how the job details align with your profile.',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                buildIconRow(
                  Icons.work_outline,
                  'Job Type: ${job['jobType'] ?? 'Full-time'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 16),

                // Location Section
                buildSectionTitle('Location'),
                buildIconRow(Icons.location_on_outlined,
                    job['location'] ?? 'No Location'),
                const SizedBox(height: 16),
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 16),

                // Full Job Description Section with Show More Logic
                Expanded(
                  child: ListView(
                    children: [
                      buildSectionTitle('Full job description'),
                      const SizedBox(height: 8),
                      buildText('Job Title: ${job['name'] ?? 'No Name'}'),
                      buildText(
                          'Location: ${job['location'] ?? 'No Location'}, Pakistan'),
                      buildText('Company: ${job['company'] ?? 'No Company'}'),
                      const SizedBox(height: 8),

                      // Show more/less details toggle
                      GestureDetector(
                        onTap: () => setState(() => showMore = !showMore),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText(showMore ? 'Show less' : 'Show more',
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 16)),
                            Icon(
                              showMore
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      if (showMore) ...[
                        const SizedBox(height: 8),
                        buildText(
                            'Experience: ${job['experience'] ?? 'No Experience'} years'),
                        buildText(
                            'Requirements: ${job['requirements'] ?? 'No Requirements'}'),
                        const SizedBox(height: 16),
                        buildText(
                            'Posted: ${functions.timeAgo(job['timestamp'] as Timestamp)}'),
                      ],
                    ],
                  ),
                ),

                // Apply Now and Save Job Buttons
                Column(
                  children: [
                    CustomButton(
                        onPress: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ApplyForJobScreen(jobId: job['jobId']);
                          }));
                        },
                        buttonTxt: const Text(
                          'Apply Now',
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomOutlineButton(
                        onPress: () {},
                        buttonTxt: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bookmark_border, color: Colors.black),
                            SizedBox(width: 3),
                            Text(
                              'Save Job',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomOutlineButton(
                        onPress: () {},
                        buttonTxt: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.report_gmailerrorred_outlined,
                              color: Colors.black,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Report Job',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
