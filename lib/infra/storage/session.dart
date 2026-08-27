import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth.dart';

class SessionStorage {
  SessionStorage._();

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  static const String _sessionKey = 'session';
  static const String _tokenKey = 'token';

  static AuthProfile? _session;
  static String? _token;

  static bool _initialized = false;

  /// Inicializa la sesión desde Secure Storage.
  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    await _load();

    _initialized = true;
  }

  /// Carga nuevamente los datos desde Secure Storage.
  static Future<void> reload() async {
    await _load();

    _initialized = true;
  }

  static Future<void> _load() async {
    final values = await Future.wait([
      _storage.read(key: _sessionKey),
      _storage.read(key: _tokenKey),
    ]);

    final sessionValue = values[0];
    final tokenValue = values[1];

    _token = tokenValue;

    if (sessionValue != null &&
        sessionValue.isNotEmpty) {
      try {
        _session = AuthProfile.fromJson(
          jsonDecode(sessionValue),
        );
      } catch (_) {
        _session = null;
      }
    } else {
      _session = null;
    }

    // Si el token independiente no existe,
    // intenta obtenerlo desde la sesión.
    _token ??= _session?.token;
  }

  static AuthProfile? get session => _session;

  static String? get token => _token;

  static bool get hasSession =>
      _session != null &&
      _token != null &&
      _token!.isNotEmpty;

  static Future<void> save(
    AuthProfile session,
  ) async {
    _session = session;

    if (session.token != null &&
        session.token!.isNotEmpty) {
      _token = session.token;
    }

    await Future.wait([
      _storage.write(
        key: _sessionKey,
        value: jsonEncode(
          session.toJson(),
        ),
      ),

      if (_token != null)
        _storage.write(
          key: _tokenKey,
          value: _token!,
        ),
    ]);

    _initialized = true;
  }

  static Future<void> setToken(
    String token,
  ) async {
    if (token.isEmpty) {
      return;
    }

    _token = token;

    await _storage.write(
      key: _tokenKey,
      value: token,
    );

    _initialized = true;
  }

  static Future<void> delete() async {
    _session = null;
    _token = null;
    _initialized = true;

    await Future.wait([
      _storage.delete(
        key: _sessionKey,
      ),
      _storage.delete(
        key: _tokenKey,
      ),
    ]);
  }

  static Future<void> erase() async {
    _session = null;
    _token = null;
    _initialized = true;

    await _storage.deleteAll();
  }
}