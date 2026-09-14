import 'package:sm_web/infra/models/user.dart';

class DepartamentoModel {
  String? id;
  String? nombre;
  String? adminId;
  String? departamentoId;
  DepartamentoModel?departamento;
  UsuarioModel? admin;

  DepartamentoModel({this.id, this.nombre, this.departamentoId, this.departamento,this.adminId, this.admin});

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) =>
      DepartamentoModel(
        id: json["ID"],
        nombre: json["NOMBRE"],
        adminId: json["ADMIN_ID"],
        departamentoId:json["DEPARTAMENTO_ID"],
        departamento: json["DEPARTAMENTO"] != null
            ? DepartamentoModel.fromJson(json["DEPARTAMENTO"])
            : null,
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

  Map<String, dynamic> toJsonUSer() => {
    "ID": id,
  };

  Map<String, dynamic> toJsonSession() => {
    "ID": id,
    "NOMBRE": nombre,
    "ADMIN_ID": adminId,
    "ADMIN": admin,
  };
}
