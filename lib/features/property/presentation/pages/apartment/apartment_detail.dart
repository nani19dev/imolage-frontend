import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/contract/logic/bloc/contract_bloc.dart';
import 'package:frontend/features/property/logic/bloc/apartment_bloc.dart';
import 'package:frontend/features/contract/presentation/pages/contract.dart';
import 'package:frontend/features/property/logic/bloc/property_bloc.dart';
import 'package:frontend/features/transaction/logic/bloc/transaction_bloc.dart';
import 'package:frontend/features/transaction/presentation/pages/transaction.dart';
import 'package:frontend/features/property/presentation/widgets/apartment/apartment_card.dart';
import 'package:go_router/go_router.dart';

class ApartmentDetailPage extends StatefulWidget {
  final String? propertyId;
  final String? apartmentId;
  const ApartmentDetailPage({super.key, this.propertyId, this.apartmentId});

  @override
  State<ApartmentDetailPage> createState() => _ApartmentDetailPageState();
}

class _ApartmentDetailPageState extends State<ApartmentDetailPage> {
  String? _apartmentType;

  Widget futureApartmentCard(ApartmentState state) {
    if (state is ApartmentLoaded) {
      if (state.apartment.type == "") {
        setState(() {
          _apartmentType = state.apartment.type;
        });
      }
      return apartmentCard(state.apartment);
    } else if (state is ApartmentError) {
      return Center(child: Text(state.error));
    }
    return const Center(child: CircularProgressIndicator());
  }

  /*void init() async {
    List<ContractModel> contracts = await ContractRepositoryImpl().getAllContracts(widget.propertyId!);
    ContractModel? contract = ContractModel.findActive(contracts);
    if (contract != null) {
      setState(() {
        _contract = ContractRepositoryImpl().getContract(contract.id!);
        _transactions = TransactionRepositoryImpl().getAllTransactions(contract.id!);
      });
    }
  }*/

  @override
  void initState() {
    super.initState();
    context.read<ApartmentBloc>().add(ApartmentLoadEvent(widget.apartmentId!));
    context.read<ContractBloc>().add(ContractsLoadEvent(widget.apartmentId!));
    context.read<TransactionBloc>().add(TransactionsLoadEvent(widget.apartmentId, null));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apartment Detail'),
        leading: BackButton(
          onPressed: () {
            if (_apartmentType == "") {
              context.read<PropertyBloc>().add(PropertiesLoadEvent()); 
            } else {
              context.read<ApartmentBloc>().add(ApartmentsLoadEvent(widget.propertyId!));
            }
            context.pop();
          },
        )
      ),
      body: DefaultTabController(
        length: 2,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ApartmentBloc, ApartmentState>(
              listener: (BuildContext context, ApartmentState state) {
                if (state is ApartmentError) {
                  errorMessage(state.error, context);
                }
              },
            ),
            BlocListener<TransactionBloc, TransactionState>(
              listener: (BuildContext context, TransactionState state) {
                if (state is TransactionError) {
                  if (state.error != 'Exception: No active contract') {
                    errorMessage(state.error, context);
                  }
                }
              },
            ),
            BlocListener<ContractBloc, ContractState>(
              listener: (BuildContext context, ContractState state) {
                if (state is ContractError) {
                  errorMessage(state.error, context);
                }
              },
            ),
          ],
          child: Column(
            children: [
              BlocBuilder<ApartmentBloc, ApartmentState>(
                builder: (BuildContext context, ApartmentState state) {
                  return futureApartmentCard(state);
                },
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Transactions'),
                  Tab(text: 'Contracts'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (BuildContext context, TransactionState state) {
                        return TabTransactions(state: state);
                      },
                    ),
                    BlocBuilder<ContractBloc, ContractState>(
                      builder: (BuildContext context, ContractState state) {
                        return TabContracts(state: state);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}