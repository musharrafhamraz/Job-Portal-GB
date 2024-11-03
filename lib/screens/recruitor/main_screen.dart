import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfinder/screens/recruitor/company_profile_screen.dart';
import 'package:jobfinder/screens/recruitor/posted_jobs_screen.dart';
import 'package:jobfinder/screens/recruitor/rec_message_screen.dart';

// Global variable to store company name
String? globalCompanyName;

class RecMainScreen extends StatefulWidget {
  const RecMainScreen({super.key});

  @override
  State<RecMainScreen> createState() => _RecMainScreenState();
}

class _RecMainScreenState extends State<RecMainScreen> {
  int _selectedIndex = 0;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _initializeCompanyName();
  }

  Future<void> _initializeCompanyName() async {
    if (globalCompanyName == null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('companies')
            .doc(userId)
            .get();

        if (doc.exists) {
          setState(() {
            globalCompanyName = doc['companyName'] as String?;
          });
        } else {
          setState(() {
            globalCompanyName = 'Company not found';
          });
        }
      } catch (error) {
        setState(() {
          globalCompanyName = 'Error fetching company';
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (globalCompanyName == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (globalCompanyName == 'Error fetching company') {
      return const Center(child: Text('Error fetching company'));
    } else if (globalCompanyName == 'Company not found') {
      return const Center(child: Text('Company not found'));
    }

    final List<Widget> _pages = [
      AllJobsPostedScreen(companyName: globalCompanyName!),
      const RecMessageScreen(),
      const CompanyProfileScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
