import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/models/appuser.dart';
import 'package:frontend/features/auth/data/repositories/authentication_repository.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authRepository;
  final TokenRepository _tokenRepository;
  Timer? _tokenRefreshTimer;
  
  AuthBloc({required AuthenticationRepository authRepository, required TokenRepository tokenRepository})
  : _authRepository = authRepository, _tokenRepository = tokenRepository, super(AuthInitial()) {

    on<SignUpEvent>((SignUpEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final appUser = AppUserModel(
          username: event.username,
          email: event.email,
        );
        await _authRepository.signUp(appUser, event.password);
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<SignInEvent>((SignInEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        final data = await _authRepository.signIn(event.username, event.password);
        if (data['access'] != null) {
          await _tokenRepository.storeAccessToken(data['access']);
          await _tokenRepository.storeRefreshToken(data['refresh']);
          emit(AuthAuthenticated());
        } else {
          //errors data = {detail: No active account found with the given credentials},
          //{username: [This field may not be blank.], password: [This field may not be blank.]}
          emit(AuthUnauthenticated());
          throw Exception(data.toString());
        }
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<SignOutEvent>((SignOutEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {
        await _tokenRepository.deleteAccessToken();
        await _tokenRepository.deleteRefreshToken();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<AuthCheckRequestedEvent>((AuthCheckRequestedEvent event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      try {

        final bool hasToken = await _tokenRepository.isTokenValid();
        if (hasToken) {
          print('AuthCheckRequestedEvent - hasToken: $hasToken first');
          emit(AuthAuthenticated()); 
          return;
        } 

        final refreshToken = await _tokenRepository.getRefreshToken();
        if (refreshToken == null) {
          print('AuthCheckRequestedEvent - hasToken: $hasToken second');
          emit(AuthUnauthenticated());
          return;
        }

        final data = await _tokenRepository.refreshAccessToken();
        if (data['access'] != null) {
          print('AuthCheckRequestedEvent - refresh: ${data['access'] != null} third');
          await _tokenRepository.storeAccessToken(data['access']);
          emit(AuthAuthenticated());
          return;
        } else {
          print('AuthCheckRequestedEvent fourth');
          await _tokenRepository.deleteAccessToken();
          await _tokenRepository.deleteRefreshToken();
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    on<TokenRefreshEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final data = await _tokenRepository.refreshAccessToken();
        if (data['access'] != null) {
          await _tokenRepository.storeAccessToken(data['access']);
          if (data['refresh'] != null) {
            await _tokenRepository.storeRefreshToken(data['refresh']);
          }
          emit(AuthAuthenticated());
        } else {
          await _tokenRepository.deleteAccessToken();
          await _tokenRepository.deleteRefreshToken();
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(error: e.toString()));
      }
    });

    _startTokenRefreshTimer();
  }

  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    _tokenRefreshTimer = Timer.periodic(
      const Duration(minutes: 30),
      (_) => add(TokenRefreshEvent()),
    );
  }

  @override
  Future<void> close() {
    _tokenRefreshTimer?.cancel();
    return super.close();
  }

}


