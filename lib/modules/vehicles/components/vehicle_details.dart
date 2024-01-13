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
          return const Center(child: Text('sem dados disponíveis'));
        } else {
          final Vehicle vehicle = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Adiciona a exibição da imagem
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      vehicle.foto, // Assume que a propriedade 'foto' contém a URL da imagem
                      width: double.infinity, // Preenche a largura da tela
                      height: 300, // Ajuste conforme necessário
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                buildInfoTile('Nome', vehicle.nome),
                const SizedBox(height: 8.0),
                buildInfoTile('Marca', vehicle.marca),
                const SizedBox(height: 8.0),
                buildInfoTile('Modelo', vehicle.modelo),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
