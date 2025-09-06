import 'package:equatable/equatable.dart';
import 'package:money_expense/core/data/models/models.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class AddUser extends UserEvent {
  final UserModel user;

  const AddUser(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginUser extends UserEvent {
  final String email;
  final String password;

  const LoginUser(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}
