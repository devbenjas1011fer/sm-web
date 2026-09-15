import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/rol_details.controller.dart';

enum ModuloPermiso { lectura, escritura, edicion, sinAcceso }

class RolDetailsView extends GetView<RolDetailController> {
  const RolDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Obx(() {
          final rol = controller.rol.value;

          return Text(
            rol?.nombre ?? 'Rol',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
        actions: [
          IconButton(
            onPressed: controller.up,
            icon: Icon(Icons.save_outlined, color: theme.colorScheme.primary),
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final rol = controller.rol.value;

        if (rol == null) {
          return const Center(child: Text('Rol no encontrado.'));
        }

        final modulos = rol.modulos ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del rol',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                initialValue: rol.nombre ?? '',
                enabled: controller.isEditing.value,
                onChanged: (value) {
                  rol.nombre = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre del rol',
                  prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Permisos de módulos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Define qué acciones puede realizar este rol en cada módulo.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 16),

              if (modulos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.extension_off_outlined,
                        size: 42,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No hay módulos disponibles.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < modulos.length; i++) ...[
                        _ModuloPermissionTile(
                          nombre: modulos[i].nombre ?? 'Módulo',
                          permiso: _getPermiso(modulos[i]),
                          enabled: controller.isEditing.value,
                          onChanged: (permiso) {
                            _setPermiso(modulos[i], permiso);
                            controller.rol.refresh();
                            controller.update();
                          },
                        ),
                        if (i < modulos.length - 1)
                          Divider(height: 1, color: Colors.grey.shade200),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  ModuloPermiso _getPermiso(dynamic modulo) {
    final permiso = modulo.permiso?.toString().toUpperCase();

    switch (permiso) {
      case 'LE':
        return ModuloPermiso.lectura;

      case 'ES':
        return ModuloPermiso.escritura;

      case 'ED':
        return ModuloPermiso.edicion;

      case 'SA':
      case null:
        return ModuloPermiso.sinAcceso;

      default:
        return ModuloPermiso.sinAcceso;
    }
  }

  void _setPermiso(dynamic modulo, ModuloPermiso permiso) {
    switch (permiso) {
      case ModuloPermiso.lectura:
        modulo.permiso = 'LE';
        break;

      case ModuloPermiso.escritura:
        modulo.permiso = 'ES';
        break;

      case ModuloPermiso.edicion:
        modulo.permiso = 'ED';
        break;

      case ModuloPermiso.sinAcceso:
        modulo.permiso = null;
        break;
    }
  }
}

class _ModuloPermissionTile extends StatelessWidget {
  final String nombre;
  final ModuloPermiso permiso;
  final bool enabled;
  final ValueChanged<ModuloPermiso> onChanged;

  const _ModuloPermissionTile({
    required this.nombre,
    required this.permiso,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.extension_outlined,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _descripcionPermiso(permiso),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          _PermissionSelector(
            value: permiso,
            enabled: enabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  String _descripcionPermiso(ModuloPermiso permiso) {
    switch (permiso) {
      case ModuloPermiso.lectura:
        return 'Puede consultar información';

      case ModuloPermiso.escritura:
        return 'Puede crear información';

      case ModuloPermiso.edicion:
        return 'Puede modificar información';

      case ModuloPermiso.sinAcceso:
        return 'No tiene acceso al módulo';
    }
  }
}

class _PermissionSelector extends StatelessWidget {
  final ModuloPermiso value;
  final bool enabled;
  final ValueChanged<ModuloPermiso> onChanged;

  const _PermissionSelector({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<ModuloPermiso>(
      enabled: enabled,
      onSelected: onChanged,
      tooltip: 'Cambiar permiso',
      position: PopupMenuPosition.under,
      itemBuilder: (context) {
        return [
          _menuItem(
            ModuloPermiso.lectura,
            Icons.visibility_outlined,
            'Lectura',
          ),
          _menuItem(
            ModuloPermiso.escritura,
            Icons.add_circle_outline,
            'Escritura',
          ),
          _menuItem(ModuloPermiso.edicion, Icons.edit_outlined, 'Edición'),
          _menuItem(
            ModuloPermiso.sinAcceso,
            Icons.block_outlined,
            'Sin acceso',
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconoPermiso(value),
              size: 18,
              color: _colorPermiso(value, theme),
            ),
            const SizedBox(width: 8),
            Text(
              _nombrePermiso(value),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<ModuloPermiso> _menuItem(
    ModuloPermiso permiso,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<ModuloPermiso>(
      value: permiso,
      child: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 12), Text(text)],
      ),
    );
  }

  String _nombrePermiso(ModuloPermiso permiso) {
    switch (permiso) {
      case ModuloPermiso.lectura:
        return 'Lectura';

      case ModuloPermiso.escritura:
        return 'Escritura';

      case ModuloPermiso.edicion:
        return 'Edición';

      case ModuloPermiso.sinAcceso:
        return 'Sin acceso';
    }
  }

  IconData _iconoPermiso(ModuloPermiso permiso) {
    switch (permiso) {
      case ModuloPermiso.lectura:
        return Icons.visibility_outlined;

      case ModuloPermiso.escritura:
        return Icons.add_circle_outline;

      case ModuloPermiso.edicion:
        return Icons.edit_outlined;

      case ModuloPermiso.sinAcceso:
        return Icons.block_outlined;
    }
  }

  Color _colorPermiso(ModuloPermiso permiso, ThemeData theme) {
    switch (permiso) {
      case ModuloPermiso.lectura:
        return theme.colorScheme.primary;

      case ModuloPermiso.escritura:
        return Colors.orange.shade700;

      case ModuloPermiso.edicion:
        return Colors.green.shade700;

      case ModuloPermiso.sinAcceso:
        return Colors.grey.shade600;
    }
  }
}
