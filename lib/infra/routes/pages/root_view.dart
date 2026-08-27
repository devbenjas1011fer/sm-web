import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:sm_web/infra/routes/app.routes.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetRouterOutlet.builder(
      builder: (context, delegate, currentRoute) {
        return GetRouterOutlet(
          delegate: delegate,
          initialRoute: AppRoutes.adm,
          anchorRoute: AppRoutes.root,
          filterPages: ((afterAnchor) => afterAnchor.take(1)),
        );
      },
    );
  }
}
