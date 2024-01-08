import 'package:flutter/material.dart';
import 'package:frontend/modules/user_profile/components/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Center(
        child: EditProfileForm(), // Um widget para editar informações do perfil
      ),
    );
  }
}
