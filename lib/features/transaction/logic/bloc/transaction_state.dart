part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();
  
  @override
  List<Object?> get props => [];
}

final class TransactionInitial extends TransactionState {}
final class TransactionLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final double balance;
  final List<TransactionModel> transactions;
  const TransactionsLoaded({required this.balance, required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class TransactionLoaded extends TransactionState {
  final TransactionModel transaction;
  const TransactionLoaded({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class TransactionOperationSuccess extends TransactionState {
  final String message;
  const TransactionOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class TransactionError extends TransactionState {
  final String error;

  const TransactionError({required this.error});

  @override
  List<Object?> get props => [error];
}
