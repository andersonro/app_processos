import 'package:controle_processos/model/clientes_model.dart';
import 'package:controle_processos/repositories/clientes_repository.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:get/get.dart';

class ClientesController extends GetxController {
  final ClientesRepository clientesRepository = ClientesRepository();

  final _state = ClientesState.initial.obs;
  Rx<ClientesState> get getState => _state.value.obs;
  set setState(ClientesState state) => _state.value = state;

  final _lista = <ClientesModel>[].obs;
  RxList<ClientesModel> get getLista => _lista;

  Future load() async {
    setState = ClientesState.loading;
    try {
      _lista.clear();
      _lista.value = await clientesRepository.get();
      _lista.refresh();
      setState = ClientesState.success;
    } catch (e) {
      setState = ClientesState.error;
      throw CustomException(message: "$e");
    }
  }

  Future<bool> save(ClientesModel clientesModel) async {
    try {
      setState = ClientesState.loading;
      bool fg = await clientesRepository.save(clientesModel);
      await load();
      //setState = ClientesState.success;
      return fg;
    } catch (e) {
      setState = ClientesState.success;
      throw CustomException(message: "$e");
    }
  }

  Future<bool> delete(ClientesModel clientesModel) async {
    try {
      setState = ClientesState.loading;
      bool fg = await clientesRepository.delete(clientesModel);
      await load();
      setState = ClientesState.success;
      return fg;
    } catch (e) {
      throw CustomException(message: "$e");
    }
  }
}

enum ClientesState { initial, loading, success, error }
