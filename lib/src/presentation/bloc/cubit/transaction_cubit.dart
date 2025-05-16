import 'package:app_gastos_grupo_61/core/helpers/classes.dart';

import 'package:app_gastos_grupo_61/src/domain/repository/transaction_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

import 'transaction_state.dart'; // Assuming your state file is named this

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(this._transactionRepository)
    : super(const TransactionState());

  final TransactionRepository _transactionRepository;

  Future<void> loadTransactionsByBudgetId(int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final transactionsResult = await _transactionRepository
          .getTransactionsByBudgetId(budgetId);
      transactionsResult.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (transactions) => emit(
          state.copyWith(
            status: TransactionStatus.loaded,
            transactions: transactions,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> insertTransaction(Transaction transaction, int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _transactionRepository.insertTransaction(
        transaction,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful insertion, reload transactions for the current budget
          loadTransactionsByBudgetId(budgetId);
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> updateTransaction(Transaction transaction, int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _transactionRepository.updateTransaction(
        transaction,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful update, reload transactions for the current budget
          loadTransactionsByBudgetId(budgetId);
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteTransaction(Transaction transaction, int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _transactionRepository.deleteTransaction(
        transaction,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful deletion, reload transactions for the current budget
          loadTransactionsByBudgetId(budgetId);
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> generatePieChartValues() async {
    try {
      // Ensure transactions are loaded and not empty
      if (state.status != TransactionStatus.loaded ||
          state.transactions.isEmpty) {
        // If no transactions or state not loaded, set empty list and return
        emit(
          state.copyWith(pieChartValues: <PieChartValue>[]),
        ); // Assuming pieChartValues is a field in TransactionState of type List<PieChartValues>
        return;
      }

      final Map<String, int> categoryCounts = {};

      for (final transaction in state.transactions) {
        // Assuming TransactionWithCategory has a 'category' field with a 'name' property
        final categoryName = transaction.categoryName;
        categoryCounts[categoryName] = (categoryCounts[categoryName] ?? 0) + 1;
      }

      // Convert the map to a List of PieChartValues objects
      final List<PieChartValue> pieChartValues =
          categoryCounts.entries.map((entry) {
            return PieChartValue(entry.key, entry.value);
          }).toList();

      emit(
        state.copyWith(pieChartValues: pieChartValues),
      ); // Assuming pieChartValues is a field in TransactionState of type List<PieChartValues>
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
