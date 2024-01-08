import 'package:flutter/material.dart';
import 'package:frontend/modules/authentication/screens/login_screen.dart';
import '../components/vehicle_list.dart';


class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
      ),
      body: const Center(
        child: VehicleList(), // Um widget para exibir a lista de veículos
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()), // Navegue para a tela de login
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
