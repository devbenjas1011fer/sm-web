import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../routes/app.routes.dart';
import '../storage/session.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!SessionStorage.hasSession) {
      Get.rootDelegate.toNamed(AppRoutes.login);
    }

    return null;
  }
}
