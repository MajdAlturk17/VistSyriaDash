import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitsyriadashboard/Core/Bloc/bloc/login_bloc_event.dart';
import 'package:visitsyriadashboard/Core/Bloc/bloc/login_bloc_state.dart';
import 'package:visitsyriadashboard/Core/Service/LoginService.dart';

import '../../../Core/Storage/token_storage.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService loginService;

  LoginBloc(this.loginService) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final response = await loginService.login(
        email: event.email,
        password: event.password,
      );

      // Extract access token
      final token = response["data"]?["accessToken"];
      if (token != null) {
        await TokenStorage.saveToken(token);
      }

      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
