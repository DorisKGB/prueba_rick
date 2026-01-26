import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:prueba_rick/presentation/router/my_router.dart';
import 'package:prueba_rick/presentation/utils/theme/theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //late BUser bUser;

  @override
  void initState() {
    //bUser = BlocProvider.of<BUser>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App',
      onGenerateTitle: (BuildContext context) {
        return 'App';
      },
      theme: AppStyle.lightTheme,
      routerDelegate: MyRouter.instance.router.routerDelegate,
      routeInformationParser: MyRouter.instance.router.routeInformationParser,
      routeInformationProvider:
          MyRouter.instance.router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      builder: (context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1)),
          child: child ?? Container(),
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Inglés (u otros que necesites)
      ],
    );
  }
}
