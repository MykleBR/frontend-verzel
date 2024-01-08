import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../authentication/services/auth_service.dart';
import '../components/vehicle_list_widget.dart';
import '../services/vehicle_service.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VehicleRegistrationScreenState createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  File? _imageFile;
  final TextEditingController _vehicleNomeController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  List<Vehicle> vehicles = []; // Lista de veículos

  Future<void> _getImage() async {
    final pickedFile =
        // ignore: deprecated_member_use
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void updateList(List<Vehicle> updatedList) {
    setState(() {
      vehicles = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Define uma altura máxima
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _vehicleNomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              _imageFile != null
                  ? Image.file(_imageFile!)
                  : const Placeholder(),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Imagem'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_imageFile != null) {
                    String vehicleName = _vehicleNomeController.text;
                    String brand = _marcaController.text;
                    String model = _modeloController.text;

                    String? authToken = AuthService.getAccessToken();

                    if (authToken != null) {
                      await VehicleService.signUpVehicle(
                        nome: vehicleName,
                        marca: brand,
                        modelo: model,
                        imageFile: _imageFile!,
                        authToken: authToken,
                      );

                      _vehicleNomeController.clear();
                      _marcaController.clear();
                      _modeloController.clear();
                      _imageFile = null;

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } else {
                      // Handle no valid access token
                    }
                  } else {
                    // Show a warning if no image is selected
                  }
                },
                child: const Text('Registrar veículo'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Veículos cadastrados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SingleChildScrollView(
                child: VehicleListWidget(
                  updateList: updateList,
                  vehicles: vehicles,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
