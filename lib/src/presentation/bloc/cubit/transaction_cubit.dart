import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

import 'transaction_state.dart'; // Assuming your state file is named this

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this._transactionRepository) : super(const TransactionState());

  final TransactionRepository _transactionRepository;

  Future<void> loadTransactionsByBudgetId(int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final transactionsResult = await _transactionRepository.getTransactionsByBudgetId(budgetId);
      transactionsResult.fold(
        (failure) => emit(state.copyWith(status: TransactionStatus.error, errorMessage: failure.message)),
        (transactions) => emit(state.copyWith(status: TransactionStatus.loaded, transactions: transactions)),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TransactionStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> insertTransaction(Transaction transaction, int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _transactionRepository.insertTransaction(transaction);
      result.fold(
        (failure) => emit(state.copyWith(status: TransactionStatus.error, errorMessage: failure.message)),
        (_) {
          // On successful insertion, reload transactions for the current budget
          loadTransactionsByBudgetId(budgetId);
        },
      );
    } catch (e) {
      emit(state.copyWith(status: TransactionStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> updateTransaction(Transaction transaction, int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _transactionRepository.updateTransaction(transaction);
      result.fold(
        (failure) => emit(state.copyWith(status: TransactionStatus.error, errorMessage: failure.message)),
        (_) {
          // On successful update, reload transactions for the current budget
          loadTransactionsByBudgetId(budgetId);
        },
      );
    } catch (e) {
      emit(state.copyWith(status: TransactionStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> deleteTransaction(Transaction transaction, int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _transactionRepository.deleteTransaction(transaction);
      result.fold(
        (failure) => emit(state.copyWith(status: TransactionStatus.error, errorMessage: failure.message)),
        (_) {
          // On successful deletion, reload transactions for the current budget
          loadTransactionsByBudgetId(budgetId);
        },
      );
    } catch (e) {
      emit(state.copyWith(status: TransactionStatus.error, errorMessage: e.toString()));
    }
  }
}