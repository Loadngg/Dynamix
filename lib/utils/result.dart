sealed class Result<T> {
  const Result();

  static Ok<T> ok<T>(T value) => Ok<T>(value);
  static Error<T> error<T>(Exception error) => Error<T>(error);
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Error<T> extends Result<T> {
  final Exception error;
  const Error(this.error);
}
