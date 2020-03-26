import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ProductModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String description;
  final String imageUrl;
  final int price;
  final int originalPrice;
  final String category;
  //* can be added
  // final String storeLayoutImageUrl;

  ProductModel({
    @required this.id,
    @required this.code,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.originalPrice,
    @required this.category,
    // @required this.storeLayoutImageUrl,
  })  : assert(id != null),
        assert(code != null),
        assert(name != null),
        assert(description != null),
        assert(imageUrl != null),
        assert(price != null),
        assert(originalPrice != null),
        assert(category != null);
  // assert(storeLayoutImageUrl != null);

  factory ProductModel.fromFirestore(Map snapshot, String id) {
    return ProductModel(
      id: id ?? '',
      code: snapshot['code'] ?? '',
      name: snapshot['name'] ?? '',
      description: snapshot['description'] ?? '',
      imageUrl: snapshot['imageUrl'] ?? '',
      price: snapshot['price'] ?? 0,
      originalPrice: snapshot['originalPrice'] ?? 0,
      category: snapshot['category'] ?? '',
      // storeLayoutImageUrl: snapshot['storeLayoutImageUrl'] ?? '',
    );
  }

  @override
  List<Object> get props => [
        id,
        code,
        name,
        description,
        imageUrl,
        price,
        originalPrice,
        category,
        // storeLayoutImageUrl
      ];

  @override
  bool get stringify => true;
}
