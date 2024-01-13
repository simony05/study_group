import 'package:flutter/material.dart';
import 'package:study_group/constants/routes.dart';
import 'package:study_group/services/auth/auth_exceptions.dart';
import 'package:study_group/services/auth/auth_service.dart';
import 'package:study_group/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
  // late promises a value later
  late final TextEditingController _email; 
  late final TextEditingController _password;

  // assigns values to email and password
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // disposes values when going out of memory
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
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
              final email = _email.text;
              final password = _password.text; 
              try {
                // returns future, needs await to perform the work
                await AuthService.firebase().logIn(
                  email: email, 
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // Email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute, 
                    (route) => false,
                  );
                }
                else {
                  // Email is not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, 
                    (route) => false,
                  );
                }
              }
              // catches specific types of errors
              on UserNotFoundAuthException {
                await showErrorDialog(
                  context, 
                  'User not found',
                );
              }
              on WrongPasswordAuthException {
                await showErrorDialog(
                  context, 
                  'Wrong credentials',
                );
              }
              on GenericAuthException {
                await showErrorDialog(
                  context, 
                  'Authentication error',
                );
              }   
            }, 
            child: const Text('Login')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute, 
                (route) => false
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
