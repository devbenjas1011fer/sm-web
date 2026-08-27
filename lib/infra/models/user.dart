class UsuarioModel {
  String? id;
  String? nombre;
  String? numero;
  String? curp;
  String? direccion;
  String? email;

  UsuarioModel({
    this.id,
    this.nombre,
    this.numero,
    this.curp,
    this.direccion,
    this.email,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json["ID"],
        nombre: json["NOMBRES"],
        numero: json["NUMERO"],
        curp: json["CURP"],
        direccion: json["DIRECCION"],
        email: json["CORREO"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "NOMBRES": nombre,
        "NUMERO": numero,
        "CURP": curp,
        "DIRECCION": direccion,
        "CORREO": email,
      };

  Map<String, dynamic> toJsonSession() => {
        "ID": id,
        "NOMBRES": nombre,
      };
}