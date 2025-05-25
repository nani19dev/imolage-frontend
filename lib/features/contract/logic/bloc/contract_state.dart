part of 'contract_bloc.dart';

sealed class ContractState extends Equatable {
  const ContractState();
  
  @override
  List<Object?> get props => [];
}

final class ContractInitial extends ContractState {}
final class ContractLoading extends ContractState {}

class ContractsLoaded extends ContractState {
  final List<ContractModel> contracts;
  const ContractsLoaded({required this.contracts});

  @override
  List<Object?> get props => [contracts];
}

class ContractLoaded extends ContractState {
  final ContractModel contract;
  const ContractLoaded({required this.contract});

  @override
  List<Object?> get props => [contract];
}

class ContractOperationSuccess extends ContractState {
  final String message;
  const ContractOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class ContractError extends ContractState {
  final String error;

  const ContractError({required this.error});

  @override
  List<Object?> get props => [error];
}