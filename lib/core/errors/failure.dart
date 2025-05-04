import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class ServerException extends Failure {
  const ServerException({required super.message, required super.statusCode});
}

class ValidationError extends Failure {
  const ValidationError({required super.message, required super.statusCode});
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({
    required super.message,
    required super.statusCode,
  });
}

class NotFound extends LocalDatabaseFailure {
  const NotFound() : super(message: 'Not found', statusCode: 404);
}
