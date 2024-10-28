import 'package:flutter/material.dart';
import 'package:jobfinder/firebase_services/firebase_services.dart';
import 'package:jobfinder/widgets/main_button.dart';
import 'package:jobfinder/widgets/textfield.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  String jobType = 'Onsite'; // Default selection for job type

  void postJob() {
    if (_formKey.currentState?.validate() ?? false) {
      postJobToFirestore(
        name: nameController.text,
        location: locationController.text,
        jobType: jobType,
        experience: int.parse(experienceController.text),
        requirements: requirementsController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully!")),
      );
      // Clear the fields after posting the job
      nameController.clear();
      locationController.clear();
      experienceController.clear();
      requirementsController.clear();
      setState(() {
        jobType = 'Onsite';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name of the Post
              CustomTextField(
                controller: nameController,
                label: 'Name of the Post',
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              // Location
              CustomTextField(
                controller: locationController,
                label: 'Location',
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              // Job Type Dropdown (Remote/Onsite)
              DropdownButtonFormField<String>(
                value: jobType,
                decoration: InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                    ),
                  ),
                ),
                items: ['Onsite', 'Remote'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    jobType = newValue ?? jobType;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Experience (in years)
              CustomTextField(
                controller: experienceController,
                label: 'Experience (in years)',
                keyboardType: TextInputType.number,
                maxLines: 1,
              ),
              const SizedBox(height: 16),

              // Requirements (more than 5 lines)
              CustomTextField(
                controller: requirementsController,
                label: 'Requirements',
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),

              // Post Job Button
              CustomButton(
                onPress: postJob,
                buttonTxt: const Text(
                  'Post Job',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
