import 'package:app_gastos_grupo_61/core/helpers/classes.dart';

import 'package:app_gastos_grupo_61/src/domain/usecases/delete_transaction_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/delete_transactions_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/get_transactions_by_budget_id_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/insert_transaction_usecase.dart';
import 'package:app_gastos_grupo_61/src/domain/usecases/update_transaction_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_gastos_grupo_61/src/domain/entities/transaction.dart';

import 'transaction_state.dart'; // Assuming your state file is named this

enum TransactionType { income, expense }

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit(
    this._getTransactionsByBudgetIdUsecase,
    this._insertTransactionUseCase,
    this._updateTransactionUseCase,
    this._deleteTransactionUsecase,
    this._deleteTransactionsUsecase,
  ) : super(const TransactionState());

  final GetTransactionsByBudgetIdUsecase _getTransactionsByBudgetIdUsecase;
  final InsertTransactionUseCase _insertTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUsecase _deleteTransactionUsecase;
  final DeleteTransactionsUsecase _deleteTransactionsUsecase;

  Future<void> loadTransactionsByBudgetId(int budgetId) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final transactionsResult = await _getTransactionsByBudgetIdUsecase(
        budgetId,
      );

      transactionsResult.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (transactions) {
          Map<String, double> expenseCategorySpend = {};
          Map<String, double> incomeCategorySpend = {};

          for (final transaction in transactions) {
            final categoryName = transaction.categoryName;
            final amount = transaction.amount; // Get the transaction amount

            if (!transaction.isIncome) {
              // Sum the amounts for each expense category
              expenseCategorySpend.update(
                categoryName,
                (value) => value + amount,
                ifAbsent: () => amount,
              );
            } else {
              // Sum the amounts for each income category
              incomeCategorySpend.update(
                categoryName,
                (value) => value + amount,
                ifAbsent: () => amount,
              );
            }
          }

          // Convert the expense map to a List of PieChartValues objects
          final List<PieChartValue> expensesPieChartValues =
              expenseCategorySpend.entries.map((entry) {
                // Pass the category name (key) and the total spend (value)
                return PieChartValue(
                  entry.key,
                  entry.value.toInt(),
                ); // Convert double spend to int if PieChartValue.spend is int
              }).toList();

          // Convert the income map to a List of PieChartValues objects
          final List<PieChartValue> incomesPieChartValues =
              incomeCategorySpend.entries.map((entry) {
                // Pass the category name (key) and the total spend (value)
                return PieChartValue(
                  entry.key,
                  entry.value.toInt(),
                ); // Convert double spend to int if PieChartValue.spend is int
              }).toList();

          emit(
            state.copyWith(
              status: TransactionStatus.loaded,
              transactions: transactions,
              expensesPieChartValues: expensesPieChartValues,
              incomesPieChartValues: incomesPieChartValues,
            ),
          );
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

  Future<void> insertTransaction(Transaction transaction) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _insertTransactionUseCase(transaction);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful insertion, reload transactions for the current budget
          loadTransactionsByBudgetId(transaction.budgetId);
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

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _updateTransactionUseCase(transaction);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful update, reload transactions for the current budget
          loadTransactionsByBudgetId(transaction.budgetId);
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

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _deleteTransactionUsecase(transaction);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful deletion, reload transactions for the current budget
          loadTransactionsByBudgetId(transaction.budgetId);
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

  Future<void> deleteTransactions(List<Transaction> transactions) async {
    try {
      emit(state.copyWith(status: TransactionStatus.loading));
      final result = await _deleteTransactionsUsecase(transactions);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: TransactionStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) {
          // On successful deletion, reload transactions for the current budget
          // and also reload budgets to update the balance.
          // Assuming all transactions in the list belong to the same budget.
          if (transactions.isNotEmpty) {
            loadTransactionsByBudgetId(transactions.first.budgetId);
          }
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
}
