import 'package:flutter/material.dart';
import 'package:frontend/modules/vehicles/screens/vehicle_details_screen.dart';
import 'package:frontend/modules/vehicles/services/vehicle_service.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future: VehicleService.getVehicles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No vehicles available'));
        } else {
          var vehicles = snapshot.data!;

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              var vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle.nome),
                subtitle: Text(vehicle.marca),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailsScreen(vehicleId: vehicle.id),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
