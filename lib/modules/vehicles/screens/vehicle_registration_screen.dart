import 'dart:convert';
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
  File? _editImageFile;
  final TextEditingController _vehicleNomeController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  List<Vehicle> vehicles = [];

  @override
  void initState() {
    super.initState();
    _updateVehicleList();
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
      // ignore: empty_catches
    } catch (error) {}
  }

  void _editVehicle(Vehicle vehicle) {
    TextEditingController nomeController =
        TextEditingController(text: vehicle.nome);
    TextEditingController marcaController =
        TextEditingController(text: vehicle.marca);
    TextEditingController modeloController =
        TextEditingController(text: vehicle.modelo);

    _editImageFile = null; // Reinicializa a variável ao abrir o modal de edição

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
                (_editImageFile == null)
                    ? Image.network(vehicle.foto)
                    : _editImageFile != null
                        ? Image.file(_editImageFile!)
                        : const Placeholder(),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile =
                        await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _editImageFile = File(pickedFile.path);
                      });
                    }
                  },
                  child: const Text('Escolher Nova Imagem'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Vehicle updatedVehicle = Vehicle(
                      id: vehicle.id,
                      nome: nomeController.text,
                      marca: marcaController.text,
                      modelo: modeloController.text,
                      foto: _editImageFile != null
                          ? 'data:image/png;base64,${base64Encode(_editImageFile!.readAsBytesSync())}'
                          : '',
                    );

                    await VehicleService.updateVehicle(
                      vehicleId: updatedVehicle.id,
                      nome: updatedVehicle.nome,
                      marca: updatedVehicle.marca,
                      modelo: updatedVehicle.modelo,
                      foto: updatedVehicle.foto,
                    );

                    _updateVehicleList();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
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
        _updateVehicleList();
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
        title: const Text('Registrar Veículo'),
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
              const SizedBox(height: 12),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
              ),
              const SizedBox(height: 12),
              _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Placeholder(
                      color: Colors.grey,
                      fallbackHeight: 150,
                      fallbackWidth: double.infinity,
                    ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _getImage,
                child: const Text('Escolher Imagem'),
              ),
              const SizedBox(height: 20),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleRegistrationScreen()),
                      );
                    } else {
                      // Handle no valid access token
                    }
                  } else {
                    // Show a warning if no image is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, selecione uma imagem')),
                    );
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
                editVehicle: _editVehicle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
