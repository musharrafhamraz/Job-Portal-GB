import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfinder/auth/auth_services.dart';
import 'package:jobfinder/auth/login_screen.dart';
import 'package:jobfinder/screens/bottom_sheets/update_profile_sheet.dart';
import 'package:jobfinder/widgets/main_button.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth
        .instance.currentUser!.uid; // Replace with dynamic UID if needed
    final AuthServices authServices = AuthServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('companies').doc(uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String name = userData['companyName'] ?? 'N/A';
          final String email = userData['email'] ?? 'N/A';
          final String phone = userData['contact'] ?? 'N/A';
          final String role = userData['role'] ?? 'N/A';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // User Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightGreen),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.work_outline),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Email
                Text(
                  email,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                // Phone
                Text(
                  phone,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Spacer(),
                // Logout Button
                CustomButton(
                  onPress: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => UpdateProfileBottomSheet(
                        userId: uid,
                      ),
                    );
                  },
                  buttonTxt: const Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: CustomButton(
                    onPress: () {
                      authServices.logoutUser();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    buttonTxt: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
