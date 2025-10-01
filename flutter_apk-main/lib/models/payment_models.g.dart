// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      os: json['os'] as String,
      model: json['model'] as String,
      browser: json['browser'] as String,
      screenResolution: json['screen_resolution'] as String,
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'os': instance.os,
      'model': instance.model,
      'browser': instance.browser,
      'screen_resolution': instance.screenResolution,
      'timezone': instance.timezone,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

NetworkInfo _$NetworkInfoFromJson(Map<String, dynamic> json) => NetworkInfo(
      ipAddress: json['ip_address'] as String,
      isVpn: json['is_vpn'] as bool,
      isProxy: json['is_proxy'] as bool,
    );

Map<String, dynamic> _$NetworkInfoToJson(NetworkInfo instance) =>
    <String, dynamic>{
      'ip_address': instance.ipAddress,
      'is_vpn': instance.isVpn,
      'is_proxy': instance.isProxy,
    };

PaymentMetadata _$PaymentMetadataFromJson(Map<String, dynamic> json) =>
    PaymentMetadata(
      deviceInfo:
          DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      networkInfo:
          NetworkInfo.fromJson(json['network_info'] as Map<String, dynamic>),
      subscriptionId: json['subscription_id'] as String,
    );

Map<String, dynamic> _$PaymentMetadataToJson(PaymentMetadata instance) =>
    <String, dynamic>{
      'device_info': instance.deviceInfo,
      'location': instance.location,
      'network_info': instance.networkInfo,
      'subscription_id': instance.subscriptionId,
    };

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethodId: json['payment_method_id'] as String,
      provider: json['provider'] as String,
      metadata:
          PaymentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'payment_method_id': instance.paymentMethodId,
      'provider': instance.provider,
      'metadata': instance.metadata,
    };

SecuredPayment _$SecuredPaymentFromJson(Map<String, dynamic> json) =>
    SecuredPayment(
      encryptedData: json['encrypted_data'] as String,
      encryptedKey: json['encrypted_key'] as String,
      mac: json['mac'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$SecuredPaymentToJson(SecuredPayment instance) =>
    <String, dynamic>{
      'encrypted_data': instance.encryptedData,
      'encrypted_key': instance.encryptedKey,
      'mac': instance.mac,
      'timestamp': instance.timestamp,
    };

FeatureImportance _$FeatureImportanceFromJson(Map<String, dynamic> json) =>
    FeatureImportance(
      amount: (json['amount'] as num).toDouble(),
      frequency: (json['frequency'] as num).toDouble(),
      timePattern: (json['time_pattern'] as num).toDouble(),
      locationRisk: (json['location_risk'] as num).toDouble(),
      deviceRisk: (json['device_risk'] as num).toDouble(),
    );

Map<String, dynamic> _$FeatureImportanceToJson(FeatureImportance instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'frequency': instance.frequency,
      'time_pattern': instance.timePattern,
      'location_risk': instance.locationRisk,
      'device_risk': instance.deviceRisk,
    };

FraudAnalysis _$FraudAnalysisFromJson(Map<String, dynamic> json) =>
    FraudAnalysis(
      isFraudulent: json['is_fraudulent'] as bool,
      fraudProbability: (json['fraud_probability'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
      featureImportance: FeatureImportance.fromJson(
          json['feature_importance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FraudAnalysisToJson(FraudAnalysis instance) =>
    <String, dynamic>{
      'is_fraudulent': instance.isFraudulent,
      'fraud_probability': instance.fraudProbability,
      'risk_level': instance.riskLevel,
      'feature_importance': instance.featureImportance,
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      provider: json['provider'] as String,
      createdAt: json['created_at'] as String,
      providerPaymentId: json['provider_payment_id'] as String,
      securedPayment: SecuredPayment.fromJson(
          json['secured_payment'] as Map<String, dynamic>),
      fraudAnalysis: FraudAnalysis.fromJson(
          json['fraud_analysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'amount': instance.amount,
      'currency': instance.currency,
      'provider': instance.provider,
      'created_at': instance.createdAt,
      'provider_payment_id': instance.providerPaymentId,
      'secured_payment': instance.securedPayment,
      'fraud_analysis': instance.fraudAnalysis,
    };
