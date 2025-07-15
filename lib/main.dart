import 'package:controle_processos/app.dart';
import 'package:controle_processos/routes/app_routes.dart';
import 'package:controle_processos/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Garante que os bindings do Flutter foram inicializados
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AuthService().init());
  // Verifica se o usuário já está logado para definir a rota inicial
  final authService = Get.find<AuthService>();
  final String initialRoute = authService.isLoggedIn.value
      ? AppRoutes.dashboard
      : AppRoutes.login;

  runApp(App(initialRoute: initialRoute));
}
