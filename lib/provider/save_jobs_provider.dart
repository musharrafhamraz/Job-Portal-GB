import 'package:flutter/foundation.dart';

class SaveJobsProvider extends ChangeNotifier {
  final List<DateTime> savedJobs = [];

  List<DateTime> get savedJobItem => savedJobs;

  void toggleFavorites(DateTime jobTimestamp) {
    if (savedJobs.contains(jobTimestamp)) {
      savedJobs.remove(jobTimestamp);
    } else {
      savedJobs.add(jobTimestamp);
    }
    notifyListeners();
  }

  bool isFavorite(DateTime jobTimestamp) {
    return savedJobs.contains(jobTimestamp);
  }
}
