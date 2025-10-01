import 'package:json_annotation/json_annotation.dart';

part 'payment_models.g.dart';

@JsonSerializable()
class DeviceInfo {
  final String os;
  final String model;
  final String browser;
  @JsonKey(name: 'screen_resolution')
  final String screenResolution;
  final String timezone;

  DeviceInfo({
    required this.os,
    required this.model,
    required this.browser,
    required this.screenResolution,
    required this.timezone,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

@JsonSerializable()
class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class NetworkInfo {
  @JsonKey(name: 'ip_address')
  final String ipAddress;
  @JsonKey(name: 'is_vpn')
  final bool isVpn;
  @JsonKey(name: 'is_proxy')
  final bool isProxy;

  NetworkInfo({
    required this.ipAddress,
    required this.isVpn,
    required this.isProxy,
  });

  factory NetworkInfo.fromJson(Map<String, dynamic> json) =>
      _$NetworkInfoFromJson(json);
  Map<String, dynamic> toJson() => _$NetworkInfoToJson(this);
}

@JsonSerializable()
class PaymentMetadata {
  @JsonKey(name: 'device_info')
  final DeviceInfo deviceInfo;
  final Location location;
  @JsonKey(name: 'network_info')
  final NetworkInfo networkInfo;
  @JsonKey(name: 'subscription_id')
  final String subscriptionId;

  PaymentMetadata({
    required this.deviceInfo,
    required this.location,
    required this.networkInfo,
    required this.subscriptionId,
  });

  factory PaymentMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaymentMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMetadataToJson(this);
}

@JsonSerializable()
class PaymentRequest {
  final double amount;
  final String currency;
  @JsonKey(name: 'payment_method_id')
  final String paymentMethodId;
  final String provider;
  final PaymentMetadata metadata;

  PaymentRequest({
    required this.amount,
    required this.currency,
    required this.paymentMethodId,
    required this.provider,
    required this.metadata,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable()
class SecuredPayment {
  @JsonKey(name: 'encrypted_data')
  final String encryptedData;
  @JsonKey(name: 'encrypted_key')
  final String encryptedKey;
  final String mac;
  final String timestamp;

  SecuredPayment({
    required this.encryptedData,
    required this.encryptedKey,
    required this.mac,
    required this.timestamp,
  });

  factory SecuredPayment.fromJson(Map<String, dynamic> json) =>
      _$SecuredPaymentFromJson(json);
  Map<String, dynamic> toJson() => _$SecuredPaymentToJson(this);
}

@JsonSerializable()
class FeatureImportance {
  final double amount;
  final double frequency;
  @JsonKey(name: 'time_pattern')
  final double timePattern;
  @JsonKey(name: 'location_risk')
  final double locationRisk;
  @JsonKey(name: 'device_risk')
  final double deviceRisk;

  FeatureImportance({
    required this.amount,
    required this.frequency,
    required this.timePattern,
    required this.locationRisk,
    required this.deviceRisk,
  });

  factory FeatureImportance.fromJson(Map<String, dynamic> json) =>
      _$FeatureImportanceFromJson(json);
  Map<String, dynamic> toJson() => _$FeatureImportanceToJson(this);
}

@JsonSerializable()
class FraudAnalysis {
  @JsonKey(name: 'is_fraudulent')
  final bool isFraudulent;
  @JsonKey(name: 'fraud_probability')
  final double fraudProbability;
  @JsonKey(name: 'risk_level')
  final String riskLevel;
  @JsonKey(name: 'feature_importance')
  final FeatureImportance featureImportance;

  FraudAnalysis({
    required this.isFraudulent,
    required this.fraudProbability,
    required this.riskLevel,
    required this.featureImportance,
  });

  factory FraudAnalysis.fromJson(Map<String, dynamic> json) =>
      _$FraudAnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$FraudAnalysisToJson(this);
}

@JsonSerializable()
class Payment {
  final String id;
  final String status;
  final double amount;
  final String currency;
  final String provider;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'provider_payment_id')
  final String providerPaymentId;
  @JsonKey(name: 'secured_payment')
  final SecuredPayment securedPayment;
  @JsonKey(name: 'fraud_analysis')
  final FraudAnalysis fraudAnalysis;

  Payment({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    required this.provider,
    required this.createdAt,
    required this.providerPaymentId,
    required this.securedPayment,
    required this.fraudAnalysis,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}