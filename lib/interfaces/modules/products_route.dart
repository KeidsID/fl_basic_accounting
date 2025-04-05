part of "../modules.dart";

@TypedGoRoute<ProductsRoute>(path: "/products", routes: [productDetailDeco])
class ProductsRoute extends GoRouteData {
  const ProductsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProductsScreen();
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products Page")),
      body: Consumer(
        builder: (context, ref, child) {
          final productsAsync = ref.watch(productsProvider);

          return switch (productsAsync) {
            AsyncData(:final value) => ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final product = value[index];

                return ListTile(
                  title: Text(product.name),
                  onTap: () => ProductDetailRoute(product.id).go(context),
                );
              },
            ),
            _ => child!,
          };
        },
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      drawer: Drawer(
        child: Consumer(
          builder: (context, ref, _) {
            final authAsync = ref.watch(authProvider);
            final user = authAsync.valueOrNull;

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(child: Text(user?.username ?? "Anonymous")),
                Builder(
                  builder: (context) {
                    final colorScheme = Theme.of(context).colorScheme;

                    return ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Sign Out"),
                      onTap: () => ref.read(authProvider.notifier).signOut(),
                      textColor: colorScheme.error,
                      iconColor: colorScheme.error,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
