part of task;

abstract class Task<R> {
  /// Evaluates the current task, calling [onResult] when it completes or
  /// [onError] if an error is encountered.
  ///
  /// Note that some tasks may also throw errors normally: the Task API does
  /// not guarantee that all or any errors are caught.
  Operation run(void Function(R) onResult, [void Function(Object) onError]);

  /// Transforms the result which would be returned from the current task by
  /// [transform].
  ///
  /// Does not evaluate the task.
  Task<S> map<S>(S Function(R) transform) => new _MappedTask(transform, this);

  /// Creates a new operation which will cache the result of [run].
  ///
  /// Calling run after the task has already completed will return the same
  /// object returned from the first successful run.  This does not promise
  /// that the object cannot be mutated by incorrect usage.
  Task<R> cache() => new _CachedTask(this);

  /// Transforms the result which would be returned from the current task by
  /// [transform] into a new task.
  ///
  /// Does not evaluate the task.
  Task<S> flatMap<S>(Task<S> Function(R) transform) =>
      new _FlatMappedTask(transform, this);
}

/// A token representing an eventual task completion.
///
/// Used to cancel the task.
abstract class Operation {
  /// Cancells any pending work which has not completed.
  void cancel();
}
