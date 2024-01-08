import 'package:flutter/material.dart';
import 'package:frontend/modules/authentication/services/auth_service.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final VoidCallback onSignUpSuccess;

  SignUpForm({Key? key, required this.onSignUpSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () async {
              String username = _usernameController.text;
              String password = _passwordController.text;
              bool success = await AuthService.signUp(username, password);

              if (success) {
                onSignUpSuccess(); // Notificar o sucesso do cadastro
              } else {
                // Tratar falha no cadastro, se necessário
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
