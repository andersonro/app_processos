import 'package:controle_processos/repositories/user_shared_preferences_repository.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  // Variável reativa para armazenar o estado de autenticação.
  final RxBool isLoggedIn = false.obs;

  // Este método será chamado quando o serviço for inicializado.
  Future<AuthService> init() async {
    // Verifica a preferência armazenada e atualiza a variável reativa.
    isLoggedIn.value = await UserSharedPreferencesRepository.isLogged();
    return this;
  }

  // Método para chamar no login bem-sucedido.
  void login() {
    isLoggedIn.value = true;
  }

  // Método para chamar no logout.
  Future<void> logout() async {
    await UserSharedPreferencesRepository().removeUserSharedPreferences();
    isLoggedIn.value = false;
  }
}
