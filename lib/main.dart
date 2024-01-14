import 'package:flutter/material.dart';
import 'package:study_group/services/auth/auth_service.dart';
import 'package:study_group/views/login_view.dart';
import 'package:study_group/views/home_view.dart';
import 'package:study_group/views/register_view.dart';
import 'package:study_group/views/verify_email_view.dart';
import 'package:study_group/constants/routes.dart';
import 'package:wavy_slider/wavy_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brainwave',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        homeRoute: (context) =>const HomeView(),
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
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomeView();
              }
              else {
                return const VerifyEmailView();
              }
            }
            else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
