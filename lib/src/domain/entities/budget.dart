import 'package:equatable/equatable.dart';

//Nombre en inglés y en singular
class Budget extends Equatable {
  const Budget({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  //Las propiedades
  final int? id;
  final String description;
  final double amount;
  final DateTime date;

  //Este override se debe a que se está usando Equatable
  //Que permite comparar fácilmente dos instancias de una clase
  @override
  List<Object?> get props => [id, description, amount, date];
}
