import 'package:get/get.dart';

import '../controllers/departaments.controllers.dart';

class DepartamentsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepartamentsController>(() => DepartamentsController());
  }
}
