/// Interface for use cases.
///
/// ```dart
/// class HelloWorldUseCase implements UseCase<String, void> {
///   const HelloWorldUseCase();
///
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
abstract interface class UseCase<T, P> {
  T execute(P params);
}
