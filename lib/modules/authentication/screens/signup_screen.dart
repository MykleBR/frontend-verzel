import 'package:flutter/material.dart';
import 'package:frontend/modules/authentication/screens/login_screen.dart';

import '../components/singup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Em breve...'),
      ),
      body: Center(
        child: SignUpForm(onSignUpSuccess: () {
          // Após o cadastro bem-sucedido, redirecione para a tela de login
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false, // Remove todas as rotas anteriores
          );
        }), // Um widget para o formulário de cadastro
      ),
    );
  }
}
