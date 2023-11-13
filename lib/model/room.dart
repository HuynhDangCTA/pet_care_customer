

import 'package:pet_care_customer/core/constants.dart';

class Room {
  String? id;
  String? name;
  String? description;
  String? image;
  bool isEmpty;

  Room({this.id, this.image, this.name, this.description, this.isEmpty = true});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.description: description,
      Constants.isEmpty: isEmpty,
      Constants.image: image,
    };
  }

  factory Room.fromDocument(Map<String, dynamic> json) {
    return Room(
        name: json[Constants.name],
        description: json[Constants.description],
        image: json[Constants.image],
        isEmpty: json[Constants.isEmpty]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
