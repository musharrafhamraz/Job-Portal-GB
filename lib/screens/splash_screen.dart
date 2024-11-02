import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/auth/login_screen.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/screens/main_screen.dart';
import 'package:jobfinder/screens/recruitor/home_screen.dart';
import 'package:jobfinder/widgets/title_name_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Start a timer when the splash screen is displayed
    Timer(const Duration(seconds: 3), () async {
      // Navigate to the LoginScreen after 3 seconds
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        // Check if the email exists in the 'companies' collection
        final companySnapshot = await FirebaseFirestore.instance
            .collection('companies')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get();

        if (companySnapshot.docs.isNotEmpty) {
          // Email exists in companies collection, navigate to recruiter screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PostJobScreen(),
            ),
          );
        } else {
          // Email not found in companies collection, navigate to main screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        }
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage(ImageStrings.gb),
            ),
            const SizedBox(
              height: 60,
            ),
            const TitleName(),
            const Text(
              'Gilgit-Baltistan',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(height: 100, ImageStrings.handshake)
          ],
        ),
      ),
    );
  }
}
