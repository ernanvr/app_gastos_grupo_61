import 'package:equatable/equatable.dart';

// Nombre en inglés y en singular
class Transaction extends Equatable {
  const Transaction({
    this.id,
    required this.typeOfTransactionId,
    required this.categoryId,
    required this.description,
    required this.amount,
    required this.date,
  });

  // Propiedades
  final int? id;
  final int typeOfTransactionId;
  final int categoryId;
  final String description;
  final double amount;
  final DateTime date;

  // Equatable override para comparación
  @override
  List<Object?> get props => [
        id,
        typeOfTransactionId,
        categoryId,
        description,
        amount,
        date,
      ];
}
