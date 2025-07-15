import 'package:flutter/material.dart';

String removerAcentuacoes(String texto) {
  if (texto.isEmpty) {
    return texto;
  }

  // Mapeamento de caracteres acentuados para suas versões sem acento
  String comAcentos = "áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ";
  String semAcentos = "aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC";

  // Cria um RegExp para buscar todos os caracteres acentuados de uma vez
  // O '[${RegExp.escape(comAcentos)}]' cria uma classe de caracteres a partir da string comAcentos
  RegExp exp = RegExp('[${RegExp.escape(comAcentos)}]');

  // Usa replaceAllMapped para substituir cada caractere encontrado
  String textoSemAcentos = texto.replaceAllMapped(exp, (match) {
    // Encontra o índice do caractere acentuado na string comAcentos
    int index = comAcentos.indexOf(match.group(0)!);
    // Retorna o caractere correspondente da string semAcentos
    return (index != -1) ? semAcentos[index] : match.group(0)!;
  });

  return textoSemAcentos;
}

void scaffoldMessenger({
  required BuildContext context,
  required String message,
  Color color = Colors.red,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(child: Text(message)),
      backgroundColor: color,
    ),
  );
}

void navigator({required BuildContext context, required Widget w}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => w),
  );
}

enum SizeScreen { mobile, tablet, desktop, large }

extension SizeScreenExtension on SizeScreen {
  Map<String, dynamic> get toValue {
    switch (this) {
      case SizeScreen.mobile:
        return {'width': 0, 'height': 600};
      case SizeScreen.tablet:
        return {'width': 601, 'height': 800};
      case SizeScreen.desktop:
        return {'width': 801, 'height': 1200};
      case SizeScreen.large:
        return {'width': 1201, 'height': 10000};
    }
  }
}

SizeScreen getSizeScreen({required width, required height}) {
  if (width <= 600) {
    return SizeScreen.mobile;
  } else if (width > 600 && width <= 800) {
    return SizeScreen.tablet;
  } else if (width > 800 && width <= 1200) {
    return SizeScreen.desktop;
  }
  return SizeScreen.large;
}

double getSizeMenuDesktop({required SizeScreen sizeScreen}) {
  switch (sizeScreen) {
    case SizeScreen.mobile:
      return 0;
    case SizeScreen.tablet:
      return 0.3;
    case SizeScreen.desktop:
      return 0.2;
    case SizeScreen.large:
      return 0.2;
  }
}

double getSizeContentDesktop({required SizeScreen sizeScreen}) {
  switch (sizeScreen) {
    case SizeScreen.mobile:
      return 100;
    case SizeScreen.tablet:
      return 0.7;
    case SizeScreen.desktop:
      return 0.8;
    case SizeScreen.large:
      return 0.8;
  }
}
