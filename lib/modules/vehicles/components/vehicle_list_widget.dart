import 'package:flutter/material.dart';
import '../services/vehicle_service.dart';

class VehicleListWidget extends StatelessWidget {
  final Function(List<Vehicle>) updateList;
  final List<Vehicle> vehicles;

  const VehicleListWidget({
    Key? key,
    required this.updateList,
    required this.vehicles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4, // Defina uma altura máxima
      child: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          var vehicle = vehicles[index];
          return ListTile(
            title: Text(vehicle.nome),
            subtitle: Text(vehicle.marca),
            onTap: () {
              VehicleService.deleteVehicle(vehicle.id)
                  .then((_) {
                updateList(vehicles.where((element) => element.id != vehicle.id).toList());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veículo excluído com sucesso')),
                );
              })
                  .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Falha ao excluir o veículo')),
                );
              });
            },
          );
        },
      ),
    );
  }
}
