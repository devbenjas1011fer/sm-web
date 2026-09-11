import 'package:get/get.dart';
import 'package:sm_web/infra/models/departamento.dart';
import '../services/departaments.service.dart';

class DepartamentsController extends GetxController {
  static DepartamentsController get to => Get.find();
  final DepartamentsServices services = DepartamentsServices();
  final RxBool isLoading = false.obs;
  final RxList<DepartamentoModel> roles = <DepartamentoModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    getDepartaments();
  }

  Future<void> getDepartaments() async {
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