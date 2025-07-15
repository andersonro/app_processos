import 'package:controle_processos/middleware/auth_middleware.dart';
import 'package:controle_processos/view/clientes_pages.dart';
import 'package:controle_processos/view/dashboard_page.dart';
import 'package:controle_processos/view/faturas_page.dart';
import 'package:controle_processos/view/login_page.dart';
import 'package:controle_processos/view/servicos_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String servicos = '/servicos';
  static const String clientes = '/clientes';
  static const String faturas = '/faturas';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      title: "Login",
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      // Aqui aplicamos o middleware!
      middlewares: [AuthMiddleware()],
      title: "Dashboard",
    ),
    GetPage(
      name: AppRoutes.servicos,
      page: () => const ServicosPage(),
      middlewares: [AuthMiddleware()],
      title: "Serviços",
    ),
    GetPage(
      name: AppRoutes.clientes,
      page: () => const ClientesPage(),
      middlewares: [AuthMiddleware()],
      title: "Clientes",
    ),
    GetPage(
      name: AppRoutes.faturas,
      page: () => const FaturasPage(),
      middlewares: [AuthMiddleware()],
      title: "Faturas",
    ),
  ];
}

class AppPagesMenu {
  static final pages = AppPages.pages
      .where((e) => e.name != AppRoutes.login)
      .toList();
}
