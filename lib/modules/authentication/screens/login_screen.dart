import 'package:flutter/material.dart';
import 'package:frontend/modules/authentication/components/login_form.dart';
import 'package:frontend/modules/authentication/screens/signup_screen.dart'; // Importe a tela de cadastro

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginForm(), // Um widget para o formulário de login
            const SizedBox(height: 20), // Espaçamento entre o formulário e o botão
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()), // Navega até a tela de cadastro (signup)
                );
              },
              child: const Text('Create an Account'), // Texto do botão
            ),
          ],
        ),
      ),
    );
  }
}
