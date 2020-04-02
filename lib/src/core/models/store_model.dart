import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class StoreModel extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String category;
  final Map position;

  StoreModel({
    @required this.id,
    @required this.name,
    @required this.brand,
    @required this.category,
    @required this.position,
  })  : assert(id != null),
        assert(name != null),
        assert(brand != null),
        assert(category != null),
        assert(position != null);

  factory StoreModel.fromFirestore(Map snapshot, String id) {
    //* what is the best way to handle null
    // if (snapshot == null)
    //   return StoreModel(
    //     id: id ?? '',
    //     name: '',
    //     brand: '',
    //     category: '',
    //     position: {},
    //   );
    return StoreModel(
      id: id ?? '',
      name: snapshot['name'] ?? '',
      brand: snapshot['brand'] ?? '',
      category: snapshot['category'] ?? '',
      position: snapshot['position'] ?? {},
    );
  }

  // Map<String, dynamic> toMapForeFirestore() {
  //   return {
  //     // "id": id,
  //     "name": name,
  //     "brand": brand,
  //     "category": category,
  //     "position": position,
  //   };
  // }

  factory StoreModel.fromMap(Map data) {
    return StoreModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      category: data['category'] ?? '',
      position: data['position'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "brand": brand,
      "category": category,
      "position": position,
    };
  }

  @override
  List<Object> get props => [id, name, brand, category, position];

  @override
  bool get stringify => true;
}
