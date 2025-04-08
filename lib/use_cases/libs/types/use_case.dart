import "dart:async";

/// Interface for use cases.
///
/// Unlike Typescript which can define the parameters abstraction of functions
/// with arrays, Dart can only utilize generic type as parameters.
///
/// ```ts
/// // This is what we want to achieve in dart
///
/// interface UseCase<T> {
///   execute(...args: any[]): Promise<T> | T;
/// }
///
/// class MyUseCase implements UseCase<string> {
///   execute(): string {
///     return "Hello World!";
///   }
/// }
///
/// new MyUseCase().execute(); // Hello World!
/// ```
///
/// So for this [UseCase] interface, you need to define two generic types.
///
/// ```dart
/// class HelloWorldUseCase implements UseCase<String, void> {
///   const HelloWorldUseCase();
///
///   @override
///   FutureOr<String> execute([void params]) {
///     return "Hello World!";
///   }
/// }
///
/// void main() {
///   const HelloWorldUseCase().execute(); // Hello World!
/// }
/// ```
abstract interface class UseCase<ReturnT, Params> {
  FutureOr<ReturnT> execute(Params params);
}
