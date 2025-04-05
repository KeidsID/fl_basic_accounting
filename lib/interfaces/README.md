# Interfaces Layer

Welcome to interfaces layer where you define UI/UX of the app.

This layer are simple, here's the summaries:

- `./libs/` -- contains widgets, providers, and other things that related to
  UI/UX.
- `./modules/` -- every routes defined here.
- `./modules.dart` -- router and routes should exported here.

## Modules Details

[go_router]: https://pub.dev/packages/go_router
[go_router_builder]: https://pub.dev/packages/go_router_builder

We will use Typed [go_router] using [go_router_builder] for our route handling,
so we hope you read the [go_router] docs first.

### Folder Strucutres

Here's the folder structure that will be used:

```txt
└── ~/interfaces/
    ├── `modules.dart` (router and routes data)
    └── `modules/`
        ├── `products_route.dart`
        ├── `products/` (sub-routes of products_route.dart)
        |   └── `product_detail_route.dart`
        ├── `products.dart` (will export every routes in `products/`)
        └── `others_route.dart`
```

Based on the above structure, we can say that:

- `modules.dart` -- Router and every routes should be exported here.
- `modules/` -- Every routes defined here.

So when you want to navigate to other route, just import the interfaces modules.

```dart
import "package:go_router/go_router.dart";
import "package:flutter/material.dart";

import "package:app/interfaces/modules.dart";

void navigateToProducts(BuildContext context) {
  const ProductsRoute().go(context);
}
```

### Defining Routes

We will define the route data along with the screen implementation and decorator
in the same file.

```dart
// ~/interfaces/modules/products/product_detail_route.dart

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
    // screen implementation...
  }
}
```

Due to the limitations of [go_router_builder], decorators for root routes will
be directly attached on the route class and the file will be part of
`modules.dart` rather than exported.

```dart
// ~/interfaces/modules/products_route.dart

part of "../modules.dart";

@TypedGoRoute<ProductsRoute>(path: "/products", routes: [
  productDetailDeco,
])
class ProductsRoute extends GoRouteData {
  const ProductsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductsScreen();
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // screen implementation...
  }
}

// ~/interfaces/modules.dart

import "modules/products.dart";

export "modules/products.dart";

part "modules/products_route.dart";

// router implementations...
```
