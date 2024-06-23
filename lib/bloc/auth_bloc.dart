import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/database_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      var user = await _dbHelper.getUser(event.username, event.password);
      if (user != null) {
        emit(AuthAuthenticated(event.username));
      } else {
        emit(AuthError("Invalid username or password"));
      }
    } catch (e) {
      emit(AuthError("An error occurred"));
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthInitial());
  }
}
