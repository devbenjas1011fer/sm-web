import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/rol_details.controller.dart';

class RolDetailsView extends GetView<RolDetailController> {
  const RolDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final rol = controller.rol.value;

        if (rol == null) {
          return const Center(
            child: Text('Rol no encontrado.'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: Text(
              rol.nombre ?? 'Rol',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                onPressed: controller.up,
                icon: Icon(
                  Icons.save_outlined,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Guardar',
              ),
              IconButton(
                onPressed: () => Get.rootDelegate.popRoute(),
                icon: Icon(
                  Icons.close,
                  color: theme.colorScheme.primary,
                ),
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
                  'Información del rol',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                _EditableField(
                  label: 'Nombre del rol',
                  value: rol.nombre,
                  icon: Icons.admin_panel_settings_outlined,
                  enabled: controller.isEditing.value,
                  onChanged: (value) {
                    rol.nombre = value;
                  },
                ),
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
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}