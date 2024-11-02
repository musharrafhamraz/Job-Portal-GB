import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/auth/auth_services.dart';
import 'package:jobfinder/auth/email_verification.dart';
import 'package:jobfinder/auth/forget_password.dart';
import 'package:jobfinder/auth/options.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/screens/main_screen.dart';
import 'package:jobfinder/screens/recruitor/home_screen.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthServices authServices = AuthServices();
  bool isLoading = false; // Loading state indicator

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.9,
                  image: const AssetImage(ImageStrings.handshake),
                ),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 25),
                CustomTextField(controller: emailController, label: 'Email'),
                const SizedBox(height: 10),
                CustomTextField(controller: passController, label: 'Password'),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordScreen();
                        }),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 10),

                // Show CircularProgressIndicator while loading
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPress: () async {
                          final String email = emailController.text.trim();
                          final String password = passController.text.trim();

                          if (email.isNotEmpty && password.isNotEmpty) {
                            setState(() {
                              isLoading = true; // Start loading
                            });

                            UserCredential? userCredential =
                                await authServices.loginUser(email, password);

                            if (userCredential != null) {
                              if (userCredential.user != null &&
                                  userCredential.user!.emailVerified) {
                                // Check if the email exists in the 'companies' collection
                                final companySnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('companies')
                                    .where('email', isEqualTo: email)
                                    .get();

                                if (companySnapshot.docs.isNotEmpty) {
                                  // Email exists in companies collection, navigate to recruiter screen
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PostJobScreen(),
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
                                // Email is not verified
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationScreen(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Login failed. Please try again.'),
                                ),
                              );
                            }

                            setState(() {
                              isLoading = false; // End loading
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please fill the required fields')),
                            );
                          }
                        },
                        buttonTxt: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Do not have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return const SignUpOptions();
                          }),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
