import 'dart:convert';
import 'dart:io';
import 'package:frontend/modules/authentication/services/auth_service.dart';
import 'package:http/http.dart' as http;

class Vehicle {
  final int id;
  final String nome;
  final String marca;
  final String modelo;

  Vehicle({
    required this.id,
    required this.nome,
    required this.marca,
    required this.modelo,
  });
}

class VehicleService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Seu endereço backend

  static Future<List<Vehicle>> getVehicles() async {
    final Uri vehiclesUrl = Uri.parse('$baseUrl/api/veiculos/');

    try {
      final response = await http.get(vehiclesUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((vehicle) {
          return Vehicle(
            id: vehicle['id'],
            nome: vehicle['nome'],
            marca: vehicle['marca'],
            modelo: vehicle['modelo'],
          );
        }).toList();
      } else {
        throw Exception('Falha ao carregar veículos');
      }
    } catch (error) {
      throw Exception('Erro de conexão: $error');
    }
  }

  static Future<Vehicle> getVehicleDetails(int vehicleId) async {
    final Uri vehicleUrl = Uri.parse('$baseUrl/api/veiculos/$vehicleId/');

    try {
      final response = await http.get(vehicleUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Vehicle(
          id: jsonData['id'],
          nome: jsonData['nome'],
          marca: jsonData['marca'],
          modelo: jsonData['modelo'],
        );
      } else {
        throw Exception('Falha ao carregar detalhes do veículo');
      }
    } catch (error) {
      throw Exception('Erro de conexão: $error');
    }
  }

  static Future<void> updateVehicle({
    required int vehicleId,
    required String nome,
    required String marca,
    required String modelo,
  }) async {
    final Uri updateUrl = Uri.parse('$baseUrl/api/veiculos/$vehicleId/');

    try {
      final authToken = AuthService.getAccessToken(); // Obtém o token de autenticação
      final Map<String, String> vehicleData = {
        'nome': nome,
        'marca': marca,
        'modelo': modelo,
      };

      final response = await http.put(
        updateUrl,
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(vehicleData),
      );

      if (response.statusCode == 200) {
        // Atualização bem-sucedida
      } else {
        // Tratar falha na atualização
      }
    } catch (error) {
      // Tratar erro de conexão ou outros erros
    }
  }

  static Future<void> deleteVehicle(int vehicleId) async {
    final Uri deleteUrl = Uri.parse('$baseUrl/api/veiculos/$vehicleId/');

    try {
      final authToken = AuthService.getAccessToken(); // Obtém o token de autenticação
      final response = await http.delete(
        deleteUrl,
        headers: <String, String>{
          'Authorization': 'Bearer $authToken', // Adiciona o token no cabeçalho
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete vehicle');
      }
    } catch (error) {
      throw Exception('Connection error: $error');
    }
  }
  
  static Future<void> signUpVehicle({
    required String nome,
    required String marca,
    required String modelo,
    required File imageFile,
    required String authToken, // Adicione o token de acesso como parâmetro
  }) async {
    final Uri signUpUrl = Uri.parse('$baseUrl/api/veiculos/');

    try {
      // Preparar os dados do veículo
      final Map<String, String> vehicleData = {
        'nome': nome,
        'marca': marca,
        'modelo': modelo,
      };

      // Criar a requisição HTTP do tipo multipart/form-data
      final request = http.MultipartRequest('POST', signUpUrl);

      // Configurar o cabeçalho com o token de acesso
      request.headers['authorization'] = 'Bearer $authToken';

      // Adicionar os dados do veículo à requisição
      vehicleData.forEach((key, value) {
        request.fields[key] = value;
      });

      // Adicionar a imagem como um arquivo multipart
      request.files.add(
        await http.MultipartFile.fromPath(
          'imagem', // Nome do campo no servidor
          imageFile.path,
        ),
      );

      // Enviar a requisição
      final response = await request.send();

      // Verificar o status da resposta
      if (response.statusCode == 201) {
        // Cadastro bem-sucedido
      } else {
        // Tratar falha no cadastro
      }
    } catch (error) {
      // Tratar erro de conexão ou outros erros
    }
  }
  
}
