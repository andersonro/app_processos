import 'package:controle_processos/model/servicos_model.dart';
import 'package:controle_processos/repositories/servicos_repository.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:get/get.dart';

class ServicosController extends GetxController {
  final ServicosRepository servicosRepository = ServicosRepository();

  final _state = ServicosState.initial.obs;
  Rx<ServicosState> get getState => _state.value.obs;
  set setState(ServicosState state) => _state.value = state;

  final _lista = <ServicosModel>[].obs;
  RxList<ServicosModel> get getLista => _lista;

  Future loadServicos() async {
    setState = ServicosState.loading;
    try {
      _lista.clear();
      _lista.value = await servicosRepository.getServicos();
      _lista.refresh();
      setState = ServicosState.success;
    } catch (e) {
      setState = ServicosState.error;
      throw CustomException(message: "$e");
    }
  }

  Future<bool> saveServicos(ServicosModel servicosModel) async {
    try {
      setState = ServicosState.loading;
      bool fg = await servicosRepository.saveServicos(servicosModel);
      await loadServicos();
      setState = ServicosState.success;
      return fg;
    } catch (e) {
      throw CustomException(message: "$e");
    }
  }

  Future<bool> deleteServicos(ServicosModel servicosModel) async {
    try {
      setState = ServicosState.loading;
      bool fg = await servicosRepository.deleteServicos(servicosModel);
      await loadServicos();
      setState = ServicosState.success;
      return fg;
    } catch (e) {
      throw CustomException(message: "$e");
    }
  }
}

enum ServicosState { initial, loading, success, error }
