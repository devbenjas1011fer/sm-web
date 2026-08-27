import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/infra/routes/app.routes.dart';

import '../../../widgets/profile_menu.dart';
import '../services/home.services.dart';

class HomeView extends GetView<HomeService> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        return Scaffold(
          key: HomeService.to.scaffoldKey,

          drawer: controller.mobile ? Drawer(child: _buildMenu()) : null,

          appBar: AppBar(
            backgroundColor: Get.theme.colorScheme.primary,
            centerTitle: false,
            title: const Text(
              'Panel Administrativo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: const [ProfileMenuWidget()],
          ),

          body: Row(
            children: [
              // Menú lateral (solo escritorio)
              if (!controller.mobile) SizedBox(width: 260, child: _buildMenu()),

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
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Usuarios"),
            onTap: () {
              Get.rootDelegate.toNamed(AppRoutes.usuariosAdm);
            },
          ),

          // ListTile(
          //   leading: const Icon(Icons.admin_panel_settings),
          //   title: const Text('Roles'),
          //   onTap: () {
          //     Get.rootDelegate.toNamed(
          //       "",
          //       // AppRoutes.rolesAdm,
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.perm_device_info_sharp),
            title: const Text("Roles"),
            onTap: () {
              Get.rootDelegate.toNamed(AppRoutes.rolesAdm);
            },
          ),

          
        ],
      ),
    );
  }
}
