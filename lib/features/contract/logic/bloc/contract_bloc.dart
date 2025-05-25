import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';
import 'package:frontend/features/contract/data/models/contract.dart';
import 'package:frontend/features/contract/data/repositories/contract_repository.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final ContractRepository _contractRepository;
  final TokenRepository _tokenRepository;
  
  ContractBloc({required ContractRepository contractRepository, required TokenRepository tokenRepository}) 
  : _contractRepository = contractRepository, _tokenRepository = tokenRepository, super(ContractInitial()) {

    on<ContractsLoadEvent>((event, emit) async {
      emit(ContractLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final contracts = await _contractRepository.getAllContracts(accessToken, event.apartmentId);
        emit(ContractsLoaded(contracts: contracts));
      } catch (e) {
        emit(ContractError(error: e.toString()));
      }
    });

    on<ContractCreateEvent>((event, emit) async {
      emit(ContractLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        await _contractRepository.createContract(accessToken, event.contract);
        emit(const ContractOperationSuccess('Contract created successfully'));
        add(ContractsLoadEvent(event.contract.apartmentId!)); // Refresh list
      } catch (e) {
        emit(ContractError(error: e.toString()));
      }
    });

    on<ContractLoadEvent>((event, emit) async {
      emit(ContractLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final ContractModel contract = await _contractRepository.getContract(accessToken, event.contractId);
        emit(ContractLoaded(contract: contract));
      } catch (e) {
        emit(ContractError(error: e.toString()));
      }
    });

    on<ContractUpdateEvent>((event, emit) async {
      emit(ContractLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');
        
        await _contractRepository.updateContract(accessToken, event.contract);
        emit(const ContractOperationSuccess('Contract updated successfully'));
        add(ContractsLoadEvent(event.contract.apartmentId!)); // Refresh list
      } catch (e) {
        emit(ContractError(error: e.toString()));
      }
    });

    on<ContractDeleteEvent>((event, emit) async {
      emit(ContractLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        await _contractRepository.deleteContract(accessToken, event.contract.id!);//fix later
        emit(const ContractOperationSuccess('Contract deleted successfully'));
        add(ContractsLoadEvent(event.contract.apartmentId!)); // Refresh list
      } catch (e) {
        emit(ContractError(error: e.toString()));
      }
    });

  }
}