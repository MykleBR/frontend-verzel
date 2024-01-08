import 'package:flutter/material.dart';
import 'package:frontend/modules/user_profile/components/user_profile_info.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: const Center(
        child: UserProfileInfo(), // Um widget para exibir informações do perfil
      ),
    );
  }
}
