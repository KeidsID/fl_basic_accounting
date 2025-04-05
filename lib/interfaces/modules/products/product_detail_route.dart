import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "package:app/interfaces/libs/providers.dart";

const productDetailDeco = TypedGoRoute<ProductDetailRoute>(path: ":id");

class ProductDetailRoute extends GoRouteData {
  final String id;

  const ProductDetailRoute(this.id);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductDetailScreen(id);
  }
}

class ProductDetailScreen extends StatelessWidget {
  final String id;

  const ProductDetailScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Detail Page")),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final productAsync = ref.watch(productDetailProvider(id));

            return switch (productAsync) {
              AsyncData(:final value) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Product ID: $id"),
                  Text("Name: ${value.name}"),
                  Text("Price: \$${value.price.toStringAsFixed(2)}"),
                ],
              ),
              AsyncError() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Fail to load product"),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(productDetailProvider(id)),
                    label: Text("Refresh"),
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
              _ => child!,
            };
          },
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
