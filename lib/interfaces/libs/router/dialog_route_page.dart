import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// Used on [GoRouteData.buildPage] to build dialog that linked to router.
class DialogRoutePage<T> extends Page<T> {
  /// {@macro flutter.widgets.ModalRoute.barrierColor}
  final Color? barrierColor;

  /// {@macro flutter.widgets.ModalRoute.barrierDismissible}
  final bool barrierDismissible;

  /// {@macro flutter.widgets.ModalRoute.barrierLabel}
  final String? barrierLabel;

  /// Whether to use [SafeArea] to wrap the dialog.
  final bool useSafeArea;

  /// {@macro flutter.widgets.DisplayFeatureSubScreen.anchorPoint}
  final Offset? anchorPoint;

  /// Controls the transfer of focus beyond the first and the last items of a
  /// [FocusScopeNode].
  ///
  /// If set to null, [Navigator.routeTraversalEdgeBehavior] is used.
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  /// The builder that will be used to build the dialog.
  final WidgetBuilder builder;

  const DialogRoutePage({
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.anchorPoint,
    this.traversalEdgeBehavior,
    required this.builder,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
      builder: builder,
    );
  }
}
