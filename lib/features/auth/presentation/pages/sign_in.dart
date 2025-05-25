import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/commun/widgets/fields/textfield.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/auth/logic/bloc/auth_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _formContent(AuthState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultTextField(
          controller: _usernameController,
          labelText: usernameLabel,
        ),
        PasswordField(
          controller: _passwordController,
          labelText: passwordLabel,
        ),
        ElevatedButton(
          onPressed: state is AuthLoading ? null : () {
            context.read<AuthBloc>().add(
              SignInEvent(
                username: _usernameController.text,
                password: _passwordController.text,
              )
            );
          },
          child: Text(state is AuthLoading ? loadingLabel : signInLabel),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => context.goNamed(routeSignIn),
          child: Text(signUpLabel),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is AuthAuthenticated) {
                context.goNamed(routeProperties);
                successMessage(successSignInLabel, context);
              } else if (state is AuthError) {
                errorMessage(state.error.toString(), context);
              }
            },
            builder: (BuildContext context, AuthState state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, size: 100),
                  const SizedBox(height: 100),
                  _formContent(state),
                ],
              );
            },
          )
        )
      ),
    );
  }

}
