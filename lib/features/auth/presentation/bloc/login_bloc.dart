import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_use_case.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.errorMessage = '',
    this.user,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final String errorMessage;
  final User? user;

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? errorMessage,
    User? user,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage, user];
}

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);
  final String password;

  @override
  List<Object?> get props => [password];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase _loginUseCase;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        status: LoginStatus.initial,
        errorMessage: '',
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        status: LoginStatus.initial,
        errorMessage: '',
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Email and password are required.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: ''));
    try {
      final user = await _loginUseCase(
        LoginParams(email: state.email, password: state.password),
      );
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } catch (error) {
      final message = _mapError(error);
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: message));
    }
  }

  String _mapError(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Unexpected error, please try again.';
  }
}
