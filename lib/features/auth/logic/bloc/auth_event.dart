part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent{
  final String username;
  final String email;
  final String password;
  //final String? firstName;
  //final String? lastName;

  SignUpEvent({
    required this.username,
    required this.email,
    required this.password
    //this.firstName,
    //this.lastName,
  });

  @override
  List<Object?> get props => [username, email, password];
  //List<Object?> get props => [username, email, password, firstName, lastName];

}

class SignInEvent extends AuthEvent{
  final String username;
  final String password;

  SignInEvent({
    required this.username,
    required this.password
  });

  @override
  List<Object?> get props => [username, password];
}

class SignOutEvent extends AuthEvent{}

class AuthCheckRequestedEvent extends AuthEvent {}

class TokenRefreshEvent extends AuthEvent {}
