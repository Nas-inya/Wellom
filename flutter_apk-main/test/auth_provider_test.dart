import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../lib/services/api_service.dart';
import '../lib/services/secure_storage.dart';
import '../lib/providers/auth_provider.dart';
import '../lib/models/auth_models.dart';

@GenerateMocks([ApiService, SecureStorageService])
void main() {
  late MockApiService mockApiService;
  late MockSecureStorageService mockSecureStorage;
  late AuthProvider authProvider;

  setUp(() {
    mockApiService = MockApiService();
    mockSecureStorage = MockSecureStorageService();
    authProvider = AuthProvider(
      apiService: mockApiService,
      secureStorage: mockSecureStorage,
    );
  });

  group('AuthProvider', () {
    final mockUser = User(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
      subscriptionStatus: 'active',
    );

    final mockAuthResponse = AuthResponse(
      accessToken: 'test-token',
      tokenType: 'bearer',
      expiresIn: 3600,
      user: mockUser,
    );

    test('login success updates state correctly', () async {
      when(mockApiService.login(any)).thenAnswer(
        (_) async => mockAuthResponse,
      );

      when(mockSecureStorage.saveAuthToken(any)).thenAnswer(
        (_) async => null,
      );

      final result = await authProvider.login('test@example.com', 'password');

      expect(result, true);
      expect(authProvider.state.isAuthenticated, true);
      expect(authProvider.state.user, mockUser);
      expect(authProvider.state.error, null);
      expect(authProvider.state.isLoading, false);

      verify(mockSecureStorage.saveAuthToken('test-token')).called(1);
    });

    test('login failure updates state correctly', () async {
      when(mockApiService.login(any)).thenThrow(
        AuthException(
          message: 'Invalid credentials',
          code: 'A003',
        ),
      );

      final result = await authProvider.login('test@example.com', 'password');

      expect(result, false);
      expect(authProvider.state.isAuthenticated, false);
      expect(authProvider.state.user, null);
      expect(authProvider.state.error, 'Invalid credentials');
      expect(authProvider.state.isLoading, false);

      verifyNever(mockSecureStorage.saveAuthToken(any));
    });

    test('logout clears state and storage', () async {
      // First login to set the state
      when(mockApiService.login(any)).thenAnswer(
        (_) async => mockAuthResponse,
      );

      when(mockSecureStorage.saveAuthToken(any)).thenAnswer(
        (_) async => null,
      );

      await authProvider.login('test@example.com', 'password');

      // Now test logout
      when(mockSecureStorage.deleteAll()).thenAnswer(
        (_) async => null,
      );

      await authProvider.logout();

      expect(authProvider.state.isAuthenticated, false);
      expect(authProvider.state.user, null);
      expect(authProvider.state.error, null);
      expect(authProvider.state.isLoading, false);

      verify(mockSecureStorage.deleteAll()).called(1);
    });
  });
}