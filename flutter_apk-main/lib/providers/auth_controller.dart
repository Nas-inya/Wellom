import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import '../core/result/result.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.watch(apiServiceProvider),
    ref.watch(secureStorageServiceProvider),
  );
});

class AuthController extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final SecureStorageService _storage;

  AuthController(this._apiService, this._storage)
      : super(const AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    state = const AuthState.loading();

    final storedToken = await _storage.read('access_token');
    if (storedToken == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    final result = await _apiService.getCurrentUser();
    result.when(
      success: (user) {
        state = AuthState.authenticated(user);
      },
      failure: (_) {
        state = const AuthState.unauthenticated();
        _storage.delete('access_token');
      },
    );
  }

  Future<void> signIn(AuthRequest request) async {
    if (state is Loading) return;

    state = const AuthState.loading();

    final validation = request.validate();
    if (validation is ValidationFailure) {
      state = AuthState.error(validation.errors);
      return;
    }

    final result = await _apiService.signIn(request);
    await result.when(
      success: (response) async {
        await _storage.write(
          key: 'access_token',
          value: response.accessToken,
          metadata: {
            'expires_at': response.expiresAt.toIso8601String(),
          },
        );
        await _storage.write(
          key: 'refresh_token',
          value: response.refreshToken,
        );
        state = AuthState.authenticated(response.user);
      },
      failure: (error) {
        state = AuthState.error({
          'auth': [error.userFriendlyMessage],
        });
      },
    );
  }

  Future<void> signOut() async {
    if (state is! Authenticated) return;

    state = const AuthState.loading();

    final result = await _apiService.signOut();
    result.when(
      success: (_) async {
        await _storage.delete('access_token');
        await _storage.delete('refresh_token');
        state = const AuthState.unauthenticated();
      },
      failure: (error) {
        state = AuthState.authenticated((state as Authenticated).user);
      },
    );
  }

  Future<void> refreshSession() async {
    if (state is! Authenticated) return;

    final refreshToken = await _storage.read('refresh_token');
    if (refreshToken == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    final result = await _apiService.refreshToken(refreshToken);
    await result.when(
      success: (response) async {
        await _storage.write(
          key: 'access_token',
          value: response.accessToken,
          metadata: {
            'expires_at': response.expiresAt.toIso8601String(),
          },
        );
        await _storage.write(
          key: 'refresh_token',
          value: response.refreshToken,
        );
        state = AuthState.authenticated(response.user);
      },
      failure: (_) {
        state = const AuthState.unauthenticated();
        _storage.delete('access_token');
        _storage.delete('refresh_token');
      },
    );
  }

  Future<void> updateProfile(User updatedUser) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    final result = await _apiService.updateUser(updatedUser);

    result.when(
      success: (user) {
        state = AuthState.authenticated(user);
      },
      failure: (_) {
        state = AuthState.authenticated(currentState.user);
      },
    );
  }

  Future<void> updateSettings(UserSettings settings) async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    final updatedUser = currentState.user.copyWith(settings: settings);
    
    await updateProfile(updatedUser);
  }

  Future<void> enableTwoFactor() async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    final currentSettings = currentState.user.settings;
    
    final updatedSettings = currentSettings.copyWith(
      twoFactorEnabled: true,
    );
    
    await updateSettings(updatedSettings);
  }

  Future<void> disableTwoFactor() async {
    if (state is! Authenticated) return;

    final currentState = state as Authenticated;
    final currentSettings = currentState.user.settings;
    
    final updatedSettings = currentSettings.copyWith(
      twoFactorEnabled: false,
    );
    
    await updateSettings(updatedSettings);
  }

  void resetError() {
    if (state is Error) {
      state = const AuthState.unauthenticated();
    }
  }
}

sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error(Map<String, List<String>> errors) = Error;
}

class Initial extends AuthState {
  const Initial();
}

class Loading extends AuthState {
  const Loading();
}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class Error extends AuthState {
  final Map<String, List<String>> errors;
  const Error(this.errors);
}