import 'dart:io';

import 'package:flutter/material.dart';

class VehicleForm extends StatelessWidget {
  final File? imageFile;
  final Function() getImage;
  final TextEditingController vehicleNomeController;
  final TextEditingController marcaController;
  final TextEditingController modeloController;

  const VehicleForm({super.key, 
    required this.imageFile,
    required this.getImage,
    required this.vehicleNomeController,
    required this.marcaController,
    required this.modeloController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: vehicleNomeController,
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        TextFormField(
          controller: marcaController,
          decoration: const InputDecoration(labelText: 'Marca'),
        ),
        TextFormField(
          controller: modeloController,
          decoration: const InputDecoration(labelText: 'Modelo'),
        ),
        if (imageFile != null) Image.file(imageFile!),
        ElevatedButton(
          onPressed: getImage,
          child: const Text('Imagem'),
        ),
      ],
    );
  }
}
