import 'package:flutter/material.dart';
import 'package:frontend/modules/vehicles/screens/vehicle_details_screen.dart';
import 'package:frontend/modules/vehicles/services/vehicle_service.dart';
import '../../../main.dart';


class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> with RouteAware {
  List<Vehicle> vehicles = []; // Lista de veículos

  @override
  void didPopNext() {
    // Esta função é chamada quando a rota da tela VehicleListScreen é reexibida após a navegação para outra tela
    _updateVehicleList(); // Atualiza a lista de veículos
  }

  Future<void> _updateVehicleList() async {
    try {
      final List<Vehicle> updatedVehicles = await VehicleService.getVehicles();
      setState(() {
        vehicles = updatedVehicles;
      });
    } catch (error) {
      // Trate qualquer erro de conexão ou carregamento
      print('Erro ao carregar veículos: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _updateVehicleList(); // Carrega a lista de veículos ao iniciar a tela
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route as PageRoute<dynamic>);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(vehicles[index].nome),
              // Ao clicar no item, navegue para a tela de detalhes do veículo
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleDetailsScreen(vehicleId: vehicles[index].id),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/login'); // Navegue para a tela de login
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
