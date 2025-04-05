import "package:freezed_annotation/freezed_annotation.dart";

part "product_entity.freezed.dart";

@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
  }) = _Product;
}
