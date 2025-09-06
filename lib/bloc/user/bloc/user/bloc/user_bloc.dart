import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_expense/core/data/repositories/user_repository.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc(this.repository) : super(UserInitial()) {
    // ---------------- Add User ----------------
    on<AddUser>((event, emit) async {
      emit(UserLoading());
      try {
        final id = await repository.insertUser(event.user);
        final user = event.user.copyWith(id: id);
        emit(UserSuccess(user));
      } catch (e) {
        emit(UserError("Gagal menambahkan user: $e"));
      }
    });

    // ---------------- Login User ----------------
    on<LoginUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await repository.login(event.email, event.password);
        if (user != null) {
          emit(UserSuccess(user));
        } else {
          emit(const UserError("Email atau password salah"));
        }
      } catch (e) {
        emit(UserError("Gagal login: $e"));
      }
    });
  }
}
