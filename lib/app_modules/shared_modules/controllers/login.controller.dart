import 'package:get/get.dart';
import 'package:sm_web/infra/http/api.dart';
import '../../../infra/storage/session.dart';
import '../services/home.services.dart';

class LoginController extends GetxController {
  LoginController({required this._api});

  final ApiClient _api;

  final isLoading = false.obs;

  final email = ''.obs;
  final password = ''.obs;

  Future<void> login() async {
    if (email.value.trim().isEmpty) {
      Get.snackbar('Atención', 'Ingresa tu correo electrónico.');
      return;
    }

    if (password.value.isEmpty) {
      Get.snackbar('Atención', 'Ingresa tu contraseña.');
      return;
    }

    if (isLoading.value) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await _api.post("/login", {
        'email': email.value.trim(),
        'password': password.value,
      });

      if (response.status >= 200 && response.status < 300) {
        if (!SessionStorage.hasSession) {
          Get.snackbar('Error', 'El servidor no devolvió un token de sesión.');

          return;
        }
        final path = HomeService.to.pathSelected.value;
        await Get.rootDelegate.offNamed(path);

        return;
      }

      Get.snackbar('No se pudo iniciar sesión', response.message);
    } catch (e) {
      Get.snackbar('Error', 'No fue posible conectar con el servidor.');
    } finally {
      isLoading.value = false;
    }
  }
}
