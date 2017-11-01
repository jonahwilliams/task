part of task;

class _FlatMappedTask<S, R> extends Task<S> {
  final Task<R> sourceTask;
  final Task<S> Function(R) transform;

  _FlatMappedTask(this.transform, this.sourceTask);

  @override
  Operation run(Function onResult, [void Function(Object) onError]) {
    var operation = new _FlatMappedOperation();
    var outer = sourceTask.run((R data) {
      var innertask = transform(data);
      operation.inner = innertask.run((S data) {}, onError);
    }, onError);
    return operation..outer = outer;
  }
}

class _FlatMappedOperation extends Operation {
  Operation outer;
  Operation inner;

  _FlatMappedOperation();

  @override
  void cancel() {
    if (outer != null) {
      outer.cancel();
      outer = null;
    }
    if (inner != null) {
      inner.cancel();
      inner = null;
    }
  }
}
