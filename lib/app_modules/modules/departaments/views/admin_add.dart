import 'package:flutter/material.dart';

import '../../../../infra/models/user.dart';

class AdmAdd extends StatefulWidget {
  const AdmAdd({super.key});

  @override
  State<AdmAdd> createState() => _AdmAddState();
}

class _AdmAddState extends State<AdmAdd> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _numeroController = TextEditingController();
  final _curpController = TextEditingController();
  final _direccionController = TextEditingController();
  final _correoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _numeroController.dispose();
    _curpController.dispose();
    _direccionController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final usuario = UsuarioModel(
      nombre: _nombreController.text.trim(),
      numero: _numeroController.text.trim(),
      curp: _curpController.text.trim(),
      direccion: _direccionController.text.trim(),
      correo: _correoController.text.trim(),
    );

    // ClinicaDetailController.to.addAdmin(usuario);

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Agregar administrador"),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: _input("Nombre", Icons.person),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese el nombre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _numeroController,
                  keyboardType: TextInputType.phone,
                  decoration: _input("Número", Icons.phone),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese el número";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _curpController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: _input("CURP", Icons.badge),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese la CURP";
                    }

                    if (value.trim().length != 18) {
                      return "La CURP debe contener 18 caracteres";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _direccionController,
                  maxLines: 2,
                  decoration: _input("Dirección", Icons.location_on),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese la dirección";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _input("Correo", Icons.email),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Ingrese el correo";
                    }

                    final regex =
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                    if (!regex.hasMatch(value.trim())) {
                      return "Correo inválido";
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        FilledButton.icon(
          onPressed: _guardar,
          icon: const Icon(Icons.save),
          label: const Text("Guardar"),
        ),
      ],
    );
  }
}