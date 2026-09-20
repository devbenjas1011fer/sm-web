import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infra/routes/app.routes.dart';
import '../../../infra/storage/session.dart';
import '../../../widgets/profile_menu.dart';
import '../services/home.services.dart';

class HomeView extends GetView<HomeService> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        return Scaffold(
          drawer: controller.mobile ? Drawer(child: _buildMenu()) : null,

          appBar: AppBar(
            backgroundColor: Get.theme.colorScheme.primary,
            centerTitle: false,
            title: Text(
              "PANEL ${SessionStorage.session?.clinica?.nombre ?? " ADMINISTRATÍVO"}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: const [ProfileMenuWidget()],
          ),

          body: Row(
            children: [
              if (!controller.mobile)
                SizedBox(
                  width: 260,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                    child: _buildMenu(),
                  ),
                ),

              Expanded(
                child: GetRouterOutlet(
                  delegate: delegate,
                  anchorRoute: AppRoutes.adm,
                  initialRoute: AppRoutes.usuariosAdm,
                  navigatorKey: Get.nestedKey("home"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenu() {
    return Material(
      child: Obx(() {
        if (controller.menuItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: controller.menuItems.length,
          itemBuilder: (context, index) {
            final item = controller.menuItems[index];

            return Obx(() {
              final isSelected = controller.pathSelected.value == item.route;

              return ListTile(
                selected: isSelected,
                selectedTileColor: Get.theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                leading: controller.getIcon(item.iconKey),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                onTap: () => controller.navigateTo(item.route),
              );
            });
          },
        );
      }),
    );
  }
}
