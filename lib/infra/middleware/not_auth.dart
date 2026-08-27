import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../routes/app.routes.dart';
import '../storage/session.dart';

class EnsureNotAuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (SessionStorage.hasSession) {
      return const RouteSettings(
        name: AppRoutes.root,
      );
    }

    return null;
  }
}