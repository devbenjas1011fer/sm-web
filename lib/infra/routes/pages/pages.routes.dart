import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:sm_web/app_modules/modules/roles/bindings/rol_details.dart';
import 'package:sm_web/app_modules/modules/roles/bindings/roles.dart';
import 'package:sm_web/app_modules/modules/roles/views/rol_details.view.dart';
import 'package:sm_web/app_modules/modules/roles/views/roles.view.dart';
import 'package:sm_web/app_modules/modules/users/bindings/users.dart';
import 'package:sm_web/app_modules/modules/users/bindings/users_details.dart';
import 'package:sm_web/app_modules/modules/users/views/user.view.dart';
import 'package:sm_web/app_modules/modules/users/views/user_details.view.dart';
import 'package:sm_web/app_modules/shared_modules/bindings/login.binding.dart';
import 'package:sm_web/app_modules/shared_modules/views/home.view.dart';
import 'package:sm_web/app_modules/shared_modules/views/login.view.dart';
import 'package:sm_web/infra/middleware/ensure.dart';
import 'package:sm_web/infra/middleware/ensure_access.dart';
import 'package:sm_web/infra/middleware/not_auth.dart';
import 'package:sm_web/infra/routes/app.routes.dart';
import 'package:sm_web/infra/routes/pages/root_view.dart';
import 'package:sm_web/infra/routes/paths.dart';

class PagesApp {
  PagesApp._();

  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: "/",
      page: () => const RootView(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureAuthMiddleware()],
      children: [
        GetPage(
          name: Paths.adm,
          page: () => const HomeView(),
          preventDuplicates: true,
          middlewares: [EnsureAccess()],
          children: [
            GetPage(
              name: Paths.users,
              page: () => const AdmUsuariosView(),
              binding: AdmUsuariosBinding(),
              preventDuplicates: true,
              transition: Transition.fadeIn,
              middlewares: [EnsureAuthMiddleware()],
              children: [
                GetPage(
                  name: Paths.id,
                  page: () => const AdmUsuarioDetailView(),
                  binding: AdmUsuarioDetailBinding(),
                  preventDuplicates: true,
                  transition: Transition.rightToLeft,
                  middlewares: [EnsureAuthMiddleware()],
                ),
              ],
            ),

            /* GetPage(
              name: Paths.clinicas,
              page: () => const ClinicasView(),
              binding: ClinicasBindings(),
              preventDuplicates: true,
              transition: Transition.fadeIn,
              middlewares: [EnsureAuthMiddleware()],
              children: [
                GetPage(
                  name: Paths.id,
                  page: () => const ClinicaDetailsView(),
                  binding: ClinicaDetailsBinding(),
                  preventDuplicates: true,
                  transition: Transition.rightToLeft,
                  middlewares: [EnsureAuthMiddleware()],
                ),
              ],
            ), */
            GetPage(
              name: Paths.roles,
              page: () => const RolesView(),
              binding: RolesBindings(),
              preventDuplicates: true,
              transition: Transition.fadeIn,
              middlewares: [EnsureAuthMiddleware()],
              children: [
                GetPage(
                  name: Paths.id,
                  page: () => const RolDetailsView(),
                  binding: RolDetailsBinding(),
                  preventDuplicates: true,
                  transition: Transition.rightToLeft,
                  middlewares: [EnsureAuthMiddleware()],
                ),
              ],
            ),

            // GetPage(
            //   name: Paths.lead,
            //   page: () => const LeadView(),
            //   preventDuplicates: true,
            //   transition: Transition.fadeIn,
            //   middlewares: [EnsureAuthMiddleware()],
            // ),

            // GetPage(
            //   name: Paths.forms,
            //   page: () => const FormsView(),
            //   preventDuplicates: true,
            //   transition: Transition.fadeIn,
            //   middlewares: [EnsureAuthMiddleware()],
            // ),
          ],
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
      middlewares: [EnsureNotAuthMiddleware()],
    ),
  ];
}
