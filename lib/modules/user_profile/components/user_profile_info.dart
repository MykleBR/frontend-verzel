import 'package:flutter/material.dart';
import 'package:frontend/modules/user_profile/services/profile_service.dart';

class UserProfileInfo extends StatelessWidget {
  
  // ignore: use_key_in_widget_constructors
  const UserProfileInfo({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfileData?>(
      future: ProfileService.getUserProfileData(),
      builder: (BuildContext context, AsyncSnapshot<UserProfileData?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user profile data available'));
        } else {
          var userProfileData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Username: ${userProfileData.username}'),
                const SizedBox(height: 8.0),
                Text('Email: ${userProfileData.email}'),
                // Outras informações do perfil do usuário
                // ...
              ],
            ),
          );
        }
      },
    );
  }
}
