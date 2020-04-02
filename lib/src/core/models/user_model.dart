import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/store_model.dart';

class UserModel extends Equatable {
  //* need other info like, date of birth, gender address, recently selected stores, default store, what eles with the same model or different model like address model
  final String id;
  final String firstName;
  final String lastName;
  final List<StoreModel> recentStores;

  UserModel({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.recentStores,
  })  : assert(id != null),
        assert(firstName != null),
        assert(lastName != null),
        assert(recentStores != null);

  factory UserModel.fromFirestore(Map snapshot, String id) {
    return UserModel(
      id: id ?? '',
      firstName: snapshot['firstName'] ?? '',
      lastName: snapshot['lastName'] ?? '',
      recentStores: (snapshot['recentStores'] as List ?? [])
          .map((data) => StoreModel.fromFirestore(data, data['id']))
          .toList(),
    );
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      // "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "recentStores": recentStores.map((store) => store.toMap()).toList(),
      //  "createdAt": DateTime.now(),
    };
  }

  @override
  List<Object> get props => [id, firstName, lastName, recentStores];

  @override
  bool get stringify => true;
}
