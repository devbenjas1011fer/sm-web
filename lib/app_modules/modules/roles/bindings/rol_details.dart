import 'package:get/get.dart';

import '../controllers/rol_details.controller.dart';

class RolDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RolDetailController>(
      () => RolDetailController(),
    );
  }
}