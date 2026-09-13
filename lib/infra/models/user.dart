import 'package:sm_web/infra/models/rol.dart';

class UsuarioModel {
  String? id;
  String? nombre;
  String? numero;
  String? curp;
  String? direccion;
  RolModel? rol;
  String? idRol;
  String? correo;

  UsuarioModel({
    this.id,
    this.nombre,
    this.numero,
    this.curp,
    this.direccion,
    this.correo,
    this.rol,
    this.idRol,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
    id: json["ID"],
    nombre: json["NOMBRES"],
    numero: json["NUMERO"],
    curp: json["CURP"],
    direccion: json["DIRECCION"],
    correo: json["CORREO"],
    rol: json["ROL"]!=null?RolModel.fromJson(json["ROL"]):null,
    idRol: json["ROL_ID"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "NOMBRES": nombre,
    "NUMERO": numero,
    "CURP": curp,
    "DIRECCION": direccion,
    "ROL_ID": idRol,
    "ROL": rol?.toJson(),
    "CORREO": correo,
  };

  Map<String, dynamic> toJsonSession() => {"ID": id, "NOMBRES": nombre};
}
