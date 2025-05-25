import 'dart:async';
import 'package:frontend/features/auth/logic/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/pages/sign_in.dart';
import 'package:frontend/features/auth/presentation/pages/sign_up.dart';
import 'package:frontend/features/contract/data/models/contract.dart';
import 'package:frontend/features/contract/presentation/pages/add.dart';
import 'package:frontend/features/contract/presentation/pages/contract_detail.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard.dart';
import 'package:frontend/features/property/presentation/pages/apartment/add.dart';
import 'package:frontend/features/property/presentation/pages/apartment/apartment_detail.dart';
import 'package:frontend/features/property/presentation/pages/property/add.dart';
import 'package:frontend/features/property/presentation/pages/property/properties.dart';
import 'package:frontend/features/property/presentation/pages/property/property_detail.dart';
import 'package:frontend/features/transaction/presentation/pages/add.dart';
import 'package:frontend/navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  late final GoRouter router;
  AppRouter({required AuthBloc authBloc}){
    router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        print('authState: $authState');
        if (authState is AuthAuthenticated) {
          if (state.fullPath == '/' || state.fullPath == '/sign-up') {
            return '/properties';
          }
        } else if (authState is AuthUnauthenticated){
          if (state.fullPath != '/' && state.fullPath != '/sign-up') {
            return '/';
          }
        } 
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'sign_in',
          builder: (BuildContext context, GoRouterState state) {
            return const SignInPage();
          },
        ),
        GoRoute(
          path: '/sign-up',
          name: 'sign_up',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
          },
        ),
        GoRoute(
          path: '/add/transaction',
          name: 'transaction_add',
          builder: (BuildContext context, GoRouterState state) {
            //final propertyId = state.extra as String;
            return const AddTransactionPage();
          },
        ),
        GoRoute(
          path: '/add/contract',
          name: 'contract_add',
          builder: (BuildContext context, GoRouterState state) {
            /*if (state.extra != null) {
              final propertyId = state.extra as String;
              return AddContractPage(propertyId: propertyId);
            }*/
            return const AddContractPage();
          },
        ),
        /*GoRoute(
          path: '/', // 
          name: 'contractAdd',
          builder: (BuildContext context, GoRouterState state) {
            /*if (state.extra != null) {
              final propertyId = state.extra as String;
              return AddContractPage(propertyId: propertyId);
            }*/
            return const AddContractPage();
          },
        ),*/
        GoRoute(
          path: '/contract/detail', 
          name: 'contract_detail',
          builder: (BuildContext context, GoRouterState state) {
            final contract = state.extra as ContractModel;
            return ContractDetailPage(contract: contract);
          },
        ),
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child){
            return MainScreens(child: child);
          },
          routes:[
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              builder: (BuildContext context, GoRouterState state) {
                return const DashboardPage();
              },
            ),
            GoRoute(
              path: '/properties',
              name: 'properties',
              builder: (BuildContext context, GoRouterState state) {
                return const PropertiesPage();
              },
              routes:[
                GoRoute(
                  path: 'add', 
                  name: 'property_add',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AddPropertyPage();
                  },
                ),
                /*GoRoute(
                  path: ":propertyId/:apartmentId",
                  name: 'apartment_detail',
                  builder: (BuildContext context, GoRouterState state) {
                    return ApartmentDetailPage(
                      propertyId: state.pathParameters['propertyId']!,
                      apartmentId: state.pathParameters['apartmentId']!,
                    );
                  },
                ),*/
                GoRoute(
                  path: ':propertyId', 
                  name: 'property_detail',
                  builder: (BuildContext context, GoRouterState state) {
                    return PropertyDetailPage(
                      propertyId: state.pathParameters['propertyId']!,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'add', 
                      name: 'apartment_add',
                      builder: (BuildContext context, GoRouterState state) {
                        return AddApartmentPage(
                          propertyId: state.pathParameters['propertyId']!,
                        );
                      },
                    ),
                    GoRoute(
                      path: ":apartmentId",
                      name: 'apartment_detail',
                      builder: (BuildContext context, GoRouterState state) {
                        return ApartmentDetailPage(
                          propertyId: state.pathParameters['propertyId']!,
                          apartmentId: state.pathParameters['apartmentId']!,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ]
        ),
      ]
    );
  }
}