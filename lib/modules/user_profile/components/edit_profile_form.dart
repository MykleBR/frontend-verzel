import 'package:flutter/material.dart';
import 'package:frontend/modules/user_profile/services/profile_service.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  EditProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfileData?>(
      future: ProfileService.getUserProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user profile data available'));
        } else {
          var userProfileData = snapshot.data!;
          _usernameController.text = userProfileData.username;
          _emailController.text = userProfileData.email;

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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String email = _emailController.text;
                    ProfileService.updateUserProfile(username, email);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
