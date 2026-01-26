import 'package:flutter/material.dart';

class VError extends StatelessWidget {
  const VError({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(error)),
    );
  }
}