import 'package:sm_web/infra/http/api.dart';

import '../../../../infra/models/user.dart';

class UsersService {
  final ApiClient api = ApiClient('/ctrl/users');

  Future<List<UsuarioModel>> get() async {
    final response = await api.get('/');

    if (response.status >= 200 && response.status < 300) {
      final data = response.data["data"];

      if (data is List) {
        return data
            .map((user) => UsuarioModel.fromJson(user as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('No fue posible obtener los usuarios.');
  }

  Future<UsuarioModel> getId(String id) async {
    final response = await api.get('/$id');

    if (response.status >= 200 && response.status < 300) {
      return UsuarioModel.fromJson(response.data['data']);
    }

    throw Exception(
      response.data['message'] ?? 'No fue posible obtener el usuario.',
    );
  }

  Future<UsuarioModel?> create(UsuarioModel user) async {
    final response = await api.post('/', user.toJson());

    if (response.status >= 200 && response.status < 300) {
      return UsuarioModel.fromJson(response.data['data']);
    }
    return null;
  }

  Future<UsuarioModel?> up(String id, UsuarioModel user) async {
    final response = await api.put('/$id', user.toJson());

    if (response.status >= 200 && response.status < 300) {
      return UsuarioModel.fromJson(response.data['data']);
    }
    return null;
  }
}
