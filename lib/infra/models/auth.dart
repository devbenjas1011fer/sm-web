class AuthProfile {
  String? id;
  String? token;
  String? nombre;
  String? clinicaId;

  AuthProfile({this.id, this.token, this.nombre, this.clinicaId});

  factory AuthProfile.fromJson(Map<String, dynamic> json) => AuthProfile(
    id: json["id"],
    token: json["token"],
    nombre: json["nombre"], 
    clinicaId: json["clinicaId"], 
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clinicaId": clinicaId,
    "nombre": nombre,
    "token": token,
  };

  Map<String, dynamic> toJsonSession() => {
    "id": id,
    "nombre": nombre,
    "clinicaId": clinicaId,
  };
}
