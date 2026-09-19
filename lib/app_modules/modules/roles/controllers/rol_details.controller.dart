import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sm_web/app_modules/modules/roles/controllers/roles.controllers.dart';
import '../../../../infra/models/rol.dart';
import '../services/roles.service.dart';

class RolDetailController extends GetxController {
  final RolesService services = RolesService();

  final RxBool isLoading = false.obs;

  final Rxn<RolModel> rol = Rxn<RolModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final String id;

  final RxBool isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();

    id = Get.parameters['id'] ?? '';

    if (id.isNotEmpty) {
      if (id != "new") {
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

      final user = await services.getId(id);

      rol.value = user;
    } catch (error) {
      rol.value = null;
      Get.snackbar('Error', 'No fue posible obtener el rol.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> up() async {
    try {
      isLoading.value = true;
       id == "new"
          ? await services.create(rol.value!)
          : await services.up(id, rol.value!);

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
