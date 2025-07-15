import 'package:controle_processos/routes/app_routes.dart';
import 'package:controle_processos/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  // A prioridade pode ser usada se você tiver múltiplos middlewares.
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authService = Get.find<AuthService>();
    return authService.isLoggedIn.value
        ? null
        : RouteSettings(name: AppRoutes.login);
  }
}
