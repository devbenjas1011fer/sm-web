import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sm_web/infra/routes/app.routes.dart';

import '../storage/session.dart';

class EnsureAuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (!SessionStorage.hasSession) {
      return const RouteSettings(name: AppRoutes.login);
    }

    return null;
  }
}
