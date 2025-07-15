import 'package:controle_processos/controller/user_controller.dart';
import 'package:controle_processos/repositories/user_shared_preferences_repository.dart';
import 'package:controle_processos/routes/app_routes.dart';
import 'package:controle_processos/ultis/functions_global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKeyLogin = GlobalKey<FormState>();
  var userEmailController = TextEditingController();
  var userSenhaController = TextEditingController();
  final UserController userController = UserController();

  @override
  void initState() {
    super.initState();
  }

  void _login() async {
    if (formKeyLogin.currentState?.validate() != null &&
        userEmailController.text.isNotEmpty &&
        userSenhaController.text.isNotEmpty) {
      formKeyLogin.currentState?.save();

      try {
        await userController.login(
          email: userEmailController.text,
          senha: userSenhaController.text,
        );
        await UserSharedPreferencesRepository.isLogged();
        await Get.offAllNamed(AppRoutes.dashboard);
      } catch (e) {
        if (mounted) {
          scaffoldMessenger(
            context: context,
            message: e.toString(),
            color: Colors.red,
          );
        }
      }
    } else {
      scaffoldMessenger(
        context: context,
        message: "Você deve preencher os campos E-mail e Senha!",
        color: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    double widthCard = 0.6;
    double heightCard = 0.3;

    if (widthScreen <= 600) {
      widthCard = 0.7;
      heightCard = 0.4;
    } else if (widthScreen > 600 && widthScreen <= 800) {
      widthCard = 0.6;
      heightCard = 0.4;
    } else if (widthScreen > 800 && widthScreen <= 1200) {
      widthCard = 0.5;
      heightCard = 0.4;
    } else if (widthScreen > 1200) {
      widthCard = 0.4;
      heightCard = 0.4;
    }

    debugPrint("widthScreen: ${widthScreen.toString()}");
    debugPrint("heightScreen: ${heightScreen.toString()}");

    //debugPrint("Android: ${Platform.isAndroid.toString()}");
    debugPrint("WEB: ${kIsWeb.toString()}");

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * widthCard,
                height: MediaQuery.of(context).size.height * heightCard,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: formKeyLogin,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: userEmailController,
                            decoration: const InputDecoration(
                              hintText: 'E-mail',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo e-mail é obrigatório!';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != null) {
                                userEmailController.text = newValue;
                              }
                            },
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: userSenhaController,
                            decoration: const InputDecoration(
                              hintText: 'Senha',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.password_outlined),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O campo senha é obrigatório!';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (newValue != null) {
                                userSenhaController.text = newValue;
                              }
                            },
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () async {
                                _login();
                              },
                              child: Text('Acessar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Obx(
              () => userController.getState.value == UserState.loading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black45,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
