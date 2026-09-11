class DepartamentoModel {
  String? id;
  String? nombre;

  DepartamentoModel({
    this.id,
    this.nombre,
  });

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) => DepartamentoModel(
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