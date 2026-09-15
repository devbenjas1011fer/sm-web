import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/infra/models/user.dart';

import '../controllers/departament_details.controller.dart';

class DepartamentDetailsView extends GetView<DepartamentDetailController> {
  const DepartamentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar( backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
           
        actions: [
          DepartamentDetailController.to.departamento.value?.departamentoId != null ||Get.parameters["id"]=="new"
              ? IconButton(
                  onPressed: controller.up,
                  icon: Icon(
                    Icons.save_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  tooltip: 'Guardar',
                )
              : Container(),
          IconButton(
            onPressed: () => Get.rootDelegate.popRoute(),
            icon: Icon(Icons.close, color: theme.colorScheme.primary),
            tooltip: 'Cerrar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final departamento = controller.departamento.value;
        departamento?.admin ??= UsuarioModel();

        if (departamento == null) {
          return const Center(child: Text('Departamento no encontrado.'));
        } 
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 24,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departamento.nombre ?? 'Departamento',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Detalle del departamento',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            actions: [const SizedBox(width: 16)],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.business_outlined,
                              size: 21,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Información del departamento',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        initialValue: departamento.nombre,
                        enabled: controller.isEditing.value,
                        onChanged: (value) {
                          departamento.nombre = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nombre del departamento',
                          prefixIcon: const Icon(Icons.business_outlined),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.admin_panel_settings_outlined,
                              size: 21,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Administrador',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: departamento.admin?.nombre,
                                  enabled: controller.isEditing.value,
                                  onChanged: (value) {
                                    departamento.admin?.nombre = value;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Nombre',
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  initialValue: departamento.admin?.numero,
                                  enabled: controller.isEditing.value,
                                  onChanged: (value) {
                                    departamento.admin?.numero = value;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Número',
                                    prefixIcon: const Icon(
                                      Icons.phone_outlined,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: departamento.admin?.curp,
                                  enabled: controller.isEditing.value,
                                  onChanged: (value) {
                                    departamento.admin?.curp = value.toUpperCase();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'CURP',
                                    prefixIcon: const Icon(
                                      Icons.badge_outlined,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  initialValue: departamento.admin?.correo,
                                  enabled: controller.isEditing.value,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) {
                                    departamento.admin?.correo = value;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Correo',
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: departamento.admin?.direccion,
                            enabled: controller.isEditing.value,
                            maxLines: 2,
                            onChanged: (value) {
                              departamento.admin?.direccion = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Dirección',
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
