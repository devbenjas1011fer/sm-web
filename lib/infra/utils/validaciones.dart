/// Capa de validaciones reutilizable de `sm_web`.
///
/// Archivo pensado para importarse desde cualquier vista con formulario:
///
/// ```dart
/// import 'package:sm_web/infra/utils/validaciones.dart';
///
/// TextFormField(
///   validator: (v) => Validaciones.curp(v),
/// ),
/// ```
///

library;

typedef Validador = String? Function(String? valor);

class Validaciones {
  Validaciones._();

  /// Claves de entidad federativa válidas dentro de la CURP: los 32 estados
  /// más `NE` para personas nacidas en el extranjero.
  static const List<String> _entidadesCurp = [
    'AS', 'BC', 'BS', 'CC', 'CH', 'CL', 'CM', 'CS', 'DF', 'DG', 'GR', 'GT',
    'HG', 'JC', 'MC', 'MN', 'MS', 'NE', 'NL', 'NT', 'OC', 'PL', 'QR', 'QT',
    'SL', 'SP', 'SR', 'TC', 'TL', 'TS', 'VZ', 'YN', 'ZS',
  ];

  /// Estructura oficial (SAT/RENAPO) de la CURP, 18 posiciones:
  ///
  /// 1     letra inicial del apellido paterno
  /// 2     primera vocal interna del apellido paterno
  /// 3     letra inicial del apellido materno
  /// 4     letra inicial del nombre
  /// 5-10  fecha de nacimiento AAMMDD
  /// 11    sexo (H/M)
  /// 12-13 clave de entidad federativa (lista cerrada de 32 + NE)
  /// 14-16 primera consonante interna de paterno, materno y nombre
  /// 17    homoclave (dígito o letra según el año de asignación)
  /// 18    dígito verificador
  ///
  /// Deliberadamente NO se valida el dígito verificador (posición 18) con
  /// un checksum: existen CURP legítimas antiguas cuyo dígito no cuadra con
  /// el algoritmo de RENAPO, y validarlo estrictamente rechazaría personas
  /// reales. Se valida en cambio la estructura completa, que es lo que
  /// distingue a una CURP real de una cadena aleatoria de 18 caracteres.
  static final RegExp _curpRegExp = RegExp(
    r'^[A-Z][AEIOUX][A-Z]{2}'
    r'\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])'
    r'[HM]'
    '(?:${_entidadesCurp.join('|')})'
    r'[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]\d$',
  );

  static final RegExp _correoRegExp = RegExp(
    r"^[\w.!#$%&'*+/=?^`{|}~-]+"
    r'@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?'
    r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$',
  );

  static final RegExp _nombreRegExp = RegExp(
    r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?:[ '\-][A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)*$",
  );

  static final RegExp _rfcRegExp = RegExp(r'^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$');

  static String normalizar(String? valor) =>
      (valor ?? '').trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');

  static String telefonoNormalizado(String? valor) {
    var d = (valor ?? '').replaceAll(RegExp(r'[^\d]'), '');
    if (d.length == 12 && d.startsWith('52')) {
      d = d.substring(2);
    } else if (d.length == 13 && d.startsWith('521')) {
      d = d.substring(3);
    }
    return d.length == 10 ? d : '';
  }

  
  static Validador unir(List<Validador> reglas) {
    return (String? valor) {
      for (final regla in reglas) {
        final error = regla(valor);
        if (error != null) return error;
      }
      return null;
    };
  }

  
  static String? requerido(String? valor, {String campo = 'Este campo'}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$campo es obligatorio';
    }
    return null;
  }

  static String? longitud(
    String? valor, {
    int? minimo,
    int? maximo,
    String campo = 'Este campo',
    bool obligatorio = true,
  }) {
    final v = (valor ?? '').trim();
    if (v.isEmpty) return obligatorio ? '$campo es obligatorio' : null;
    if (minimo != null && v.length < minimo) {
      return '$campo debe tener al menos $minimo caracteres';
    }
    if (maximo != null && v.length > maximo) {
      return '$campo no puede exceder $maximo caracteres';
    }
    return null;
  }

  static String? Function(T?) valorRequerido<T>({String campo = 'Este campo'}) {
    return (T? valor) {
      if (valor == null) return '$campo es obligatorio';
      if (valor is String && valor.trim().isEmpty) {
        return '$campo es obligatorio';
      }
      return null;
    };
  }

  static String? curp(String? valor, {bool obligatorio = true}) {
    final v = normalizar(valor);

    if (v.isEmpty) return obligatorio ? 'Ingrese la CURP' : null;
    if (v.length != 18) return 'La CURP debe contener 18 caracteres';
    if (!_curpRegExp.hasMatch(v)) {
      return 'La CURP no tiene un formato válido';
    }
    if (!_fechaCurpValida(v)) {
      return 'La fecha de nacimiento dentro de la CURP no es válida';
    }
    return null;
  }

  static bool _fechaCurpValida(String curp18) {
    final mes = int.tryParse(curp18.substring(6, 8));
    final dia = int.tryParse(curp18.substring(8, 10));
    if (mes == null || dia == null) return false;
    const diasPorMes = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return dia <= diasPorMes[mes - 1];
  }

  static String? correo(String? valor, {bool obligatorio = true}) {
    final v = (valor ?? '').trim();
    if (v.isEmpty) return obligatorio ? 'Ingrese el correo' : null;
    if (v.length > 254) return 'El correo es demasiado largo';
    if (!_correoRegExp.hasMatch(v)) return 'Correo inválido';
    return null;
  }

  static String? telefono(String? valor, {bool obligatorio = true}) {
    final crudo = (valor ?? '').trim();
    if (crudo.isEmpty) return obligatorio ? 'Ingrese el número' : null;

    final digitos = crudo.replaceAll(RegExp(r'[^\d]'), '');
    final d = telefonoNormalizado(crudo);

    if (d.isEmpty) {
      return digitos.length == 10
          ? 'Número de teléfono inválido'
          : 'El número debe contener 10 dígitos';
    }
    if (RegExp(r'^(\d)\1{9}$').hasMatch(d)) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }

  static String? nombre(
    String? valor, {
    bool obligatorio = true,
    String campo = 'El nombre',
    int minimo = 3,
    int maximo = 80,
  }) {
    final v = (valor ?? '').trim();
    if (v.isEmpty) return obligatorio ? '$campo es obligatorio' : null;
    if (v.length < minimo) {
      return '$campo debe tener al menos $minimo caracteres';
    }
    if (v.length > maximo) {
      return '$campo no puede exceder $maximo caracteres';
    }
    if (!_nombreRegExp.hasMatch(v)) {
      return '$campo sólo puede contener letras y espacios';
    }
    return null;
  }

  static String? direccion(
    String? valor, {
    bool obligatorio = true,
    int minimo = 5,
    int maximo = 200,
  }) {
    final v = (valor ?? '').trim();
    if (v.isEmpty) return obligatorio ? 'Ingrese la dirección' : null;
    if (v.length < minimo) {
      return 'La dirección debe tener al menos $minimo caracteres';
    }
    if (v.length > maximo) {
      return 'La dirección no puede exceder $maximo caracteres';
    }
    return null;
  }

  static String? password(
    String? valor, {
    bool obligatorio = true,
    int minimo = 6,
  }) {
    final v = valor ?? '';
    if (v.isEmpty) return obligatorio ? 'Ingrese la contraseña' : null;
    if (v.length < minimo) {
      return 'La contraseña debe tener al menos $minimo caracteres';
    }
    return null;
  }

  static String? rfc(String? valor, {bool obligatorio = true}) {
    final v = normalizar(valor);
    if (v.isEmpty) return obligatorio ? 'Ingrese el RFC' : null;
    if (v.length != 12 && v.length != 13) {
      return 'El RFC debe tener 12 o 13 caracteres';
    }
    if (!_rfcRegExp.hasMatch(v)) return 'El RFC no tiene un formato válido';
    return null;
  }
}
