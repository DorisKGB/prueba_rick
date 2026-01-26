import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prueba_rick/presentation/app.dart';
import 'package:prueba_rick/presentation/bloc_application/b_application.dart';
import 'package:prueba_rick/presentation/bloc_application/blocs/b_user.dart';
import 'package:prueba_rick/presentation/utils/bloc_pattern/my_provider.dart';
import 'package:prueba_rick/presentation/router/my_router.dart';
import 'package:prueba_rick/presentation/utils/my_service_locator.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      MyServiceLocator.instance.setNavigator(MyRouter.instance.router);
      WidgetsFlutterBinding.ensureInitialized();
      runApp(
        MyBlocProvider<BApplication>(
          blocBuilder: () => MyServiceLocator.instance.bApplication,
          serviceLocator: MyServiceLocator.instance,
          child: MyBlocProvider<BUser>(
            blocBuilder: () => MyServiceLocator.instance.bUser,
            serviceLocator: MyServiceLocator.instance,
            child: MyApp(),
          ),
        ),
      );
    },
    (Object error, StackTrace stack) {
      //FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
