library delayed_task;

import 'dart:async';
import 'package:task/task.dart';

class DelayedTask<R> extends Task<R> {
  final R Function() _computation;
  final Duration _delay;

  DelayedTask(this._computation, [this._delay = Duration.ZERO]);

  @override
  Operation run(void Function(R) onResult, [void Function(Object) onError]) {
    var timer = new Timer(_delay, () => onResult(_computation()));
    return new _DelayedOperation(timer);
  }
}

class _DelayedOperation extends Operation {
  Timer _timer;

  _DelayedOperation(this._timer);

  @override
  void cancel() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
}
