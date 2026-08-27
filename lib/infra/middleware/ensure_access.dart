import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnsureAccess extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {

    // final session = SessionStorage...
    //
    // if (!session.isAuthenticated) {
    //   return const RouteSettings(name: '/login');
    // }

    return null;
  }
}