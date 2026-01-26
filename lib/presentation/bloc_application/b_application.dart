import 'package:bpstate/bpstate.dart';

class BApplication extends BlocBase {
  static BApplication? _instance;

  static BApplication instance() {
    _instance ??= BApplication._internal();
    return _instance!;
  }

  BApplication._internal();

  @override
  void dispose() {}
}
