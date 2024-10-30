import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class UpdateProfileBottomSheet extends StatefulWidget {
  @override
  _UpdateProfileBottomSheetState createState() =>
      _UpdateProfileBottomSheetState();
}

class _UpdateProfileBottomSheetState extends State<UpdateProfileBottomSheet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final List<String> skills = [];
  String? _filePath;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Update Your Profile', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
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
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blue),
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(child: Text('Select Your Resume or CV.')),
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                onPress: () {
                  // Logic to update the user profile
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final phone = phoneController.text.trim();
                  // Optionally handle resume upload if _filePath is not null

                  // Show a success message or update the profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile Updated!')),
                  );
                },
                buttonTxt: const Text(
                  'Update Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
