import 'package:get/get.dart';
import 'package:sm_web/app_modules/modules/roles/controllers/roles.controllers.dart';
import '../../../../infra/models/rol.dart';
import '../services/roles.service.dart';

class RolDetailController extends GetxController {
  final RolesService services = RolesService();

  final RxBool isLoading = false.obs;

  final Rxn<RolModel> rol = Rxn<RolModel>();

  late final String userId;

  final RxBool isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();

    userId = Get.parameters['id'] ?? '';

    if (userId.isNotEmpty) {
      if (userId != "new") {
        getRol();
        isEditing.value = true;
      } else {
        rol.value = RolModel();
        isEditing.value = true;
      }
    }
  }

  Future<void> getRol() async {
    try {
      isLoading.value = true;

      final user = await services.getId(userId);

      rol.value = user;
    } catch (error) {
      rol.value = null;
      print(error);
      Get.snackbar('Error', 'No fue posible obtener el rol.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> up() async {
    try {
      isLoading.value = true;

      Get.rootDelegate.popRoute();
      await RolesController.to.getRoles();
    } catch (error) {
      rol.value = null;
      // print(error);
      Get.snackbar('Error', 'No fue posible obtener el rol.');
    } finally {
      isLoading.value = false;
    }
  }
}
