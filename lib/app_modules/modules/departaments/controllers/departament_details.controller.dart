import 'package:get/get.dart';
import 'package:sm_web/app_modules/modules/departaments/controllers/departaments.controllers.dart';
import 'package:sm_web/infra/models/departamento.dart';
import '../services/departaments.service.dart';

class DepartamentDetailController extends GetxController {
  final DepartamentsServices services = DepartamentsServices();

  final RxBool isLoading = false.obs;

  final Rxn<DepartamentoModel> departamento = Rxn<DepartamentoModel>();

  late final String id;

  final RxBool isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();

    id = Get.parameters['id'] ?? '';

    if (id.isNotEmpty) {
      if (id != "new") {
        getDepartament();
        isEditing.value = true;
      } else {
        departamento.value = DepartamentoModel();
        isEditing.value = true;
      }
    }
  }

  Future<void> getDepartament() async {
    try {
      isLoading.value = true;

      final user = await services.getId(id);

      departamento.value = user;
    } catch (error) {
      departamento.value = null;
      Get.snackbar('Error', 'No fue posible obtener el departamento.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> up() async {
    try {
      isLoading.value = true;
      id == "new"
          ? await services.create(departamento.value!)
          : await services.up(id, departamento.value!);

      Get.rootDelegate.popRoute();
      await DepartamentsController.to.getDepartaments();
    } catch (error) {
      departamento.value = null;
      // print(error);
      Get.snackbar('Error', 'No fue posible obtener el departamento.');
    } finally {
      isLoading.value = false;
    }
  }
}
