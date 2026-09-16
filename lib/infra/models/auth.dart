import 'package:sm_web/infra/models/clinica.dart';

class AuthProfile {
  String? id;
  String? token;
  String? nombre;
  String? clinicaId;
  ClinicaModel? clinica;

  AuthProfile({this.id, this.token, this.nombre, this.clinica, this.clinicaId});

  factory AuthProfile.fromJson(Map<String, dynamic> json) => AuthProfile(
    id: json["id"],
    token: json["token"],
    nombre: json["nombre"],
    clinicaId: json["clinicaId"],
    clinica: json["clinicaId"] != null
        ? ClinicaModel.fromJson(json["clinica"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clinicaId": clinicaId,
    "clinica": clinica?.toJson(), 
    "nombre": nombre,
    "token": token,
  };

  Map<String, dynamic> toJsonSession() => {
    "id": id,
    "nombre": nombre,
    "clinicaId": clinicaId,
    "clinica": clinica?.toJson(),
  };
}
