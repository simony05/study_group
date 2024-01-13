import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_group/constants/routes.dart';
import 'package:study_group/services/auth/auth_exceptions.dart';
import 'package:study_group/services/auth/auth_service.dart';
import 'package:study_group/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  // late promises a value later
  late final TextEditingController _email; 
  late final TextEditingController _password;
  late final TextEditingController _name;

  // assigns values to email and password
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    super.initState();
  }

  // disposes values when going out of memory
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _name,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your full name here',
            ),
          ),
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final name = _name.text;
              final email = _email.text;
              final password = _password.text; 
              try {
                await AuthService.firebase().createUser(
                  email: email, 
                  password: password,
                );
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
                  'name': name,
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                  'email': email,
                });
                final user = FirebaseAuth.instance.currentUser;
                user!.updateDisplayName(name);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute, 
                );
              }
              on WeakPasswordAuthException {
                await showErrorDialog(
                  context, 
                  'Weak password',
                );
              }
              on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context, 
                  'Email already in use',
                );
              }
              on InvalidEmailAuthException {
                await showErrorDialog(
                  context, 
                  'Invalid email',
                );
              }
              on GenericAuthException {
                await showErrorDialog(
                  context, 
                  'Failed to register',
                );
              }
            }, 
            child: const Text('Register')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute, 
                (route) => false
              );
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
