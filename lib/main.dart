import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_web/custom.dart';
import 'app_modules/shared_modules/services/home.services.dart';
import 'infra/routes/pages/pages.routes.dart';
import 'infra/storage/session.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionStorage.init();
  runApp(const SmAdmApp());
}

class SmAdmApp extends StatelessWidget {
  const SmAdmApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      title: 'SM',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("es")],
      locale: const Locale("es"),
      theme: CustomTheme.whiteTheme,

      initialBinding: BindingsBuilder(() {
        Get.put(HomeService());
      }),
      getPages: PagesApp.routes,
      routeInformationParser: GetInformationParser(),
    );
  }
}
