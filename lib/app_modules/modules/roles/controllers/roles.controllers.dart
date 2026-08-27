import 'package:get/get.dart';

import '../../../../infra/models/rol.dart'; 
import '../services/roles.service.dart';

class RolesController extends GetxController {
  static RolesController get to => Get.find();
  final RolesService services = RolesService();

  final RxBool isLoading = false.obs;

  final RxList<RolModel> roles = <RolModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    getRoles();
  }

  Future<void> getRoles() async {
    try {
      isLoading.value = true;

      final rols = await services.get();

      roles.assignAll(rols);
    } catch (error) {
      roles.clear();

      Get.snackbar(
        'Error',
        'No fue posible obtener los roles.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}