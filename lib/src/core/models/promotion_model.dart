import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PromotionModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  PromotionModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(imageUrl != null);

  factory PromotionModel.fromFirestore(Map snapshot, String id) {
    return PromotionModel(
      id: id ?? '',
      name: snapshot['name'] ?? '',
      imageUrl: snapshot['imageUrl'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, name, imageUrl];

  @override
  bool get stringify => true;
}
