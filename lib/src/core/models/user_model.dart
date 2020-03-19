import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserModel extends Equatable {
  //* need other info like address, recently selected stores, default store, what eles with the same model or different model like address model
  final String id;
  final String firstName;
  final String lastName;

  UserModel({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
  })  : assert(id != null),
        assert(firstName != null),
        assert(lastName != null);

  factory UserModel.fromFirestore(Map snapshot, String id) {
    return UserModel(
      id: id ?? '',
      firstName: snapshot['firstName'] ?? '',
      lastName: snapshot['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      // "id": id,
      "firstName": firstName,
      "lastName": lastName,
      //  "createdAt": DateTime.now(),
    };
  }

  @override
  List<Object> get props => [id, firstName, lastName];

  @override
  bool get stringify => true;
}
