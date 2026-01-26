import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/p_home.dart';
import 'package:prueba_rick/presentation/utils/my_service_locator.dart';
import 'package:prueba_rick/presentation/router/pages.dart';

class MyRouter {
  MyRouter._internal();
  static final MyRouter instance = MyRouter._internal();

  late final GoRouter router = GoRouter(
    initialLocation: Pages.home.getPath(),
    routes: [
      GoRoute(
        path: Pages.home.getPath(),
        name: Pages.home.name,
        builder: (BuildContext context, GoRouterState state) {
          return PHome(
            bloc: () => MyServiceLocator.instance.bHome(),
            serviceLocator: MyServiceLocator.instance,
          );
        },
      ),
    ],
  );
}
