import 'package:sm_web/infra/models/user.dart';

class DepartamentoModel {
  String? id;
  String? nombre;
  String? adminId;
  UsuarioModel? admin;

  DepartamentoModel({this.id, this.nombre, this.adminId, this.admin});

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) =>
      DepartamentoModel(
        id: json["ID"],
        nombre: json["NOMBRE"],
        adminId: json["ADMIN_ID"],
        admin: json["ADMIN"] != null
            ? UsuarioModel.fromJson(json["ADMIN"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "NOMBRE": nombre,
    "ADMIN_ID": adminId,
    "ADMIN": admin,
  };

  Map<String, dynamic> toJsonSession() => {
    "ID": id,
    "NOMBRE": nombre,
    "ADMIN_ID": adminId,
    "ADMIN": admin,
  };
}
