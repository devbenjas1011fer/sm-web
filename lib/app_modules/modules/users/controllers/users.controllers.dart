import 'package:get/get.dart';

import '../../../../infra/models/user.dart';
import '../services/users.service.dart';

class UsersController extends GetxController {
  static UsersController get to => Get.find();
  final UsersService services = UsersService();

  final RxBool isLoading = false.obs;

  final RxList<UsuarioModel> usuarios = <UsuarioModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    getUsers();
  }

  Future<void> getUsers() async {
    try {
      isLoading.value = true;

      final users = await services.get();

      usuarios.assignAll(users);
    } catch (error) {
      usuarios.clear();

      Get.snackbar(
        'Error',
        'No fue posible obtener los usuarios.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}