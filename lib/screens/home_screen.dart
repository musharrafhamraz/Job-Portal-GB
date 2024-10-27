import 'package:flutter/material.dart';
import 'package:jobfinder/provider/theme_provider.dart';
// import 'package:jobfinder/widgets/main_button.dart';
// import 'package:jobfinder/widgets/textfield.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final TextEditingController loginC = TextEditingController();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JobFinder'),
        actions: [
          Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // const Center(
            //   child: Text('Welcome to JobFinder!'),
            // ),
            // const SizedBox(height: 20),
            // CustomTextField(controller: loginC, label: 'Login'),
            // const SizedBox(height: 20),
            // CustomButton(
            //     onPress: () {},
            //     buttonTxt: const Text(
            //       'Login',
            //       style: TextStyle(fontSize: 16.0, color: Colors.white),
            //     )),
            // const Icon(
            //   Icons.handshake,
            //   size: 130.0,
            //   color: Colors.black,
            // ),
            Image(
                height: 200,
                width: 300,
                image: AssetImage('assets/images/handshake.jpg'))
          ],
        ),
      ),
    );
  }
}
