import 'package:get/get.dart';
import 'package:sm_web/infra/http/api.dart';

import '../controllers/login.controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient('/auth'));

    Get.lazyPut<LoginController>(
      () => LoginController(api: Get.find<ApiClient>()),
    );
  }
}
