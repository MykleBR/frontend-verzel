import 'package:flutter/material.dart';
import '../services/vehicle_service.dart';

class VehicleListWidget extends StatelessWidget {
  final Function(List<Vehicle>) updateList;
  final List<Vehicle> vehicles;
  final void Function(Vehicle vehicle) deleteVehicle; 
  final void Function(Vehicle vehicle) editVehicle;

  const VehicleListWidget({
    Key? key,
    required this.updateList,
    required this.vehicles,
    required this.deleteVehicle,
    required this.editVehicle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          var vehicle = vehicles[index];
          return ListTile(
            title: Text(vehicle.nome),
            subtitle: Text(vehicle.marca),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteVehicle(vehicle);
              },
            ),
            onTap: () {
              // Chama a função para abrir o modal de edição
              editVehicle(vehicle);
            },
          );
        },
      ),
    );
  }
}
