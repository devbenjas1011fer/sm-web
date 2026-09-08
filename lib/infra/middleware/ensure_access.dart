import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../storage/session.dart';

class EnsureAccess extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {

    final session = SessionStorage.session;
    
    if (session?.id==null) {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}