import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/commun/widgets/button.dart';
import 'package:frontend/commun/widgets/fields/textfield.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/auth/logic/bloc/auth_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  //final _firstNameController = TextEditingController();
  //final _lastNameController = TextEditingController();

  Widget _formContent(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*FormTextField(
            controller: _firstNameController,
            keyboardType: TextInputType.text,
            isRequired: true,
            labelText: firstnameLabel,
            text: _firstNameController.text
          ),
          FormTextField(
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            isRequired: true,
            labelText: lastNameLabel,
            text: _lastNameController.text
          ),*/
          FormTextField(
            controller: _usernameController,
            keyboardType: TextInputType.text,
            isRequired: true,
            labelText: usernameLabel,
            text: _usernameController.text
          ),
          FormTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            labelText: emailLabel,
            text: _emailController.text
          ),
          FormTextField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            isRequired: true,
            labelText: passwordLabel,
            text: _passwordController.text
          ),
          /*FormPasswordField(
            controller: _passwordController,
            labelText: passwordLabel,
          ),*/
          FormConfirmPasswordField(
            passwordcontroller: _passwordController,
            controller: _confirmPasswordController,
            labelText: confirmPasswordLabel,
          ),
          FormButton(
            formkey: _formKey,
            onPressed: state is AuthLoading ? null : () async {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignUpEvent(
                    username: _usernameController.text.trim(), 
                    email: _emailController.text.trim(), 
                    password: _passwordController.text.trim()
                  )
                );
              }
            },
            text: state is AuthLoading ? loadingLabel : createAccountLabel,
          ),
          OutlinedButton(
            onPressed: () => context.goNamed(routeSignUp),
            child: Text(signInLabel),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    //_firstNameController.dispose();
    //_lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (BuildContext context, AuthState state) {
              if (state is AuthError) {
                errorMessage(state.error.toString(), context);
              } else {
                successMessage(successCreatedLabel, context);
                return context.goNamed(routeSignIn);
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
