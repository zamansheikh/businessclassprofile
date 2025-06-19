import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../data/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInUseCase(
      SignInParams(
        emailOrUsername: event.emailOrUsername,
        password: event.password,
      ),
    );

    result.fold((failure) => emit(AuthError(message: failure.message)), (data) {
      try {
        final token = data['token'] as String;
        final userData = data['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userData);

        emit(AuthAuthenticated(user: user, token: token));
      } catch (e) {
        emit(const AuthError(message: 'Failed to parse user data'));
      }
    });
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(
        displayName: event.displayName,
        email: event.email,
        password: event.password,
        country: event.country,
      ),
    );

    result.fold((failure) => emit(AuthError(message: failure.message)), (data) {
      final message = data['message'] as String;
      emit(SignUpSuccess(message: message));
    });
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signOutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final userResult = await getCurrentUserUseCase();

    userResult.fold((failure) => emit(const AuthUnauthenticated()), (
      user,
    ) async {
      if (user != null) {
        // Try to get the token as well - we need to access it through the repository
        // Since we don't have direct access to the repository here, we'll simplify for now
        emit(AuthAuthenticated(user: user, token: ''));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }
}
