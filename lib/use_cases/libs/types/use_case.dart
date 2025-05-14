import "dart:async";

/// Base class of use cases.
///
/// * [UseCase] ~ To define use case that return `T` or `Future<T>`
/// * [StreamUseCase] ~ To define use case that return `Stream<T>`
abstract interface class _UseCaseBase<T, P> {
  T execute(P params);
}

/// Interface for use cases.
///
/// ```dart
/// class HelloWorldUseCase implements UseCase<String, void> {
///   const HelloWorldUseCase();
///   
///   // Can also return `Future<String>`
///   @override
///   String execute([void params]) {
///     return "Hello World!";
///   }
/// }
///
/// void main() {
///   const HelloWorldUseCase().execute(); // Hello World!
/// }
/// ```
abstract interface class UseCase<T, P>
    implements _UseCaseBase<FutureOr<T>, P> {}

/// Use case interface that return `Stream<T>` instead of `FutureOr<T>`.
///
/// ```dart
/// class HelloWorldUseCase implements UseCase<String, void> {
///   const HelloWorldUseCase();
///
///   @override
///   Stream<String> execute([void params]) async* {
///     yield "Hello World!";
///   }
/// }
///
/// void main() async {
///   await const HelloWorldUseCase().execute().last; // Hello World!
/// }
/// ```
abstract interface class StreamUseCase<T, P>
    implements _UseCaseBase<Stream<T>, P> {}
