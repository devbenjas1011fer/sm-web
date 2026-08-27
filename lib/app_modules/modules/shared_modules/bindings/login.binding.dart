import 'package:get/get.dart';

import '../../../shared_modules/controllers/login.controller.dart';
import '../../../../infra/http/api.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient('/auth'));

    Get.lazyPut<LoginController>(
      () => LoginController(api: Get.find<ApiClient>()),
    );
  }
}
