import 'package:controle_processos/model/status_model.dart';
import 'package:controle_processos/repositories/status_repository.dart';
import 'package:controle_processos/ultis/custom_exception.dart';
import 'package:get/get.dart';

class StatusController extends GetxController {
  final StatusRepository statusRepository = StatusRepository();

  final _state = StatusState.initial.obs;
  Rx<StatusState> get getState => _state.value.obs;
  set setState(StatusState state) => _state.value = state;

  final _lista = <StatusModel>[].obs;
  RxList<StatusModel> get getLista => _lista;

  Future load() async {
    setState = StatusState.loading;
    try {
      _lista.clear();
      _lista.value = await statusRepository.get();
      _lista.refresh();
      setState = StatusState.success;
    } catch (e) {
      setState = StatusState.error;
      throw CustomException(message: "$e");
    }
  }
}

enum StatusState { initial, loading, success, error }
