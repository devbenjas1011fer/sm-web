import 'package:get/get.dart';

import '../controllers/departament_details.controller.dart';

class DepartamentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepartamentDetailController>(
      () => DepartamentDetailController(),
    );
  }
}