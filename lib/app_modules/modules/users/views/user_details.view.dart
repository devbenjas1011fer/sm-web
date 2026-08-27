import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/usuario_details.controller.dart';

class AdmUsuarioDetailView extends GetView<UsuarioDetailController> {
  const AdmUsuarioDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final usuario = controller.usuario.value;

        if (usuario == null) {
          return const Center(child: Text('Usuario no encontrado.'));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: Text(
              usuario.nombre ?? 'Usuario',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.up();
                },
                icon: Icon(
                  Icons.save_outlined,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Guardar',
              ),
              IconButton(
                onPressed: () => Get.rootDelegate.popRoute(),
                icon: Icon(Icons.close, color: theme.colorScheme.primary),
                tooltip: 'Cerrar',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información personal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _EditableField(
                        label: 'Nombre',
                        value: usuario.nombre,
                        icon: Icons.person_outline,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          usuario.nombre = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _EditableField(
                        label: 'Número',
                        value: usuario.numero,
                        icon: Icons.phone_outlined,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          usuario.numero = value;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _EditableField(
                        label: 'CURP',
                        value: usuario.curp,
                        icon: Icons.badge_outlined,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          usuario.curp = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _EditableField(
                        label: 'Correo',
                        value: usuario.email,
                        icon: Icons.email_outlined,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          usuario.email = value;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _EditableField(
                  label: 'Dirección',
                  value: usuario.direccion,
                  icon: Icons.location_on_outlined,
                  enabled: controller.isEditing.value,
                  onChanged: (value) {
                    usuario.direccion = value;
                  },
                ),

                const SizedBox(height: 32),

                // Text(
                //   'Seguridad',
                //   style: theme.textTheme.titleMedium?.copyWith(
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),

                // const SizedBox(height: 16),

                // Card(
                //   child: Padding(
                //     padding: const EdgeInsets.all(20),
                //     child: Row(
                //       children: [
                //         Container(
                //           padding: const EdgeInsets.all(12),
                //           decoration: BoxDecoration(
                //             color: theme.colorScheme.primary.withValues(
                //               alpha: 0.10,
                //             ),
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //           child: Icon(
                //             Icons.lock_reset,
                //             color: theme.colorScheme.primary,
                //           ),
                //         ),

                //         const SizedBox(width: 16),

                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 'Contraseña',
                //                 style: theme.textTheme.titleMedium?.copyWith(
                //                   fontWeight: FontWeight.w600,
                //                 ),
                //               ),
                //               const SizedBox(height: 4),
                //               Text(
                //                 'Restablecer las credenciales de acceso del usuario.',
                //                 style: theme.textTheme.bodyMedium,
                //               ),
                //             ],
                //           ),
                //         ),

                //         const SizedBox(width: 16),

                //         OutlinedButton.icon(
                //           onPressed: () {
                //             // Restablecer contraseña
                //           },
                //           icon: const Icon(Icons.lock_reset),
                //           label: const Text('Restablecer'),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _EditableField({
    required this.label,
    required this.value,
    required this.icon,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value ?? '',
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
