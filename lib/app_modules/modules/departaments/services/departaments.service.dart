import 'package:sm_web/infra/http/api.dart';

import '../../../../infra/models/departamento.dart'; 

class DepartamentsServices {
  final ApiClient api = ApiClient('/ctrl/departaments');

  Future<List<DepartamentoModel>> get() async {
    final response = await api.get('/');

    if (response.status >= 200 && response.status < 300) {
      final data = response.data;

      if (data is List) {
        return data
            .map((user) => DepartamentoModel.fromJson(user as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('No fue posible obtener los usuarios.');
  }

  Future<DepartamentoModel> getId(String id) async {
    final response = await api.get('/$id');

    if (response.status >= 200 && response.status < 300) {
      return DepartamentoModel.fromJson(response.data);
    }

    throw Exception(
      response.data['message'] ?? 'No fue posible obtener el departamento.',
    );
  }

  Future<bool?> create(DepartamentoModel user) async {
    final response = await api.post('/', user.toJson());

    if (response.status >= 200 && response.status < 300) {
      return  response.data;
    }
    return false;
  }

  Future<DepartamentoModel?> up(String id, DepartamentoModel user) async {
    final response = await api.put('/$id', user.toJson());

    if (response.status >= 200 && response.status < 300) {
      return response.data!=null? DepartamentoModel.fromJson(response.data):null;
    }
    return null;
  }
}
