import 'package:equatable/equatable.dart';
import 'package:money_expense/core/data/models/models.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

// State awal
class TransactionInitial extends TransactionState {}

// State loading
class TransactionLoading extends TransactionState {}

// State loaded
class TransactionLoaded extends TransactionState {
  final List<TransactionModel> todayTransactions;
  final List<TransactionModel> transactionsYesterday; // ubah nama
  final List<CategoryModel> categories;

  const TransactionLoaded({
    required this.todayTransactions,
    required this.transactionsYesterday,
    required this.categories,
  });

  @override
  List<Object?> get props => [todayTransactions, transactionsYesterday, categories];
}

// State error
class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
