import 'package:get/get.dart';

import '../controllers/usuario_details.controller.dart';

class AdmUsuarioDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsuarioDetailController>(
      () => UsuarioDetailController(),
    );
  }
}