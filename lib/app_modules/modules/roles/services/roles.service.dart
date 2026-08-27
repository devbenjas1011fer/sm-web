import 'package:sm_web/infra/http/api.dart';
import 'package:sm_web/infra/models/rol.dart';

class RolesService {
  final ApiClient api = ApiClient('/ctrl/roles');

  Future<List<RolModel>> get() async {
    final response = await api.get('/');

    if (response.status >= 200 && response.status < 300) {
      final data = response.data["data"];

      if (data is List) {
        return data
            .map((user) => RolModel.fromJson(user as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('No fue posible obtener los usuarios.');
  }

  Future<RolModel> getId(String id) async {
    final response = await api.get('/$id');

    if (response.status >= 200 && response.status < 300) {
      return RolModel.fromJson(response.data['data']);
    }

    throw Exception(
      response.data['message'] ?? 'No fue posible obtener el usuario.',
    );
  }

  Future<RolModel?> create(RolModel user) async {
    final response = await api.post('/', user.toJson());

    if (response.status >= 200 && response.status < 300) {
      return RolModel.fromJson(response.data['data']);
    }
    return null;
  }

  Future<RolModel?> up(String id, RolModel user) async {
    final response = await api.put('/$id', user.toJson());

    if (response.status >= 200 && response.status < 300) {
      return RolModel.fromJson(response.data['data']);
    }
    return null;
  }
}
