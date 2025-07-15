import 'package:controle_processos/routes/app_routes.dart';
import 'package:controle_processos/ultis/functions_global.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppPagesMenu.pages.length,
      itemBuilder: (BuildContext context, int index) {
        var appPages = AppPagesMenu.pages[index];
        return ListTile(
          title: Text("${appPages.title}"),
          onTap: () {
            navigator(context: context, w: appPages.page());
          },
        );
      },
    );
  }
}
