import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/domain/entities.dart";

part "product_providers.g.dart";

const _productsDummy = [
  Product(id: "product-1", name: "Lorem Ipsum", price: 1),
  Product(id: "product-2", name: "dolor sit amet", price: 2),
  Product(id: "product-3", name: "consectetur adipiscing elit", price: 3),
  Product(id: "product-4", name: "sed do eiusmod", price: 4),
  Product(id: "product-5", name: "tempor incididunt", price: 5),
];

@Riverpod(keepAlive: true)
FutureOr<List<Product>> products(Ref ref) {
  return Future.delayed(Duration(seconds: 1), () => _productsDummy);
}

@riverpod
FutureOr<Product> productDetail(Ref ref, String id) async {
  return Future.delayed(
    Duration(seconds: 1),
    () => _productsDummy.firstWhere((product) => product.id == id),
  );
}
