import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ivr_frontend/core/theme/theme.dart';
import 'package:ivr_frontend/presentation/getx/controllers/home_controller.dart';
import 'package:ivr_frontend/presentation/screens/call_history/call_history.dart';
import 'package:ivr_frontend/presentation/screens/main/home.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'services/routing_service/router.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(HomeController());
  final router = MyRouter();
  GoRouter appRouter = await router.appRouter();
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final GoRouter appRouter;
  const MyApp({Key? key,  required this.appRouter}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        title: 'IVRS',
        debugShowCheckedModeBanner: false,
        theme: ApplicationTheme.getAppThemeData(),
        routeInformationProvider: appRouter.routeInformationProvider,
        routeInformationParser: appRouter.routeInformationParser,
        routerDelegate: appRouter.routerDelegate,
      );
    }
    );
  }
}
