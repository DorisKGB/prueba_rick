import 'package:flutter/material.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/b_home.dart';
import 'package:prueba_rick/presentation/pages/home/v_home.dart';
import 'package:prueba_rick/presentation/utils/bloc_pattern/my_provider.dart';
import 'package:prueba_rick/presentation/utils/my_service_locator.dart';

class PHome extends StatelessWidget {
  const PHome({super.key, required this.serviceLocator, required this.bloc});
  final MyServiceLocator serviceLocator;
  final BHome Function() bloc;

  @override
  Widget build(BuildContext context) {
    return MyBlocProvider(
      blocBuilder: () => bloc(),
      serviceLocator: serviceLocator,
      child: VHome(),
    );
  }
}
