part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionsLoadEvent extends TransactionEvent {
  final String? apartmentId;
  final String? contractId;
  const TransactionsLoadEvent(this.apartmentId, this.contractId);

  @override
  List<Object?> get props => [apartmentId, contractId];
}

class TransactionCreateEvent extends TransactionEvent {
  final String apartmentId;
  final TransactionModel transaction;
  const TransactionCreateEvent(this.transaction, this.apartmentId);

  @override
  List<Object?> get props => [transaction, apartmentId];
}

class TransactionLoadEvent extends TransactionEvent {
  final String transactionId;
  const TransactionLoadEvent(this.transactionId);
  
  @override
  List<Object?> get props => [transactionId];
}

class TransactionUpdateEvent extends TransactionEvent {
  final TransactionModel transaction;
  const TransactionUpdateEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleteEvent extends TransactionEvent {
  final TransactionModel transaction;
  const TransactionDeleteEvent(this.transaction);

  @override
  List<Object?> get props => [transaction];
}