class Job {
  final String name;
  final String location;
  final String jobType;
  final String experience;
  final String requirements;
  final DateTime timeStamp;

  Job({
    required this.name,
    required this.location,
    required this.jobType,
    required this.experience,
    required this.requirements,
    required this.timeStamp,
  });

  factory Job.fromMap(Map<String, dynamic> data) {
    return Job(
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      jobType: data['jobType'] ?? '',
      experience: data['experience'] ?? '',
      requirements: data['requirements'] ?? '',
      timeStamp: DateTime.parse(data['timeStamp'] ?? ''),
    );
  }
}
