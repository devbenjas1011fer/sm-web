import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/app_modules/modules/roles/controllers/roles.controllers.dart';

import '../../../../infra/routes/app.routes.dart';

class RolesView extends GetView<RolesController> {
  const RolesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Spacer(),

                // TextButton.icon(
                //   onPressed: () {
                //     // controller.exportarUsuarios();
                //   },
                //   icon: const Icon(Icons.download_outlined, size: 18),
                //   label: const Text('Exportar'),
                //   style: TextButton.styleFrom(
                //     minimumSize: const Size(0, 32),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 10,
                //       vertical: 0,
                //     ),
                //     visualDensity: const VisualDensity(
                //       horizontal: -2,
                //       vertical: -2,
                //     ),
                //   ),
                // ),

                // const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () {
                    Get.rootDelegate.toNamed('${AppRoutes.rolesAdm}/new');
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Nuevo rol'),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: -2,
                      vertical: -2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: controller.roles.isEmpty
                ? const Center(child: Text('No existen roles.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.roles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final rol = controller.roles[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.10),
                            child: Icon(
                              Icons.person_outline,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(rol.nombre ?? 'Sin nombre'),
                          subtitle: Text(rol.email ?? 'Sin correo'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Get.rootDelegate.toNamed('/adm/roles/${rol.id}');
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
