import 'package:controle_processos/model/user_model.dart';
import 'package:controle_processos/ultis/functions_global.dart';
import 'package:controle_processos/view/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthMenuScreen = getSizeMenuDesktop(
      sizeScreen: getSizeScreen(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Dashboard")),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              //MENU
              Container(
                width: MediaQuery.of(context).size.width * widthMenuScreen,
                height: MediaQuery.of(context).size.height,
                color: Colors.grey[200],
                child: MenuWidget(),
              ),
              //CONTENT
              Expanded(child: Container(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
