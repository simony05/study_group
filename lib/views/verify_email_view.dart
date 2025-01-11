import 'package:flutter/material.dart';
import 'package:study_group/constants/routes.dart';
import 'package:study_group/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    ( 
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 102, 204,.5),
        title: const Text('Verify email'),
      ),
      body: Column(
          children: [
            const Center(
              child: Text(
                "Verify your email account"
              ),
            ),
            const Center(
              child: Text(
                "We've sent you a verification link"
              ),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Resend email'),
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute, 
                  (route) => false
                );
              },
              child: const Text('Back'),
            )
          ],
        ),
    );
  } 
}