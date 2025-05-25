import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/config/routes/app_router.dart';
import 'package:frontend/config/theme/app_themes.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/features/auth/data/repositories/authentication_repository.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';
import 'package:frontend/features/auth/logic/bloc/auth_bloc.dart';
import 'package:frontend/features/contract/data/repositories/contract_repository.dart';
import 'package:frontend/features/contract/logic/bloc/contract_bloc.dart';
import 'package:frontend/features/property/data/repositories/apartment_repository.dart';
import 'package:frontend/features/property/data/repositories/property_repository.dart';
import 'package:frontend/features/property/logic/bloc/apartment_bloc.dart';
import 'package:frontend/features/property/logic/bloc/property_bloc.dart';
import 'package:frontend/features/transaction/data/repositories/transaction_reposiroty.dart';
import 'package:frontend/features/transaction/logic/bloc/transaction_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  //apiUrl = dotenv.env['API_URL'] ?? '';
  //appName = dotenv.env['APP_NAME'] ?? '';

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenRepository>(
          create: (context) => TokenRepository(),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
        ),
        RepositoryProvider<PropertyRepository>(
          create: (context) => PropertyRepository(),
        ),
        RepositoryProvider<ApartmentRepository>(
          create: (context) => ApartmentRepository(),
        ),
        RepositoryProvider<ContractRepository>(
          create: (context) => ContractRepository(),
        ),
        RepositoryProvider<TransactionRepository>(
          create: (context) => TransactionRepository(),
        ),
      ],
      child: MultiBlocProvider( 
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthenticationRepository>(),
              tokenRepository: context.read<TokenRepository>(),
            )..add(AuthCheckRequestedEvent()),
          ),
          BlocProvider<PropertyBloc>(
            create: (context) => PropertyBloc(
              propertyRepository: context.read<PropertyRepository>(),
              apartmentRepository: context.read<ApartmentRepository>(),
              tokenRepository: context.read<TokenRepository>(),
            ),
          ),
          BlocProvider<ApartmentBloc>(
            create: (context) => ApartmentBloc(
              apartmentRepository: context.read<ApartmentRepository>(),
              tokenRepository: context.read<TokenRepository>(),
            ),
          ),
          BlocProvider<ContractBloc>(
            create: (context) => ContractBloc(
              contractRepository: context.read<ContractRepository>(),
              tokenRepository: context.read<TokenRepository>(),
            ),
          ),
          BlocProvider<TransactionBloc>(
            create: (context) => TransactionBloc(
              transactionRepository: context.read<TransactionRepository>(),
              contractRepository: context.read<ContractRepository>(),
              tokenRepository: context.read<TokenRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //check for connection
    final authBloc = context.read<AuthBloc>();
    return MaterialApp.router(
      title: 'appName',
      theme: theme(),
      darkTheme: darkTheme(),
      themeMode: themeMode(),
      routerConfig: AppRouter(authBloc: authBloc).router,
    );
  }
}
