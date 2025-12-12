import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.errorMessage = '',
  });

  final String email;
  final String password;
  final LoginStatus status;
  final String errorMessage;

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];
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
  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

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
    await Future<void>.delayed(const Duration(seconds: 1));

    // Dummy authentication success path.
    emit(state.copyWith(status: LoginStatus.success));
  }
}
