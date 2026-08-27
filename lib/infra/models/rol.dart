class RolModel {
  String? id;
  String? nombre;
  String? numero;
  String? curp;
  String? direccion;
  String? email;

  RolModel({
    this.id,
    this.nombre,
  });

  factory RolModel.fromJson(Map<String, dynamic> json) => RolModel(
        id: json["ID"],
        nombre: json["NOMBRE"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "NOMBRE": nombre,
      };

  Map<String, dynamic> toJsonSession() => {
        "ID": id,
        "NOMBRE": nombre,
      };
}