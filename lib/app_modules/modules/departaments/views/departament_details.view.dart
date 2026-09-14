import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/infra/models/user.dart';

import '../../users/services/users.service.dart';
import '../controllers/departament_details.controller.dart';

class DepartamentDetailsView extends GetView<DepartamentDetailController> {
  const DepartamentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final departamento = controller.departamento.value;

        if (departamento == null) {
          return const Center(child: Text('Departamento no encontrado.'));
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            title: Text(
              departamento.nombre ?? 'Departamento',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              departamento.departamentoId!=null?IconButton(
                onPressed: controller.up,
                icon: Icon(
                  Icons.save_outlined,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Guardar',
              ):Container(),
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
                  'Información del departamento',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _EditableField(
                  label: 'Nombre del departamento',
                  value: departamento.nombre,
                  icon: Icons.admin_panel_settings_outlined,
                  enabled: controller.isEditing.value,
                  onChanged: (value) {
                    departamento.nombre = value;
                  },
                ),
                const SizedBox(height: 24),
                DepartamentsUser(
                  departamento: departamento,
                  enabled: controller.isEditing.value,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class DepartamentsUser extends StatefulWidget {
  final dynamic departamento;
  final bool enabled;

  const DepartamentsUser({
    super.key,
    required this.departamento,
    required this.enabled,
  });

  @override
  State<DepartamentsUser> createState() => _DepartamentsUserState();
}

class _DepartamentsUserState extends State<DepartamentsUser> {
  final TextEditingController searchController = TextEditingController();

  List<UsuarioModel> usuarios = [];
  List<UsuarioModel> resultados = [];

  UsuarioModel? seleccionado;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final data = await UsersService().get();

      if (!mounted) return;

      setState(() {
        usuarios = data;

        if (widget.departamento.adminId != null) {
          for (final usuario in usuarios) {
            if (usuario.id == widget.departamento.adminId) {
              seleccionado = usuario;
              break;
            }
          }
        }

        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  void _search(String value) {
    final query = value.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        resultados = [];
        return;
      }

      resultados = usuarios
          .where((usuario) {
            final nombre = usuario.nombre?.toLowerCase() ?? '';
            final correo = usuario.correo?.toLowerCase() ?? '';
            final numero = usuario.numero?.toLowerCase() ?? '';

            return nombre.contains(query) ||
                correo.contains(query) ||
                numero.contains(query);
          })
          .where((usuario) {
            return usuario.id != seleccionado?.id;
          })
          .take(8)
          .toList();
    });
  }

  void _select(UsuarioModel usuario) {
    setState(() {
      seleccionado = usuario;
      resultados = [];
      searchController.clear();
    });

    widget.departamento.admin = usuario;
    widget.departamento.adminId = usuario.id;
  }

  void _remove() {
    setState(() {
      seleccionado = null;
    });

    widget.departamento.admin = null;
    widget.departamento.adminId = null;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Administrador del departamento',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Selecciona el usuario responsable de administrar este departamento.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (seleccionado != null)
          _SelectedDepartament(
            usuario: seleccionado!,
            enabled: widget.enabled,
            onRemove: _remove,
          )
        else
          Column(
            children: [
              TextField(
                controller: searchController,
                enabled: widget.enabled,
                onChanged: _search,
                decoration: InputDecoration(
                  labelText: 'Buscar administrador',
                  hintText: 'Nombre, correo o número',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            _search('');
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (resultados.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.surface,
                  ),
                  child: Column(
                    children: resultados.map((usuario) {
                      return InkWell(
                        onTap: () => _select(usuario),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: Text(
                                  _initial(usuario.nombre),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      usuario.nombre ?? 'Sin nombre',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    if (usuario.correo != null)
                                      Text(
                                        usuario.correo!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ] else if (searchController.text.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'No se encontraron usuarios.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  String _initial(String? nombre) {
    if (nombre == null || nombre.trim().isEmpty) {
      return '?';
    }

    return nombre.trim().substring(0, 1).toUpperCase();
  }
}

class _SelectedDepartament extends StatelessWidget {
  final UsuarioModel usuario;
  final bool enabled;
  final VoidCallback onRemove;

  const _SelectedDepartament({
    required this.usuario,
    required this.enabled,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: .35),
        ),
        color: theme.colorScheme.primary.withValues(alpha: .05),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            child: Text(
              _initial(usuario.nombre),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nombre ?? 'Sin nombre',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (usuario.correo != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    usuario.correo!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (enabled)
            IconButton(
              tooltip: 'Quitar administrador',
              onPressed: onRemove,
              icon: Icon(Icons.close, color: theme.colorScheme.error),
            ),
        ],
      ),
    );
  }

  String _initial(String? nombre) {
    if (nombre == null || nombre.trim().isEmpty) {
      return '?';
    }

    return nombre.trim().substring(0, 1).toUpperCase();
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
