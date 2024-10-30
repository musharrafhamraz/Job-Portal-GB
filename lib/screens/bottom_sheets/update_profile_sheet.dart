import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class UpdateProfileBottomSheet extends StatefulWidget {
  final String userId; // Pass the userId to fetch and update data in Firebase

  const UpdateProfileBottomSheet({super.key, required this.userId});

  @override
  _UpdateProfileBottomSheetState createState() =>
      _UpdateProfileBottomSheetState();
}

class _UpdateProfileBottomSheetState extends State<UpdateProfileBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController decsController = TextEditingController();
  final List<String> skills = [];
  String? _filePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Fetch existing data from Firebase and populate the fields
  Future<void> _fetchProfileData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
        decsController.text = data['description'] ?? '';
        skills.addAll(List<String>.from(data['skills'] ?? []));
      }
    } catch (error) {
      print('Error fetching profile data: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.path; // Store the selected file path
      });
    }
  }

  // Update profile data on Firebase
  Future<void> _updateProfileData() async {
    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final userDescription = decsController.text.trim();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'name': name,
        'email': email,
        'phone': phone,
        'skills': skills,
        if (_filePath != null)
          'resumeFilePath': _filePath, // Optional file path
        'description': userDescription
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated!')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      print('Error updating profile data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update profile. Please try again.')),
      );
    } finally {
      _fetchProfileData();
      setState(() {});
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    skillController.dispose();
    decsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      width: double.infinity,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close)),
                          const Text('Update Your Profile',
                              style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                          controller: nameController, label: 'Full Name'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          controller: emailController, label: 'Email'),
                      const SizedBox(height: 10),
                      CustomTextField(
                          controller: phoneController, label: 'Phone Number'),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: decsController,
                        label: 'Description',
                        maxLines: 4,
                      ),
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
                      GestureDetector(
                        onTap: _pickFile,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Center(
                              child: Text('Select Your Resume or CV.')),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onPress: () => _updateProfileData(),
                        buttonTxt: const Text(
                          'Update Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
