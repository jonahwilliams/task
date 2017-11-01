part of task;

const _undefined = const Object();

class _CachedTask<R> extends Task<R> {
  static final _alreadyComplete = new _CachedOperation(null);

  final Task<R> parent;
  Object _result = _undefined;

  _CachedTask(this.parent);

  @override
  Task<R> cache() => this;

  @override
  Operation run(void Function(R) onResult, [Function(Object) onError]) {
    if (_result != _undefined) {
      R result = _result;
      onResult(result);
      return _alreadyComplete;
    }
    var operation = parent.run(onResult, onError);
    return new _CachedOperation(operation);
  }
}

class _CachedOperation extends Operation {
  Operation _nested;

  _CachedOperation(this._nested);

  @override
  void cancel() {
    if (_nested != null) {
      _nested.cancel();
      _nested = null;
    }
  }
}
