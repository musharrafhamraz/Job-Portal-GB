import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jobfinder/auth/email_verification.dart';
// import 'package:jobfinder/auth/forget_password.dart';
// // import 'package:jobfinder/auth/login_screen.dart';
// // import 'package:jobfinder/auth/options.dart';
// // import 'package:jobfinder/auth/register_as_jobseeker_screen.dart';
// import 'package:jobfinder/auth/register_as_rec_screen.dart';
import 'package:jobfinder/provider/theme_provider.dart';
// import 'package:jobfinder/screens/home_screen.dart';
import 'package:jobfinder/themes/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'JobFinder',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: EmailVerificationScreen(),
    );
  }
}
