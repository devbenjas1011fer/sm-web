import 'package:sm_web/infra/models/modulos.dart';

class RolModel {
  String? id;
  String? nombre;
  List<ModuloModel>? modulos;
  RolModel({this.id, this.nombre, this.modulos = const []});

factory RolModel.fromJson(Map<String, dynamic> json) => RolModel(
  id: json["ID"],
  nombre: json["NOMBRE"],
  modulos: json["MODULOS"] != null
      ? (json["MODULOS"] as List)
          .map((e) => ModuloModel.fromJson(e))
          .toList()
      : [],
);

  Map<String, dynamic> toJson() => {
    "ID": id,
    "NOMBRE": nombre,
    "MODULOS": modulos,
  };

  Map<String, dynamic> toJsonSession() => {
    "ID": id,
    "NOMBRE": nombre,
    "MODULOS": modulos?.map((e) => e.toJson()).toList(),
  };
}
