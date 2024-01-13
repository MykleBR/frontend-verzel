import 'package:flutter/material.dart';
import 'package:frontend/modules/vehicles/components/vehicle_details.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final int vehicleId;

  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Veículo'),
      ),
      body: Center(
        child: VehicleDetails(vehicleId: vehicleId), // Widget para detalhes do veículo
      ),
    );
  }
}
