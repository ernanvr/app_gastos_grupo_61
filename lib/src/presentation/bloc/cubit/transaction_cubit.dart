import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // Add methods for insertTransaction, updateTransaction, deleteTransaction similarly if needed
}