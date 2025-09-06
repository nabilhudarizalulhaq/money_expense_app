// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:money_expense/core/data/datasources/local_database.dart';
// import 'transaction_event.dart';
// import 'transaction_state.dart';

// part 'transaction_event.dart';
// part 'transaction_state.dart';
// part 'transaction_bloc.freezed.dart';

// class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
//   final AppDatabase db;

//   TransactionBloc({required this.db}) : super(const TransactionInitial()) {
//     on<LoadAllTransactions>((event, emit) async {
//       emit(const TransactionLoading());
//       try {
//         final transactions = await db.getAllTransactions();
//         emit(TransactionLoaded(transactions: transactions));
//       } catch (e) {
//         emit(TransactionError(message: e.toString()));
//       }
//     });

//     on<LoadTodayTransactions>((event, emit) async {
//       emit(const TransactionLoading());
//       try {
//         final transactions = await db.getTransactionsToday();
//         emit(TransactionLoaded(transactions: transactions));
//       } catch (e) {
//         emit(TransactionError(message: e.toString()));
//       }
//     });

//     on<AddTransaction>((event, emit) async {
//       emit(const TransactionLoading());
//       try {
//         await db.insertTransaction(
//           event.title,
//           event.amount,
//           event.categoryId,
//           event.date,
//         );
//         final transactions = await db.getAllTransactions();
//         emit(TransactionLoaded(transactions: transactions));
//       } catch (e) {
//         emit(TransactionError(message: e.toString()));
//       }
//     });
//   }
// }
