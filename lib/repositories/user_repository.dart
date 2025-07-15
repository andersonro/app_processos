import 'dart:convert';
import 'package:controle_processos/model/user_model.dart';
import 'package:controle_processos/repositories/user_shared_preferences_repository.dart';
import 'package:controle_processos/services/dio_custom.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:controle_processos/ultis/network_access.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class UserRepository {
  final service = DioCustom();
  final NetworkAccess networkAccess = NetworkAccess();

  final UserSharedPreferencesRepository userSharedPreferencesRepository =
      UserSharedPreferencesRepository();

  late UserModel userModel;

  Future<UserModel> login({
    required String email,
    required String senha,
  }) async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }

    try {
      final endPoint = "/api/login";
      final response = await service.dio.post(
        endPoint,
        data: {'email': email, 'senha': senha},
      );

      if (response.data['success'] == true) {
        userModel = UserModel.fromJson(response.data['data']);
        await userSharedPreferencesRepository.setUserSharedPreferences(
          userModel,
        );
        return userModel;
      } else {
        debugPrint("REPOSITORY LOGIN ERROR: ${response.toString()}");
        throw CustomException(message: response.data['msg']);
      }
    } on DioException catch (dioErr) {
      debugPrint("REPOSITORY ERROR 1: ${dioErr.toString()}");
      try {
        Map<String, dynamic> json = jsonDecode(dioErr.response.toString());
        throw CustomException(message: json['msg'].toString());
      } catch (e) {
        throw CustomException(message: e.toString());
      }
    } catch (e) {
      debugPrint("REPOSITORY ERROR 2: ${e.toString()}");
      throw CustomException(message: e.toString());
    }
  }
}
