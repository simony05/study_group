import 'package:flutter/material.dart';
import 'package:study_group/services/auth/auth_service.dart';
import 'package:study_group/views/login_view.dart';
import 'package:study_group/views/notes_view.dart';
import 'package:study_group/views/register_view.dart';
import 'package:study_group/views/verify_email_view.dart';
import 'package:study_group/constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Study Group',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) =>const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      }
    )
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // shows when future is finished
          case ConnectionState.done:
          // check if user is logged in
            final user = AuthService.firebase().currentUser;
            if (user != null) { // if there is a user 
              if (user.isEmailVerified) {
                return const NotesView();
              }
              else {
                return const VerifyEmailView();
              }
            }
            else { // if there is no user 
              return const LoginView();
            }
          default:
            // loading until connected
            return const CircularProgressIndicator();
        }
      },
    );
  }
}