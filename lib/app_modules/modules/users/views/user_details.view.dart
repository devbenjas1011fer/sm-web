import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/app_modules/modules/departaments/services/departaments.service.dart';
import 'package:sm_web/app_modules/modules/roles/services/roles.service.dart';
import 'package:sm_web/infra/models/departamento.dart';
import 'package:sm_web/infra/models/rol.dart';
import 'package:sm_web/infra/utils/validaciones.dart';
import 'package:sm_web/widgets/campo_texto.dart';
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
          body: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
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
                      child: CampoTexto(
                        label: 'Nombre',
                        icon: Icons.person_outline,
                        initialValue: usuario.nombre,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          usuario.nombre = value;
                        },
                        validator: (v) => Validaciones.nombre(v, campo: 'El nombre'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CampoTexto.telefono(
                        initialValue: usuario.numero,
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
                      child: CampoTexto.curp(
                        initialValue: usuario.curp,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          usuario.curp = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CampoTexto(
                        label: 'Correo',
                        icon: Icons.email_outlined,
                        initialValue: usuario.correo,
                        enabled: controller.isEditing.value,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          usuario.correo = value;
                        },
                        validator: Validaciones.correo,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                CampoTexto(
                  label: 'Dirección',
                  icon: Icons.location_on_outlined,
                  initialValue: usuario.direccion,
                  enabled: controller.isEditing.value,
                  onChanged: (value) {
                    usuario.direccion = value;
                  },
                  validator: Validaciones.direccion,
                ),

                const SizedBox(height: 32),
                FutureBuilder<List<RolModel>>(
                  future: RolesService().get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final roles = snapshot.data ?? [];

                    if (roles.isEmpty) {
                      return const Text('No hay roles disponibles');
                    }

                    RolModel? selected;

                    if (usuario.idRol != null) {
                      for (final r in roles) {
                        if (r.id == usuario.idRol) {
                          selected = r;
                          break;
                        }
                      }
                    }

                    return DropdownButtonFormField<RolModel>(
                      initialValue: selected,
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        border: OutlineInputBorder(),
                      ),
                      items: roles
                          .map(
                            (rol) => DropdownMenuItem<RolModel>(
                              value: rol,
                              child: Text(rol.nombre ?? ''),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        usuario.rol = value;
                        usuario.idRol = value?.id;
                      },
                      validator: Validaciones.valorRequerido<RolModel>(campo: 'El rol'),
                    );
                  },
                ),
                // AdminSelector(
                //   usuario: usuario,
                //   enabled: controller.isEditing.value,
                // ),

              ],
            ),
            ),
          ),
        );
      }),
    );
  }
}

class AdminSelector extends StatefulWidget {
  final dynamic usuario;
  final bool enabled;

  const AdminSelector({
    super.key,
    required this.usuario,
    required this.enabled,
  });

  @override
  State<AdminSelector> createState() => _AdminSelectorState();
}

class _AdminSelectorState extends State<AdminSelector> {
  final TextEditingController searchController = TextEditingController();

  List<DepartamentoModel> departamentos = [];
  List<DepartamentoModel> resultados = [];

  final Set<String> seleccionados = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadDepartamentos();
  }

  Future<void> _loadDepartamentos() async {
    try {
      final data = await DepartamentsServices().get();

      if (!mounted) return;

      setState(() {
        departamentos = data;

        // Si tu usuario ya trae departamentos:
        final actuales = widget.usuario.departamentos ?? [];

        for (final departamento in actuales) {
          if (departamento.id != null) {
            seleccionados.add(departamento.id!);
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

      resultados = departamentos
          .where((departamento) {
            final nombre = departamento.nombre?.toLowerCase() ?? '';
            return nombre.contains(query);
          })
          .where((departamento) {
            return !seleccionados.contains(departamento.id);
          })
          .take(8)
          .toList();
    });
  }

  void _select(DepartamentoModel departamento) {
    if (departamento.id == null) return;

    setState(() {
      seleccionados.add(departamento.id!);
      resultados = [];
      searchController.clear();
    });

    widget.usuario.departamentos ??= [];
    widget.usuario.departamentos.add(departamento);
  }

  void _remove(DepartamentoModel departamento) {
    if (departamento.id == null) return;

    setState(() {
      seleccionados.remove(departamento.id);
    });

    widget.usuario.departamentos?.removeWhere(
      (item) => item.id == departamento.id,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final seleccionadosModel = departamentos
        .where((departamento) => seleccionados.contains(departamento.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departamentos',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Selecciona uno o varios departamentos donde el usuario trabaja.',
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
        else ...[
          TextField(
            controller: searchController,
            enabled: widget.enabled,
            onChanged: _search,
            decoration: InputDecoration(
              labelText: 'Buscar departamento',
              hintText: 'Nombre del departamento',
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
                children: resultados.map((departamento) {
                  return InkWell(
                    onTap: () => _select(departamento),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            child: Text(_initial(departamento.nombre)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              departamento.nombre ?? 'Sin nombre',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(Icons.add, color: theme.colorScheme.primary),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          if (seleccionadosModel.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Departamentos asignados',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: seleccionadosModel.map((departamento) {
                return InputChip(
                  avatar: const Icon(Icons.business_outlined, size: 18),
                  label: Text(departamento.nombre ?? 'Sin nombre'),
                  onDeleted: widget.enabled
                      ? () => _remove(departamento)
                      : null,
                );
              }).toList(),
            ),
          ],

          if (seleccionadosModel.isEmpty && searchController.text.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'No hay departamentos asignados.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),

          if (resultados.isEmpty && searchController.text.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'No se encontraron departamentos.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
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
