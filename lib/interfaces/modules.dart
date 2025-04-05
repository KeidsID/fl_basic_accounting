import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/interfaces/libs/providers.dart";

import "modules/products.dart";

export "modules/products.dart";

part "modules.g.dart";
part "modules/auth_route.dart";
part "modules/products_route.dart";

/// Key that store the [router]'s [NavigatorState].
final routerKey = GlobalKey<NavigatorState>();

/// Provide a [GoRouter] that re-evaluates when the providers it listens to are 
/// updated.
@riverpod
GoRouter router(Ref ref) {
  final router = GoRouter(
    navigatorKey: routerKey,
    debugLogDiagnostics: true,
    initialLocation: const AuthRoute().location,
    redirect: (context, state) => _redirectBuilder(context, state, ref),
    errorBuilder: (_, router) => NotFoundScreen(router),
    routes: $appRoutes,
  );
  ref.onDispose(router.dispose);

  return router;
}

/// The [router]'s redirect builder.
///
/// You may watch provider directly using [ref] here.
/// But remember to not listen the same providers on both redirect builder and
/// the [router] provider.
FutureOr<String?> _redirectBuilder(
  BuildContext context,
  GoRouterState state,
  Ref ref,
) async {
  final authAsync = ref.watch(authProvider);

  if (authAsync.isLoading) return null;

  final isSignedIn = authAsync.value != null;
  final currentRoutePath = state.uri.path;

  final authRoutePath = const AuthRoute().location;
  final isAuthRoute = currentRoutePath.startsWith(authRoutePath);

  if (isSignedIn) {
    return isAuthRoute ? const ProductsRoute().location : null;
  } else {
    return isAuthRoute ? null : authRoutePath;
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen(this.router, {super.key});

  final GoRouterState router;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Page Not Found", style: textTheme.titleMedium),
            Text(
              'No resource found at "${router.uri.path}"',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => const ProductsRoute().go(context),
              child: Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
