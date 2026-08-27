import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:flutter/foundation.dart';
import "package:sm_web/infra/routes/app.routes.dart";

class HomeService extends GetxService {
  // List<Access> accessList = [];
  List<Widget> menu = [];
  RxString appSelected = AppRoutes.adm.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String path = "";
  RxString pathSelected = AppRoutes.usuariosAdm.obs;
  bool mobile =
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  RxList<String> allowedClassOptions = <String>[].obs;

  HomeService() {
    // if (AccessService.to.accessUser.isEmpty) {
    //   menuMobilBuild();
    // }
  }

  static HomeService get to => Get.find();
  Future<void> menuMobilBuild() async {}

  void handleDestinationSelected(int index) {
    // Get.rootDelegate.offNamed(allowedMenuOptions.elementAt(index));
  }

  final icons = {
    // ADMINISTRACIÓN
    "USUARIOS": Icons.account_box,
  };

  Icon getIcon(String nombre) {
    String formattedName = nombre.toUpperCase().replaceAll('-', ' ');
    return Icon(icons[formattedName] ?? Icons.help_outline);
  }

  Future<void> logout() async {
    // await GetStorage().erase();
    Get.rootDelegate.offNamed(AppRoutes.login);
  }
}
