import "package:flutter/material.dart";

class AppLoader extends StatelessWidget {
  /// Whether to wrap the loader with [Center] or not.
  final bool useCenter;

  const AppLoader({super.key, this.useCenter = true});

  @override
  Widget build(BuildContext context) {
    const loader = CircularProgressIndicator.adaptive();

    return useCenter ? const Center(child: loader) : loader;
  }
}
