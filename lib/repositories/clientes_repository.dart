import 'dart:convert';
import 'package:controle_processos/model/clientes_model.dart';
import 'package:controle_processos/services/dio_custom.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:controle_processos/ultis/network_access.dart';
import 'package:dio/dio.dart';

class ClientesRepository {
  final service = DioCustom();
  final NetworkAccess networkAccess = NetworkAccess();

  Future<List<ClientesModel>> get() async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }

    List<ClientesModel> arr = [];

    try {
      final endPoint = "/api/clientes";
      final response = await service.dio.get(endPoint);
      if (response.data['success'] == true) {
        arr = response.data['data']
            .map<ClientesModel>((item) => ClientesModel.fromJson(item))
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

  Future<bool> save(ClientesModel clientesModel) async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }
    try {
      final endPoint = "/api/clientes";
      dynamic response;

      clientesModel.tipoPessoa = 'F';

      if (clientesModel.id != null) {
        response = await service.dio.put(
          endPoint,
          data: clientesModel.toJson(),
        );
      } else {
        response = await service.dio.post(
          endPoint,
          data: clientesModel.toJson(),
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

  Future<bool> delete(ClientesModel clientesModel) async {
    var isConnected = await networkAccess.checkNetworkAcess();
    if (!isConnected) {
      throw CustomException(message: "Você está sem conexão a internet!");
    }
    try {
      final endPoint = "/api/clientes/${clientesModel.id}";
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
