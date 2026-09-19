import 'package:sm_web/infra/models/clinica.dart';
import 'package:sm_web/infra/models/departamento.dart';

class AuthProfile {
  String? id;
  String? rol;
  String? token;
  String? nombre;
  String? clinicaId;
  String? departamentoId;
  ClinicaModel? clinica;
  List<DepartamentoModel>? departamentos;

  AuthProfile({
    this.id,
    this.token,
    this.nombre,
    this.rol,
    this.clinica,
    this.clinicaId,
    this.departamentoId,
    this.departamentos,
  });

  factory AuthProfile.fromJson(Map<String, dynamic> json) => AuthProfile(
        id: json["id"],
        token: json["token"],
        rol: json["rol"],
        nombre: json["nombre"],
        clinicaId: json["clinicaId"],
        departamentoId: json["departamentoId"],
        clinica: json["clinica"] != null
            ? ClinicaModel.fromJson(json["clinica"])
            : null,
        departamentos: json["departamentos"] != null
            ? (json["departamentos"] as List)
                .map((e) => DepartamentoModel.fromJson(e))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clinicaId": clinicaId,
        "departamentoId": departamentoId,
        "clinica": clinica?.toJson(),
        "nombre": nombre,
        "rol": rol,
        "token": token,
        "departamentos":
            departamentos?.map((e) => e.toJson()).toList(),
      };

  Map<String, dynamic> toJsonSession() => {
        "id": id,
        "rol": rol,
        "nombre": nombre,
        "clinicaId": clinicaId,
        "departamentoId": departamentoId,
        "clinica": clinica?.toJson(),
        "departamentos":
            departamentos?.map((e) => e.toJson()).toList(),
      };
}