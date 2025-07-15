import 'package:controle_processos/model/faturas_model.dart';
import 'package:controle_processos/repositories/faturas_repository.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:get/get.dart';

class FaturasController extends GetxController {
  final FaturasRepository faturasRepository = FaturasRepository();

  final _state = FaturasState.initial.obs;
  Rx<FaturasState> get getState => _state.value.obs;
  set setState(FaturasState state) => _state.value = state;

  final _lista = <FaturasModel>[].obs;
  RxList<FaturasModel> get getLista => _lista;

  Future load() async {
    setState = FaturasState.loading;
    try {
      _lista.clear();
      _lista.value = await faturasRepository.get();
      _lista.refresh();
      setState = FaturasState.success;
    } catch (e) {
      setState = FaturasState.error;
      throw CustomException(message: "$e");
    }
  }

  Future<bool> save(FaturasModel faturasModel) async {
    try {
      setState = FaturasState.loading;
      bool fg = await faturasRepository.save(faturasModel);
      await load();
      //setState = ClientesState.success;
      return fg;
    } catch (e) {
      setState = FaturasState.success;
      throw CustomException(message: "$e");
    }
  }

  Future<bool> delete(FaturasModel faturasModel) async {
    try {
      setState = FaturasState.loading;
      bool fg = await faturasRepository.delete(faturasModel);
      await load();
      setState = FaturasState.success;
      return fg;
    } catch (e) {
      throw CustomException(message: "$e");
    }
  }
}

enum FaturasState { initial, loading, success, error }
