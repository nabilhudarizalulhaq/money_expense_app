import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_expense/persentation/home/bloc/transaction/transaction_event.dart';
import 'transaction_state.dart';
import 'package:money_expense/core/data/repositories/transaction_repository.dart';
import 'package:money_expense/core/data/repositories/catagory_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepo;
  final CategoryRepository categoryRepo;

  TransactionBloc({required this.transactionRepo, required this.categoryRepo})
    : super(TransactionInitial()) {
    // <- ini harus ada
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());

      try {
        final todayTransactions = await transactionRepo.getTransactionsToday();
        final yesterdayTransactions = await transactionRepo
            .getTransactionsYesterday();
        final categories = await categoryRepo.getAllCategories();

        emit(
          TransactionLoaded(
            todayTransactions: todayTransactions,
            transactionsYesterday: yesterdayTransactions,
            categories: categories,
          ),
        );
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}
