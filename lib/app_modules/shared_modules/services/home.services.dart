import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:flutter/foundation.dart';

import "../../../infra/http/api.dart";
import "../../../infra/models/modulos.dart";
import "../../../infra/routes/app.routes.dart";
import "../../../infra/storage/session.dart";

class MenuItemModel {
  final String title;
  final String route;
  final String iconKey;

  MenuItemModel({
    required this.title,
    required this.route,
    required this.iconKey,
  });
}

class HomeService extends GetxService {
  RxList<MenuItemModel> menuItems = <MenuItemModel>[].obs;
  final _api = ApiClient("/auth");
  RxString appSelected = AppRoutes.adm.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String path = "";
  RxString pathSelected = AppRoutes.usuariosAdm.obs;

  bool mobile =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  RxList<String> allowedClassOptions = <String>[].obs;

  static HomeService get to => Get.find();
  final Map<String, IconData> icons = {
    "USUARIOS": Icons.people,
    "ROLES": Icons.perm_device_info_sharp,
    "DEPARTAMENTOS": Icons.add_home_work_outlined,
  };

  @override
  void onInit() { 
    super.onInit();
    buildMenu(); 
  }
  Future<void> buildMenu() async {
    try {
      // 2. Petición directa al backend
      final response = await _api.post("/access-admin", {});

      if (response.status == 200) {
        List<ModuloModel> apiResponse = response.data != null
            ? (response.data as List)
                  .map((e) => ModuloModel.fromJson(e))
                  .toList()
            : [];
        menuItems.value = apiResponse.map((item) {
          String nombre = item.nombre ?? "";
          String nombreUpper = nombre.toUpperCase();
          String route = AppRoutes.usuariosAdm;
          if (nombreUpper == 'USUARIOS') route = AppRoutes.usuariosAdm;
          if (nombreUpper == 'ROLES') route = AppRoutes.rolesAdm;
          if (nombreUpper == 'DEPARTAMENTOS') route = AppRoutes.departaments;

          return MenuItemModel(
            title: nombre,
            route: route,
            iconKey: nombreUpper,
          );
        }).toList();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error al construir el menú: $e");
    }
  }
  Widget getIcon(String nombre) {
    String formattedName = nombre.toUpperCase().replaceAll('-', ' ');
    IconData iconData = icons[formattedName] ?? Icons.help_outline;
    return Icon(iconData);
  }

  void navigateTo(String route) {
    pathSelected.value = route;
    Get.rootDelegate.toNamed(route);
    if (mobile && scaffoldKey.currentState?.isDrawerOpen == true) {
      Get.back();
    }
  }

  Future<void> logout() async {
    await SessionStorage.erase();
    Get.rootDelegate.offNamed(AppRoutes.login);
  }
}
