import 'package:flutter/material.dart';
import 'package:frontend/modules/authentication/screens/login_screen.dart';
import 'package:frontend/modules/authentication/screens/signup_screen.dart';
import 'package:frontend/modules/user_profile/screens/user_profile_screen.dart';
import 'package:frontend/modules/vehicles/screens/vehicle_list_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      initialRoute: '/', // Rota inicial do seu aplicativo
      navigatorObservers: [routeObserver], // Adicione o RouteObserver
      routes: {
        '/': (context) => const VehicleListScreen(), // Exemplo de rota para tela de lista de veículos
        '/login': (context) => const LoginScreen(), // Exemplo de rota para tela de login
        '/signup': (context) => const SignUpScreen(),
        '/profile': (context) => const UserProfileScreen(), // Exemplo de rota para tela de perfil
        // Adicione mais rotas conforme necessário para suas telas
      },
    );
  }
}