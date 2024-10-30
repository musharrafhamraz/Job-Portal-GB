import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveJobsProvider extends ChangeNotifier {
  final List<DateTime> savedJobs = [];

  List<DateTime> get savedJobItem => savedJobs;

  SaveJobsProvider() {
    _loadSavedJobs();
  }

  // Load saved jobs from shared preferences on initialization
  Future<void> _loadSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobsStringList = prefs.getStringList('savedJobs') ?? [];

    savedJobs.clear();
    savedJobs.addAll(
        savedJobsStringList.map((timestamp) => DateTime.parse(timestamp)));
    notifyListeners();
  }

  // Save the list of saved jobs to shared preferences
  Future<void> _saveJobsToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedJobsStringList =
        savedJobs.map((job) => job.toIso8601String()).toList();
    await prefs.setStringList('savedJobs', savedJobsStringList);
  }

  void toggleFavorites(DateTime jobTimestamp) async {
    if (savedJobs.contains(jobTimestamp)) {
      savedJobs.remove(jobTimestamp);
    } else {
      savedJobs.add(jobTimestamp);
    }
    await _saveJobsToPreferences(); // Save to shared preferences
    notifyListeners();
  }

  bool isFavorite(DateTime jobTimestamp) {
    return savedJobs.contains(jobTimestamp);
  }
}
