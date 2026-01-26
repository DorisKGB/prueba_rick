import 'package:bpstate/bpstate.dart';

class BUser extends BlocBase {
  static BUser? _instance;

  BUser._internal();

  static BUser instance() {
    _instance ??= BUser._internal();
    return _instance!;
  }

  @override
  void dispose() {}
}
