import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  unauthenticated,
  verifying,
  profileSetup,
  authenticated,
  guest,
}

class UserProfile {
  const UserProfile({
    this.name = '',
    this.phone = '',
    this.language = 'English',
    this.state = 'Karnataka',
  });

  final String name;
  final String phone;
  final String language;
  final String state;

  UserProfile copyWith({
    String? name,
    String? phone,
    String? language,
    String? state,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      state: state ?? this.state,
    );
  }
}

class AuthState {
  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.profile,
    this.pendingPhone,
    this.error,
    this.isLoading = false,
  });

  final AuthStatus status;
  final UserProfile? profile;
  final String? pendingPhone;
  final String? error;
  final bool isLoading;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated || status == AuthStatus.guest;
  bool get isGuest => status == AuthStatus.guest;
  String? get phoneNumber => profile?.phone ?? pendingPhone;

  AuthState copyWith({
    AuthStatus? status,
    UserProfile? profile,
    String? pendingPhone,
    String? error,
    bool? isLoading,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      pendingPhone: pendingPhone ?? this.pendingPhone,
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void sendOtp(String phone) {
    final clean = phone.trim().replaceAll(RegExp(r'\D'), '');
    if (clean.length != 10) {
      state =
          state.copyWith(error: 'Please enter a valid 10-digit mobile number');
      return;
    }
    state = state.copyWith(
      status: AuthStatus.verifying,
      pendingPhone: clean,
      clearError: true,
    );
  }

  void requestOtp(String phone) => sendOtp(phone);

  void verifyOtp(String otp) {
    if (otp.trim().length != 6) {
      state = state.copyWith(error: 'Please enter a 6-digit verification code');
      return;
    }
    state = state.copyWith(
      status: AuthStatus.profileSetup,
      profile: UserProfile(phone: state.pendingPhone ?? ''),
      clearError: true,
    );
  }

  void saveProfile({
    required String name,
    required String language,
    required String state_,
  }) {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      profile: (state.profile ?? const UserProfile()).copyWith(
        name: name.trim(),
        language: language,
        state: state_,
      ),
      clearError: true,
    );
  }

  void skipProfile() {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      clearError: true,
    );
  }

  void exploreAsGuest() {
    state = const AuthState(
      status: AuthStatus.guest,
      profile: UserProfile(name: 'Guest'),
    );
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

// Convenience alias
final authProvider = authControllerProvider;
