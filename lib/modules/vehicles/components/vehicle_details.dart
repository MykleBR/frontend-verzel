import 'package:flutter/material.dart';
import 'package:frontend/modules/vehicles/services/vehicle_service.dart';

class VehicleDetails extends StatelessWidget {
  final int vehicleId;

  const VehicleDetails({Key? key, required this.vehicleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: VehicleService.getVehicleDetails(vehicleId),
      builder: (BuildContext context, AsyncSnapshot<Vehicle> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          final Vehicle vehicle = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nome: ${vehicle.nome}'),
                const SizedBox(height: 8.0),
                Text('Marca: ${vehicle.marca}'),
                const SizedBox(height: 8.0),
                Text('Modelo: ${vehicle.modelo}'),
              ],
            ),
          );
        }
      },
    );
  }
}
