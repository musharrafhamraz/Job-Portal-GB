import 'package:shared_preferences/shared_preferences.dart';

class JobApplicationPreferences {
  static const String _appliedJobsKey = 'appliedJobs';

  // Save a job ID as applied
  static Future<void> saveAppliedJob(String jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> appliedJobs = prefs.getStringList(_appliedJobsKey) ?? [];
    if (!appliedJobs.contains(jobId)) {
      appliedJobs.add(jobId);
      await prefs.setStringList(_appliedJobsKey, appliedJobs);
    }
  }

  // Check if a job ID is applied
  static Future<bool> isJobApplied(String jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> appliedJobs = prefs.getStringList(_appliedJobsKey) ?? [];
    return appliedJobs.contains(jobId);
  }

  // Retrieve all applied jobs
  static Future<List<String>> getAppliedJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_appliedJobsKey) ?? [];
  }
}
