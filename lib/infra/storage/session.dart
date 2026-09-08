import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';

class SessionStorage {
  SessionStorage._();

  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();

  static SharedPreferences? _prefs;

  static const String _sessionKey = 'session';
  static const String _tokenKey = 'token';

  static AuthProfile? _session;
  static String? _token;

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
    }

    await _load();

    _initialized = true;
  }

  static Future<void> reload() async {
    await _load();
  }

  static Future<void> _load() async {
    String? sessionValue;
    String? tokenValue;

    if (kIsWeb) {
      sessionValue = _prefs?.getString(_sessionKey);
      tokenValue = _prefs?.getString(_tokenKey);
    } else {
      final values = await Future.wait([
        _secureStorage.read(key: _sessionKey),
        _secureStorage.read(key: _tokenKey),
      ]);

      sessionValue = values[0];
      tokenValue = values[1];
    }

    _token = tokenValue;

    if (sessionValue != null && sessionValue.isNotEmpty) {
      try {
        _session = AuthProfile.fromJson(jsonDecode(sessionValue));
      } catch (_) {
        _session = null;
      }
    } else {
      _session = null;
    }

    _token ??= _session?.token;
  }

  static AuthProfile? get session => _session;

  static String? get token => _token;

  static bool get hasSession =>
      _session != null &&
      _token != null &&
      _token!.isNotEmpty;

  static Future<void> save(AuthProfile session) async {
    _session = session;

    if (session.token != null && session.token!.isNotEmpty) {
      _token = session.token;
    }

    final json = jsonEncode(session.toJson());

    if (kIsWeb) {
      await _prefs?.setString(_sessionKey, json);

      if (_token != null) {
        await _prefs?.setString(_tokenKey, _token!);
      }
    } else {
      await Future.wait([
        _secureStorage.write(
          key: _sessionKey,
          value: json,
        ),
        if (_token != null)
          _secureStorage.write(
            key: _tokenKey,
            value: _token!,
          ),
      ]);
    }
  }

  static Future<void> setToken(String token) async {
    _token = token;

    if (kIsWeb) {
      await _prefs?.setString(_tokenKey, token);
    } else {
      await _secureStorage.write(
        key: _tokenKey,
        value: token,
      );
    }
  }

  static Future<void> delete() async {
    _session = null;
    _token = null;

    if (kIsWeb) {
      await _prefs?.remove(_sessionKey);
      await _prefs?.remove(_tokenKey);
    } else {
      await Future.wait([
        _secureStorage.delete(key: _sessionKey),
        _secureStorage.delete(key: _tokenKey),
      ]);
    }
  }

  static Future<void> erase() async {
    _session = null;
    _token = null;
    _initialized = false;

    if (kIsWeb) {
      await _prefs?.clear();
    } else {
      await _secureStorage.deleteAll();
    }
  }
}