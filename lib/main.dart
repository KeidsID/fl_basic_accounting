import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "service_locator.dart";
import "interfaces/modules.dart";

Future<void> main() async {
  await ServiceLocator.init();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}
