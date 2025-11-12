import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;
  LoginSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
