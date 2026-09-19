import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../infra/models/user.dart';
import '../services/users.service.dart';

class UsuarioDetailController extends GetxController {
  final UsersService services = UsersService();

  final RxBool isLoading = false.obs;

  final Rxn<UsuarioModel> usuario = Rxn<UsuarioModel>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final String userId;

  final RxBool isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();

    userId = Get.parameters['id'] ?? '';

    if (userId.isNotEmpty) {
      if (userId != "new") {
        getUser();
        isEditing.value = true;
      } else {
        usuario.value = UsuarioModel();
        isEditing.value = true;
      }
    }
  }

  Future<void> getUser() async {
    try {
      isLoading.value = true;

      final user = await services.getId(userId);

      usuario.value = user;
    } catch (error) {
      usuario.value = null;

      Get.snackbar('Error', 'No fue posible obtener el usuario.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> up() async {
    try {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      isLoading.value = true;

      final user = (userId == "new")
          ? await services.create(usuario.value!)
          : await services.up(userId, usuario.value!);
      usuario.value = user;
      update();
    } catch (error) {
      usuario.value = null;

      Get.snackbar('Error', 'No fue posible obtener el usuario.');
    } finally {
      isLoading.value = false;
    }
  }
}
