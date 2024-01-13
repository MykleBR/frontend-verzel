import 'package:flutter/material.dart';
import 'package:frontend/modules/vehicles/screens/vehicle_details_screen.dart';
import 'package:frontend/modules/vehicles/services/vehicle_service.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  late List<Vehicle> vehicles;

  @override
  void initState() {
    super.initState();
    _updateVehicleList();
  }

  Future<void> _updateVehicleList() async {
    try {
      final List<Vehicle> updatedVehicles = await VehicleService.getVehicles();
      setState(() {
        vehicles = updatedVehicles;
      });
    } catch (error) {
      // Trate os erros conforme necessário
    }
  }

  Future<void> _refreshVehicleList() async {
    await _updateVehicleList();
  }

  Future<void> _navigateToVehicleDetails(int vehicleId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailsScreen(vehicleId: vehicleId),
      ),
    );

    await _updateVehicleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Loja de Veiculos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVehicleList,
        child: ListView.builder(
          key: UniqueKey(),
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _navigateToVehicleDetails(vehicles[index].id),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                      child: Image.network(
                        vehicles[index].foto,
                        fit: BoxFit.cover,
                        height: 150, // Ajuste conforme necessário
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        vehicles[index].nome,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/login');
          await _updateVehicleList(); // Atualiza a lista após o cadastro
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
