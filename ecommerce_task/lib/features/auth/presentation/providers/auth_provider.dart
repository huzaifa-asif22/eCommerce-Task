import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    try {
      state = state.copyWith(isLoading: true);
      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);
      final result = await getCurrentUserUseCase(NoParams());

      result.fold(
        (failure) => state = state.copyWith(isLoading: false, error: null),
        (user) =>
            state = state.copyWith(user: user, isLoading: false, error: null),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: null);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) =>
          state = state.copyWith(user: user, isLoading: false, error: null),
    );
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);

    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(
      RegisterParams(email: email, password: password, name: name),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (user) =>
          state = state.copyWith(user: user, isLoading: false, error: null),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      final result = await logoutUseCase(NoParams());

      result.fold(
        (failure) =>
            state = state.copyWith(isLoading: false, error: failure.message),
        (_) => state = const AuthState(),
      );
    } catch (e) {
      state = const AuthState();
    }
  }

  Future<void> updateProfile(User user) async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.updateProfile(user);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (updatedUser) => state = state.copyWith(user: updatedUser),
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
