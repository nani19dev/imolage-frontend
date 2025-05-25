import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';
import 'package:frontend/features/contract/data/models/contract.dart';
import 'package:frontend/features/contract/data/repositories/contract_repository.dart';
import 'package:frontend/features/transaction/data/models/transaction.dart';
import 'package:frontend/features/transaction/data/repositories/transaction_reposiroty.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  final ContractRepository _contractRepository;
  final TokenRepository _tokenRepository;

  TransactionBloc({required TransactionRepository transactionRepository, required ContractRepository contractRepository, required TokenRepository tokenRepository,}) 
  : _transactionRepository = transactionRepository, _contractRepository = contractRepository, _tokenRepository = tokenRepository, super(TransactionInitial()) {
    
    on<TransactionsLoadEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        if (event.apartmentId != null) {  
          final contracts = await _contractRepository.getAllContracts(accessToken, event.apartmentId!);
          ContractModel? contract = ContractModel.findActive(contracts);
          
          if (contract != null) {
            final balance = await _contractRepository.getBalance(accessToken, contract.id!);
            final transactions = await _transactionRepository.getAllTransactions(accessToken, contract.id!);
            emit(TransactionsLoaded(balance: balance, transactions: transactions));
          } else {throw Exception('No active contract');}
        } else if(event.contractId != null) { 
          final balance = await _contractRepository.getBalance(accessToken, event.contractId!);
          final transactions = await _transactionRepository.getAllTransactions(accessToken, event.contractId!);
          emit(TransactionsLoaded(balance: balance, transactions: transactions));
        }
      } catch (e) {
        emit(TransactionError(error: e.toString()));
      }
    });

    on<TransactionCreateEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final contracts = await _contractRepository.getAllContracts(accessToken, event.apartmentId);
        ContractModel? contract = ContractModel.findByApartmentId(contracts, event.apartmentId);
        if (contract != null) {
          event.transaction.contractId = contract.id;
          await _transactionRepository.createTransaction(accessToken, event.transaction);
          emit(const TransactionOperationSuccess('Contract created successfully'));
          add(TransactionsLoadEvent(event.apartmentId, null)); // Refresh list
        } else {throw Exception('No contract');}
      } catch (e) {
        emit(TransactionError(error: e.toString()));
      }
    });

    on<TransactionLoadEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final TransactionModel transaction = await _transactionRepository.getTransaction(accessToken, event.transactionId);
        emit(TransactionLoaded(transaction: transaction));
      } catch (e) {
        emit(TransactionError(error: e.toString()));
      }
    });

    on<TransactionUpdateEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');
        
        await _transactionRepository.updateTransaction(accessToken, event.transaction);
        emit(const TransactionOperationSuccess('Contract updated successfully'));
        add(TransactionsLoadEvent(null, event.transaction.contractId)); // Refresh list
      } catch (e) {
        emit(TransactionError(error: e.toString()));
      }
    });

    on<TransactionDeleteEvent>((event, emit) async {
      emit(TransactionLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        await _transactionRepository.deleteTransaction(accessToken, event.transaction.id!);//fix later
        emit(const TransactionOperationSuccess('Contract deleted successfully'));
        add(TransactionsLoadEvent(null, event.transaction.contractId)); // Refresh list
      } catch (e) {
        emit(TransactionError(error: e.toString()));
      }
    });
  }
}
