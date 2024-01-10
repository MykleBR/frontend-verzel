import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../authentication/services/auth_service.dart';
import '../components/vehicle_list_widget.dart';
import '../services/vehicle_service.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({Key? key}) : super(key: key);

  @override
  _VehicleRegistrationScreenState createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  File? _imageFile;
  final TextEditingController _vehicleNomeController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  List<Vehicle> vehicles = []; // Lista de veículos

  @override
  void initState() {
    super.initState();
    _updateVehicleList(); // Carregar a lista de veículos ao iniciar a tela
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateVehicleList() async {
    try {
      final List<Vehicle> updatedVehicles = await VehicleService.getVehicles();
      setState(() {
        vehicles = updatedVehicles;
      });
    } catch (error) {
      print('Erro ao carregar veículos: $error');
    }
  }

  void _editVehicle(Vehicle vehicle) {
    TextEditingController nomeController = TextEditingController(text: vehicle.nome);
    TextEditingController marcaController = TextEditingController(text: vehicle.marca);
    TextEditingController modeloController = TextEditingController(text: vehicle.modelo);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Editar Veículo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextFormField(
                  controller: modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Vehicle updatedVehicle = Vehicle(
                      id: vehicle.id,
                      nome: nomeController.text,
                      marca: marcaController.text,
                      modelo: modeloController.text,
                    );

                    await VehicleService.updateVehicle(
                      vehicleId: updatedVehicle.id,
                      nome: updatedVehicle.nome,
                      marca: updatedVehicle.marca,
                      modelo: updatedVehicle.modelo,
                    );

                    _updateVehicleList(); // Atualiza a lista após a edição do veículo
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Fechar o modal após salvar as alterações
                  },
                  child: const Text('Salvar Alterações'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _deleteVehicle(Vehicle vehicle) {
    VehicleService.deleteVehicle(vehicle.id)
      .then((_) {
        _updateVehicleList(); // Atualiza a lista após a exclusão do veículo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veículo excluído com sucesso')),
        );
      })
      .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao excluir o veículo')),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vehicle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              _imageFile != null ? Image.file(_imageFile!) : const Placeholder(),
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
                      setState(() {
                        _imageFile = null;
                      });

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
              VehicleListWidget(
                vehicles: vehicles,
                deleteVehicle: _deleteVehicle,
                updateList: (updatedList) {
                  setState(() {
                    vehicles = updatedList;
                  });
                },
                editVehicle: _editVehicle, // Passando a função de edição do veículo
              ),
            ],
          ),
        ),
      ),
    );
  }
}
