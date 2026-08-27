import 'package:get/get.dart';

import '../controllers/roles.controllers.dart';

class RolesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RolesController>(() => RolesController());
  }
}
