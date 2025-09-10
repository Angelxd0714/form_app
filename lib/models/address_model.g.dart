// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  street: json['street'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  country: json['country'] as String,
  additionalInfo: json['additionalInfo'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  id: json['id'] as String?,
  zipCode: json['zipCode'] as String,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'street': instance.street,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'additionalInfo': instance.additionalInfo,
  'isDefault': instance.isDefault,
  'zipCode': instance.zipCode,
};
