import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/domain/entities.dart";
import "package:app/interfaces/libs/providers.dart";
import "package:app/interfaces/libs/widgets.dart";

import "modules/projects.dart";

export "modules/projects.dart";

part "modules.g.dart";
part "modules/projects_route.dart";

/// Key that store the [router]'s [NavigatorState].
final routerKey = GlobalKey<NavigatorState>();

/// Provide a [GoRouter] that re-evaluates when the providers it listens to are
/// updated.
@riverpod
GoRouter router(Ref ref) {
  final router = GoRouter(
    navigatorKey: routerKey,
    debugLogDiagnostics: true,
    initialLocation: const ProjectsRoute().location,
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
  return null;
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
              onPressed: () => const ProjectsRoute().go(context),
              child: Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
