import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfinder/widgets/main_text_field.dart';

class JobSeekersListScreen extends StatefulWidget {
  const JobSeekersListScreen({super.key});

  @override
  _JobSeekersListScreenState createState() => _JobSeekersListScreenState();
}

class _JobSeekersListScreenState extends State<JobSeekersListScreen> {
  String searchQuery = '';
  String locationQuery = '';
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      allUsers = snapshot.docs.map((doc) => doc.data()).toList();
      filteredUsers = allUsers;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _filterUsers();
    });
  }

  void _onLocationChanged(String query) {
    setState(() {
      locationQuery = query.toLowerCase();
      _filterUsers();
    });
  }

  void _filterUsers() {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final name = user['name'].toString().toLowerCase();
        final skills = (user['skills'] as List<dynamic>)
            .map((skill) => skill.toString().toLowerCase())
            .toList();
        final location = user['location'] != null
            ? user['location'].toString().toLowerCase()
            : '';

        return (name.contains(searchQuery) ||
                skills.any((skill) => skill.contains(searchQuery))) &&
            location.contains(locationQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find the best match'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchLocationTextField(
              onSearchChanged: _onSearchChanged,
              onLocationChanged: _onLocationChanged,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find the best Match',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'People based on your jobs you posted',
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(user['name'][0].toUpperCase(),
                                style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(
                            user['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Skills: ${user['skills'].join(', ')}',
                          ),
                          onTap: () {
                            // Navigate to user's detailed profile screen if needed
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
