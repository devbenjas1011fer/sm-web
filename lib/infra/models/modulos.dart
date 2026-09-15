class ModuloModel {
  String? id;
  String? nombre;
  String? permiso;

  ModuloModel({
    this.id,
    this.nombre,
    this.permiso,
  });

  factory ModuloModel.fromJson(Map<String, dynamic> json) => ModuloModel(
        id: json["ID"],
        nombre: json["NOMBRE"],
        permiso: json["PERMISO"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "NOMBRE": nombre,
        "PERMISO": permiso,
      };

  Map<String, dynamic> toJsonSession() => {
        "ID": id,
        "PERMISO": permiso,
        "NOMBRE": nombre,
      };
}