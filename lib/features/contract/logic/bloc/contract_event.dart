part of 'contract_bloc.dart';

sealed class ContractEvent extends Equatable {
  const ContractEvent();

  @override
  List<Object?> get props => [];
}

class ContractsLoadEvent extends ContractEvent {
  final String apartmentId;
  const ContractsLoadEvent(this.apartmentId);

  @override
  List<Object?> get props => [apartmentId];
}

class ContractCreateEvent extends ContractEvent {
  final ContractModel contract;
  const ContractCreateEvent(this.contract);

  @override
  List<Object?> get props => [contract];
}

class ContractLoadEvent extends ContractEvent {
  final String contractId;
  const ContractLoadEvent(this.contractId);
  
  @override
  List<Object?> get props => [contractId];
}

class ContractUpdateEvent extends ContractEvent {
  final ContractModel contract;
  const ContractUpdateEvent(this.contract);

  @override
  List<Object?> get props => [contract];
}

class ContractDeleteEvent extends ContractEvent {
  final ContractModel contract;
  const ContractDeleteEvent(this.contract);

  @override
  List<Object?> get props => [contract];
}