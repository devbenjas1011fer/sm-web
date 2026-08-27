import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/infra/routes/app.routes.dart';

import '../controllers/users.controllers.dart';

class AdmUsuariosView extends GetView<UsersController> {
  const AdmUsuariosView({super.key});

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
                    Get.rootDelegate.toNamed('${AppRoutes.usuariosAdm}/new');
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Nuevo usuario'),
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
            child: controller.usuarios.isEmpty
                ? const Center(child: Text('No existen usuarios.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.usuarios.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final usuario = controller.usuarios[index];

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
                          title: Text(usuario.nombre ?? 'Sin nombre'),
                          subtitle: Text(usuario.email ?? 'Sin correo'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Get.rootDelegate.toNamed(
                              '/adm/usuarios/${usuario.id}',
                            );
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
