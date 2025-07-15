import 'dart:convert';
import 'package:controle_processos/model/servicos_model.dart';
import 'package:controle_processos/services/dio_custom.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:controle_processos/ultis/network_access.dart';
import 'package:dio/dio.dart';

class ServicosRepository {
  final service = DioCustom();
  final NetworkAccess networkAccess = NetworkAccess();

  Future<List<ServicosModel>> getServicos() async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }

    List<ServicosModel> servicos = [];

    try {
      final endPoint = "/api/servicos";
      final response = await service.dio.get(endPoint);
      if (response.data['success'] == true) {
        servicos = response.data['data']
            .map<ServicosModel>((item) => ServicosModel.fromJson(item))
            .toList();

        return servicos;
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

  Future<bool> saveServicos(ServicosModel servicosModel) async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }
    try {
      final endPoint = "/api/servicos";
      dynamic response;

      if (servicosModel.id != null) {
        response = await service.dio.put(
          endPoint,
          data: servicosModel.toJson(),
        );
      } else {
        response = await service.dio.post(
          endPoint,
          data: servicosModel.toJson(),
        );
      }

      if (response.data['success'] == true) {
        return true;
      } else {
        throw CustomException(message: response.data['msg']);
      }
    } on DioException catch (dioErr) {
      try {
        Map<String, dynamic> json = jsonDecode(dioErr.response.toString());
        throw CustomException(message: json['msg']);
      } catch (e) {
        throw CustomException(message: e.toString());
      }
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  Future<bool> deleteServicos(ServicosModel servicosModel) async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }
    try {
      final endPoint = "/api/servicos/${servicosModel.id}";
      dynamic response = await service.dio.delete(endPoint);

      if (response.data['success'] == true) {
        return true;
      } else {
        throw CustomException(message: response.data['msg']);
      }
    } on DioException catch (dioErr) {
      try {
        Map<String, dynamic> json = jsonDecode(dioErr.response.toString());
        throw CustomException(message: json['msg']);
      } catch (e) {
        throw CustomException(message: e.toString());
      }
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
