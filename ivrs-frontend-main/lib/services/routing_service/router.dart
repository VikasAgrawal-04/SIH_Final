import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ivr_frontend/presentation/screens/call_history/call_history.dart';
import 'package:ivr_frontend/presentation/screens/call_history/location.dart';
import 'package:ivr_frontend/presentation/screens/main/home.dart';
import 'package:ivr_frontend/services/routing_service/routes.dart';
import 'routes_name.dart';

class MyRouter {
  Future<GoRouter> appRouter()async {

    final router = GoRouter(

        urlPathStrategy: UrlPathStrategy.path,
        debugLogDiagnostics: true,

        routes: [
          GoRoute(
            name: initialPage,
            path: initialRoute,
            pageBuilder: (context, state) {
              return CupertinoPage(
                key: state.pageKey,
                child: const CallHistory(),
              );
            },
          ),
          GoRoute(
            name: locationPage,
            path: locationRoute,
            pageBuilder: (context, state) {
              return CupertinoPage(
                key: state.pageKey,
                child: Location(lat: double.tryParse(state.queryParams['lat']!), long: double.tryParse(state.queryParams['long']!))
              );
            },
          ),
        ]);
    return router;
  }
}
