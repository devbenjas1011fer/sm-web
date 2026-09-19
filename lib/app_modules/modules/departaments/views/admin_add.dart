import 'package:flutter/material.dart';

import '../../../../infra/models/user.dart';
import '../../../../infra/utils/validaciones.dart';
import '../../../../widgets/campo_texto.dart';

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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CampoTexto(
                  label: "Nombre",
                  icon: Icons.person,
                  controller: _nombreController,
                  validator: (v) => Validaciones.nombre(v, campo: "El nombre"),
                ),
                const SizedBox(height: 15),
                CampoTexto.telefono(
                  label: "Número",
                  controller: _numeroController,
                ),
                const SizedBox(height: 15),
                CampoTexto.curp(controller: _curpController),
                const SizedBox(height: 15),
                CampoTexto(
                  label: "Dirección",
                  icon: Icons.location_on,
                  controller: _direccionController,
                  maxLines: 2,
                  validator: Validaciones.direccion,
                ),
                const SizedBox(height: 15),
                CampoTexto(
                  label: "Correo",
                  icon: Icons.email,
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validaciones.correo,
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
