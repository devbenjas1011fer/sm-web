class AuthProfile {
  String? id;
  String? token;
  String? nombre;

  AuthProfile({this.id, this.token, this.nombre});

  factory AuthProfile.fromJson(Map<String, dynamic> json) => AuthProfile(
    id: json["id"],
    token: json["token"],
    nombre: json["nombre"], 
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "token": token,
  };

  Map<String, dynamic> toJsonSession() => {
    "id": id,
    "nombre": nombre,
  };
}
