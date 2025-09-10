import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'address_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final List<Address> addresses;

  User({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    List<Address>? addresses,
    String? id,
  })  : id = id ?? const Uuid().v4(),
        addresses = addresses ?? [];

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
