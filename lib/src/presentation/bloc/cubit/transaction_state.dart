import 'package:app_gastos_grupo_61/src/domain/entities/transaction_with_category.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  final TransactionStatus status;
  final List<TransactionWithCategory> transactions;
  final String? errorMessage;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionWithCategory>? transactions,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}