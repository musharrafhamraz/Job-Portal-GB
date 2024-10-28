import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfinder/auth/auth_services.dart';
import 'package:jobfinder/auth/login_screen.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class RegisterAsRecScreen extends StatefulWidget {
  const RegisterAsRecScreen({super.key});

  @override
  State<RegisterAsRecScreen> createState() => _RegisterAsRecScreenState();
}

class _RegisterAsRecScreenState extends State<RegisterAsRecScreen> {
  // Define controllers
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final addressController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final AuthServices _auth = AuthServices();
  bool _isLoading = false; // To manage loading indicator state

  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    passController.dispose();
    addressController.dispose();
    confirmController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // Function to handle registration
  Future<void> _handleRegister() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String pass = passController.text.trim();
    final String address = addressController.text.trim();
    final String confirmPass = confirmController.text.trim();

    if (email.isEmpty ||
        pass.isEmpty ||
        name.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        confirmPass.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all required fields');
      return;
    }

    if (pass != confirmPass) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signUpCompany(email, pass, name, phone, address);
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Application Under Review',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your application is under review and will typically take three business days for approval.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'We appreciate your patience.',
                  textAlign: TextAlign.center,
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text('OK'))
              ],
            ),
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing up: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Let’s create an account!',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: nameController,
                  label: 'Company Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: emailController,
                  label: 'Email Address',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: phoneController,
                  label: 'Contact Number',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: addressController,
                  label: 'Address',
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passController,
                  label: 'Password',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: confirmController,
                  label: 'Confirm Password',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                // Show a loading spinner if _isLoading is true
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                    : CustomButton(
                        onPress: _handleRegister,
                        buttonTxt: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Login'),
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
