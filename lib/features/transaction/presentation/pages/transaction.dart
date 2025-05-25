import 'package:flutter/material.dart';
import 'package:frontend/features/contract/presentation/widgets/no_contract.dart';
import 'package:frontend/features/transaction/logic/bloc/transaction_bloc.dart';
import 'package:frontend/features/transaction/presentation/widgets/transaction_card.dart';
import 'package:frontend/features/transaction/presentation/widgets/transaction_tile.dart';

class TabTransactions extends StatelessWidget {
  final TransactionState state;

  const TabTransactions({super.key, required this.state});

  Widget futureTransactionCard(BuildContext context, TransactionState state) {
    if (state is TransactionsLoaded) {
      return transactionCard(context, state.balance);
    } else if (state is TransactionError) {
      if (state.error == 'Exception: No active contract') {
        return const NoActiveContract();
      }
      return Center(child: Text(state.error));
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget listOfTransactions(TransactionState state) {
    if (state is TransactionsLoaded) {
      return ListView.builder(
        itemCount: state.transactions.length,
        itemBuilder: (BuildContext context, int index) {
          final transaction = state.transactions[index];
          if (transaction.amount < 0) {
            return outgoingtransactionTile(transaction, context);
          } 
          return incomingtransactionTile(transaction, context);
        }
      );
    } else if (state is TransactionError) {
      if (state.error == 'Exception: No active contract') {
        return const NoActiveContract();
      } 
      return Center(child: Text(state.error));
    } 
    return const Center(child: CircularProgressIndicator());
    //return const Center(child: Text('Create a contract'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        futureTransactionCard(context, state),
        const SizedBox(height: 24),
        Expanded(child: listOfTransactions(state)), 
      ],
    );
  }
}
