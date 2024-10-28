import 'package:flutter/material.dart';
import 'package:jobfinder/auth/login_screen.dart';
import 'package:jobfinder/auth/register_as_jobseeker_screen.dart';
import 'package:jobfinder/auth/register_as_rec_screen.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/main_button.dart';

class SignUpOptions extends StatelessWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.9,
                image: const AssetImage(ImageStrings.handshake)),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onPress: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const RegisterAsRecScreen();
                }));
              },
              buttonTxt: const Text(
                'Sign Up as a Recruitor',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              onPress: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return const RegisterAsJobseekerScreen();
                // }));
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(
                        milliseconds: 500), // Adjust the duration as needed
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const RegisterAsJobseekerScreen();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Define the transition animation from top to bottom
                      const begin = Offset(0.0, -1.0); // Start from top
                      const end = Offset(0.0, 0.0); // End at center
                      final tween = Tween(begin: begin, end: end);
                      final offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              buttonTxt: const Text(
                'Sign Up as a Job Seeker',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    },
                    child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
