// import 'package:flutter/material.dart';
// import 'package:jobfinder/auth/login_screen.dart';
// import 'package:jobfinder/constants/image_strings.dart';
// import 'package:jobfinder/widgets/main_button.dart';
// import 'package:jobfinder/widgets/textfield.dart';

// class RegisterAsJobseekerScreen extends StatefulWidget {
//   const RegisterAsJobseekerScreen({super.key});

//   @override
//   State<RegisterAsJobseekerScreen> createState() =>
//       _RegisterAsJobseekerScreenState();
// }

// class _RegisterAsJobseekerScreenState extends State<RegisterAsJobseekerScreen> {
//   // Move controllers to the top to avoid being reset on every rebuild
//   final emailController = TextEditingController();
//   final passController = TextEditingController();
//   final confirmController = TextEditingController();
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final skillController = TextEditingController();
//   final List<String> skills = [];

//   // Add and remove skills with setState
//   void addSkill(String skill) {
//     if (skill.isNotEmpty) {
//       setState(() {
//         if (skills.length < 5) {
//           skills.add(skill);
//           skillController.clear();
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('You only 5 skills.')));
//           skillController.clear();
//         }
//       });
//       print('skill added $skill');
//     }
//   }

//   void removeSkill(String skill) {
//     setState(() {
//       skills.remove(skill);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image(
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     width: MediaQuery.of(context).size.width * 0.9,
//                     image: const AssetImage(ImageStrings.handshake)),
//                 const Text(
//                   'Let’s create an account!',
//                   style: TextStyle(
//                     fontSize: 24.0,
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 CustomTextField(controller: nameController, label: 'Full Name'),
//                 const SizedBox(height: 10),
//                 CustomTextField(controller: emailController, label: 'Email'),
//                 const SizedBox(height: 10),
//                 CustomTextField(
//                     controller: phoneController, label: 'Phone Number'),
//                 const SizedBox(height: 10),
//                 CustomTextField(
//                   controller: skillController,
//                   label: 'Enter a Skill',
//                   onSubmit: (value) => addSkill(value.trim()),
//                 ),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 4,
//                   children: skills
//                       .map((skill) => Chip(
//                             label: Text(
//                               skill,
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                             deleteIcon: const Icon(
//                               Icons.close,
//                               color: Colors.white,
//                             ),
//                             backgroundColor: Colors.blue[900],
//                             onDeleted: () => removeSkill(skill),
//                           ))
//                       .toList(),
//                 ),
//                 const SizedBox(height: 10),
//                 CustomTextField(controller: passController, label: 'Password'),
//                 const SizedBox(height: 10),
//                 CustomTextField(
//                     controller: confirmController, label: 'Confirm Password'),
//                 const SizedBox(height: 10),

//                 // TODO: Add field to select pdf file

//                 CustomButton(
//                   onPress: () {
//                     final String name = nameController.text.trim();
//                     final String email = emailController.text.trim();
//                     final String phone = phoneController.text.trim();
//                     final String pass = passController.text.trim();
//                     final String confirmPass = confirmController.text.trim();

//                     if (email.isNotEmpty &&
//                         pass.isNotEmpty &&
//                         name.isNotEmpty &&
//                         phone.isNotEmpty &&
//                         confirmPass.isNotEmpty) {
//                       if (pass != confirmPass) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Passwords do not match.')));
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Register function executed.')));
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content:
//                               Text('Please fill in the required fields.')));
//                     }
//                   },
//                   buttonTxt: const Text(
//                     'Register',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Already have an account?'),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context)
//                             .push(MaterialPageRoute(builder: (context) {
//                           return const LoginScreen();
//                         }));
//                       },
//                       child: const Text('Login'),
//                     )
//                   ],
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobfinder/auth/auth_services.dart';
import 'package:jobfinder/auth/login_screen.dart';
import 'package:jobfinder/constants/image_strings.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';
import 'package:file_picker/file_picker.dart';

class RegisterAsJobseekerScreen extends StatefulWidget {
  const RegisterAsJobseekerScreen({super.key});

  @override
  State<RegisterAsJobseekerScreen> createState() =>
      _RegisterAsJobseekerScreenState();
}

class _RegisterAsJobseekerScreenState extends State<RegisterAsJobseekerScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final skillController = TextEditingController();
  final List<String> skills = [];
  String? _filePath; // Variable to store the selected file path

  final AuthServices _auth = AuthServices();

  void addSkill(String skill) {
    if (skill.isNotEmpty) {
      setState(() {
        if (skills.length < 5) {
          skills.add(skill);
          skillController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You can only add 5 skills.')));
          skillController.clear();
        }
      });
    }
  }

  void removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }

  Future<void> _pickFile() async {
    // Open the file picker dialog
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.path; // Get the file path
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
                CustomTextField(controller: nameController, label: 'Full Name'),
                const SizedBox(height: 10),
                CustomTextField(controller: emailController, label: 'Email'),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: phoneController, label: 'Phone Number'),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: skillController,
                  label: 'Enter a Skill',
                  onSubmit: (value) => addSkill(value.trim()),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: skills
                      .map((skill) => Chip(
                            label: Text(
                              skill,
                              style: const TextStyle(color: Colors.white),
                            ),
                            deleteIcon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.blue[900],
                            onDeleted: () => removeSkill(skill),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                CustomTextField(controller: passController, label: 'Password'),
                const SizedBox(height: 10),
                CustomTextField(
                    controller: confirmController, label: 'Confirm Password'),
                const SizedBox(height: 10),

                // File selection button
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(5)),
                    child:
                        const Center(child: Text('Select Your Resume or CV.')),
                  ),
                ),

                const SizedBox(height: 10),

                CustomButton(
                  onPress: () async {
                    final String name = nameController.text.trim();
                    final String email = emailController.text.trim();
                    final String phone = phoneController.text.trim();
                    final String pass = passController.text.trim();
                    final String confirmPass = confirmController.text.trim();

                    if (email.isNotEmpty &&
                        pass.isNotEmpty &&
                        name.isNotEmpty &&
                        phone.isNotEmpty &&
                        confirmPass.isNotEmpty) {
                      if (pass != confirmPass) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords do not match.')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Register function executed.')));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Please fill in the required fields.')));
                    }

                    String resumePath = '';
                    if (_filePath != null) {
                      // Define a unique name for the file in storage
                      String fileName =
                          '${DateTime.now().millisecondsSinceEpoch}_${_filePath!.split('/').last}';
                      final Reference storageRef = FirebaseStorage.instance
                          .ref()
                          .child('resumes/$fileName');
                      await storageRef.putFile(File(_filePath!));
                      resumePath = await storageRef
                          .getDownloadURL(); // Get the download URL for the uploaded file
                    }
                    Fluttertoast.showToast(
                        msg: 'File Uploaded. Signing You Up');

                    _auth.signUpUser(
                        email, pass, name, phone, skills, resumePath);
                  },
                  buttonTxt: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
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
                      child: const Text('Login'),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
