part of "../modules.dart";

@TypedGoRoute<AuthRoute>(path: "/auth")
class AuthRoute extends GoRouteData {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthScreen();
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, ref, _) {
            final isLoading = ref.watch(authProvider).isLoading;

            return ElevatedButton(
              onPressed: switch (isLoading) {
                true => null,
                false => () {
                  ref.read(authProvider.notifier).signIn();
                },
              },
              child: Text("Sign In"),
            );
          },
        ),
      ),
    );
  }
}
