import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/result/result.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, email, name, role, isActive, createdAt];
}

@JsonSerializable()
class AuthRequest extends Equatable {
  final String email;
  final String password;
  final String? name;

  const AuthRequest({
    required this.email,
    required this.password,
    this.name,
  });

  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);

  ValidationResult validate() {
    final errors = <String, List<String>>{};

    if (email.isEmpty) {
      errors['email'] = ['Email is required'];
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = ['Invalid email format'];
    }

    if (password.isEmpty) {
      errors['password'] = ['Password is required'];
    } else if (password.length < 8) {
      errors['password'] = ['Password must be at least 8 characters'];
    }

    return errors.isEmpty
        ? const ValidationSuccess()
        : ValidationFailure(errors);
  }

  @override
  List<Object?> get props => [email, password];
}

@JsonSerializable()
class AuthResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final User user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, user];
}

sealed class AuthState extends Equatable {
  const AuthState();

  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.error(Map<String, List<String>> errors) = Error;

  @override
  List<Object?> get props => [];
}

class Initial extends AuthState {
  const Initial() : super();
}

class Loading extends AuthState {
  const Loading() : super();
}

class Authenticated extends AuthState {
  final User user;
  const Authenticated(this.user) : super();

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated() : super();
}

class Error extends AuthState {
  final Map<String, List<String>> errors;
  const Error(this.errors) : super();

  @override
  List<Object?> get props => [errors];
}