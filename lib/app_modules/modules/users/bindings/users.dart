import 'package:get/get.dart';

import '../controllers/users.controllers.dart';

class AdmUsuariosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(() => UsersController());
  }
}
