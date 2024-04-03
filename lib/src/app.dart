import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store/generated/locales.g.dart';
import 'infrastructure/route/route_names.dart';
import 'infrastructure/route/route_pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        initialRoute: RouteNames.splashPage,
        getPages: RoutePages.pages,
        debugShowCheckedModeBanner: false,
        translations: AppTranslation(),
        locale: const Locale('en', 'US'),
      );
}
