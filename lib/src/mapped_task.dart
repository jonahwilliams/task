part of task;

class _MappedTask<S, R> extends Task<S> {
  final S Function(R) transform;
  final Task<R> sourceTask;

  _MappedTask(this.transform, this.sourceTask);

  @override
  Operation run(void Function(S) onResult, [Function onError]) {
    return sourceTask.run((R x) => onResult(transform(x)), onError);
  }
}
