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

  String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    this.additionalInfo,
    this.isDefault = false,
    String? id, required this.zipCode,
  }) : id = id ?? const Uuid().v4();

  String get fullAddress {
    final parts = [city, state, zipCode];
    var result = parts.where((part) => part.isNotEmpty).join(', ');
    if (country.isNotEmpty) {
      result += ', $country';
    }
    return result;
  }

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  Address copyWith({
    String? id,
    String? street,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? additionalInfo,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
