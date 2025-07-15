import 'package:controle_processos/repositories/user_repository.dart';
import 'package:controle_processos/services/auth_service.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository userRepository = UserRepository();

  final _state = UserState.initial.obs;
  Rx<UserState> get getState => _state.value.obs;
  set setState(UserState state) => _state.value = state;

  Future login({required String email, required String senha}) async {
    setState = UserState.loading;
    try {
      await userRepository.login(email: email, senha: senha);
      Get.find<AuthService>().login();
      setState = UserState.success;
    } catch (e) {
      debugPrint('LOGIN CONTROLLER: ${e.toString()}');
      setState = UserState.error;
      throw CustomException(message: "$e");
    }
  }
}

enum UserState { initial, loading, success, error }
