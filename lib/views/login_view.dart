
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
  
  late final TextEditingController _email; 
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

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
        backgroundColor: const Color.fromRGBO(0, 102, 204,.5),
        title: const Text('Brainwave'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text; 
                  try {
                    await AuthService.firebase().logIn(
                      email: email, 
                      password: password,
                    );
                    final user = AuthService.firebase().currentUser;
                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        homeRoute, 
                        (route) => false,
                      );
                    }
                    else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, 
                        (route) => false,
                      );
                    }
                  }
                  on UserNotFoundAuthException {
                    await showErrorDialog(
                      context, 
                      'User not found',
                    );
                  }
                  on WrongPasswordAuthException {
                    await showErrorDialog(
                      context, 
                      'Wrong email or password',
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
                child: const Text("Don't have an account? Sign up."),
              )
            ],
          ),
        ),
      ),
    );
  }
}
