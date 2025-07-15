import 'dart:convert';
import 'package:controle_processos/model/status_model.dart';
import 'package:controle_processos/services/dio_custom.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:controle_processos/ultis/network_access.dart';
import 'package:dio/dio.dart';

class StatusRepository {
  final service = DioCustom();
  final NetworkAccess networkAccess = NetworkAccess();

  Future<List<StatusModel>> get() async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }

    List<StatusModel> arr = [];

    try {
      final endPoint = "/api/status";
      final response = await service.dio.get(endPoint);
      if (response.data['success'] == true) {
        arr = response.data['data']
            .map<StatusModel>((item) => StatusModel.fromJson(item))
            .toList();

        return arr;
      } else {
        throw CustomException(message: response.data['msg']);
      }
    } on DioException catch (dioErr) {
      try {
        Map<String, dynamic> json = jsonDecode(dioErr.response.toString());
        throw CustomException(message: json['msg'].toString());
      } catch (e) {
        throw CustomException(message: e.toString());
      }
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
