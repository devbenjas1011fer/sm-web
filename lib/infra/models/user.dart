
import '../../../../infra/models/departamento.dart';
import '../../../../infra/models/rol.dart';

class UsuarioModel {
  String? id;
  String? nombre;
  String? numero;
  String? curp;
  String? direccion;
  String? correo;

  RolModel? rol;
  String? idRol;

  List<DepartamentoModel> departamentos;

  UsuarioModel({
    this.id,
    this.nombre,
    this.numero,
    this.curp,
    this.direccion,
    this.correo,
    this.rol,
    this.idRol,
    this.departamentos = const [],
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) =>
      UsuarioModel(
        id: json["ID"],
        nombre: json["NOMBRES"],
        numero: json["NUMERO"],
        curp: json["CURP"],
        direccion: json["DIRECCION"],
        correo: json["CORREO"],
        rol: json["ROL"] != null
            ? RolModel.fromJson(json["ROL"])
            : null,
        idRol: json["ROL_ID"],
        departamentos: json["DEPARTAMENTOS"] != null
            ? (json["DEPARTAMENTOS"] as List)
                .map(
                  (e) => DepartamentoModel.fromJson(e),
                )
                .toList()
            : [],
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
        "DEPARTAMENTOS": departamentos
            .map((e) => e.toJson())
            .toList(),
      };

  Map<String, dynamic> toJsonSession() => {
        "ID": id,
        "NOMBRES": nombre,
        "CORREO": nombre,
        "DEPARTAMENTOS": departamentos
            .map((e) => e.toJsonUSer())
            .toList(),
      };
}  