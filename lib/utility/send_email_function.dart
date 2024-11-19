import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(
    String recipient, String subject, String body, String passwordG) async {
  final String userEmail = FirebaseAuth.instance.currentUser!.email!;
  // Sender's email credentials
  final String username = userEmail;
  final String password = passwordG;

  // Configure the SMTP server for Gmail
  final smtpServer = gmail(username, password);

  // Create the email message
  final message = Message()
    ..from = Address(username, 'The company name') // Replace with your name
    ..recipients.add(recipient) // Add recipient
    ..subject = subject // Set subject
    ..text = body; // Set email body text

  try {
    // Attempt to send the email
    final sendReport = await send(message, smtpServer);
    Fluttertoast.showToast(msg: 'Message sent: ${sendReport.toString()}');
  } on MailerException catch (e) {
    // Handle errors
    Fluttertoast.showToast(msg: 'Message not sent.');
    for (var p in e.problems) {
      Fluttertoast.showToast(msg: 'Problem: ${p.code}: ${p.msg}');
    }
  }
}
