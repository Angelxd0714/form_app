import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'address_model.g.dart';

@JsonSerializable()
class Address {
  final String id;
  final String street;
  final String city;
  final String state;
  final String country;
  final String? additionalInfo;
  final bool isDefault;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    this.additionalInfo,
    this.isDefault = false,
    String? id,
  }) : id = id ?? const Uuid().v4();

  String get fullAddress {
    return [
      street,
      city,
      state,
      country,
      if (additionalInfo != null) additionalInfo,
    ].where((part) => part != null && part.isNotEmpty).join(', ');
  }

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
