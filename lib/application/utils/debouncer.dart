import 'dart:async';

class Debouncer<T> {
  final Duration duration;
  Timer? _timer;
  Completer<T>? _completer;

  Debouncer({required this.duration});

  Future<T> run(Future<T> Function() action, {Duration? duration}) {
    _timer?.cancel();
    
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<T>();
    }

    _timer = Timer(duration ?? this.duration, () async {
      try {
        final result = await action();
        if (!_completer!.isCompleted) {
          _completer!.complete(result);
        }
      } catch (e) {
        if (!_completer!.isCompleted) {
          _completer!.completeError(e);
        }
      } 
    });

    return _completer!.future;
  }
  
  void dispose() {
    _timer?.cancel();
  }
}
