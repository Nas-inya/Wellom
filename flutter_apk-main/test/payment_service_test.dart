import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../lib/services/api_service.dart';
import '../lib/services/payment_service.dart';
import '../lib/models/payment_models.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late PaymentService paymentService;

  setUp(() {
    mockApiService = MockApiService();
    paymentService = PaymentService(apiService: mockApiService);
  });

  group('PaymentService', () {
    final mockPayment = Payment(
      id: 'test-payment-id',
      status: 'success',
      amount: 100.0,
      currency: 'USD',
      provider: 'stripe',
      createdAt: DateTime.now().toIso8601String(),
      providerPaymentId: 'stripe-payment-id',
      securedPayment: SecuredPayment(
        encryptedData: 'encrypted',
        encryptedKey: 'key',
        mac: 'mac',
        timestamp: DateTime.now().toIso8601String(),
      ),
      fraudAnalysis: FraudAnalysis(
        isFraudulent: false,
        fraudProbability: 0.1,
        riskLevel: 'low',
        featureImportance: FeatureImportance(
          amount: 0.2,
          frequency: 0.1,
          timePattern: 0.3,
          locationRisk: 0.1,
          deviceRisk: 0.1,
        ),
      ),
    );

    test('processPayment success returns payment details', () async {
      when(mockApiService.processPayment(any)).thenAnswer(
        (_) async => mockPayment,
      );

      when(mockApiService.verifyPayment(any, any)).thenAnswer(
        (_) async => {'status': 'verified'},
      );

      when(mockApiService.analyzePaymentRisk(any)).thenAnswer(
        (_) async => {
          'risk_analysis': {
            'is_fraudulent': false,
            'fraud_probability': 0.1,
            'risk_level': 'low',
          },
        },
      );

      final result = await paymentService.processPayment(
        amount: 100.0,
        currency: 'USD',
        paymentMethodId: 'pm_test',
        provider: 'stripe',
        subscriptionId: 'sub_test',
      );

      expect(result.id, mockPayment.id);
      expect(result.status, 'success');
      expect(result.amount, 100.0);
      expect(result.fraudAnalysis.isFraudulent, false);

      verify(mockApiService.processPayment(any)).called(1);
      verify(mockApiService.analyzePaymentRisk(any)).called(1);
    });

    test('processPayment handles fraud detection', () async {
      final fraudulentPayment = mockPayment.copyWith(
        fraudAnalysis: FraudAnalysis(
          isFraudulent: true,
          fraudProbability: 0.9,
          riskLevel: 'high',
          featureImportance: FeatureImportance(
            amount: 0.8,
            frequency: 0.7,
            timePattern: 0.9,
            locationRisk: 0.8,
            deviceRisk: 0.7,
          ),
        ),
      );

      when(mockApiService.processPayment(any)).thenAnswer(
        (_) async => fraudulentPayment,
      );

      expect(
        () => paymentService.processPayment(
          amount: 100.0,
          currency: 'USD',
          paymentMethodId: 'pm_test',
          provider: 'stripe',
          subscriptionId: 'sub_test',
        ),
        throwsA(isA<PaymentException>()),
      );
    });

    test('verifyPayment success returns true', () async {
      when(mockApiService.verifyPayment(any, any)).thenAnswer(
        (_) async => {'status': 'verified'},
      );

      final result = await paymentService.verifyPayment(
        'test-payment-id',
        {'test': 'data'},
      );

      expect(result, true);
      verify(mockApiService.verifyPayment(any, any)).called(1);
    });

    test('analyzePaymentRisk returns risk analysis', () async {
      final mockRiskAnalysis = {
        'risk_analysis': {
          'is_fraudulent': false,
          'fraud_probability': 0.1,
          'risk_level': 'low',
        },
        'recommendation': 'proceed',
        'quantum_enhanced': true,
      };

      when(mockApiService.analyzePaymentRisk(any)).thenAnswer(
        (_) async => mockRiskAnalysis,
      );

      final request = PaymentRequest(
        amount: 100.0,
        currency: 'USD',
        paymentMethodId: 'pm_test',
        provider: 'stripe',
        metadata: PaymentMetadata(
          deviceInfo: DeviceInfo(
            os: 'iOS',
            model: 'iPhone',
            browser: 'Safari',
            screenResolution: '1920x1080',
            timezone: 'UTC',
          ),
          location: Location(
            latitude: 0.0,
            longitude: 0.0,
          ),
          networkInfo: NetworkInfo(
            ipAddress: '127.0.0.1',
            isVpn: false,
            isProxy: false,
          ),
          subscriptionId: 'sub_test',
        ),
      );

      final result = await paymentService.analyzePaymentRisk(request);

      expect(result, mockRiskAnalysis);
      verify(mockApiService.analyzePaymentRisk(any)).called(1);
    });
  });
}