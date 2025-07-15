import 'package:controle_processos/model/servicos_model.dart';
import 'package:flutter/material.dart';

class ServicoWidget extends StatelessWidget {
  final ServicosModel servicosModel;
  final Function? fnEdit;
  final Function? fnDelete;
  const ServicoWidget({
    super.key,
    required this.servicosModel,
    this.fnEdit,
    this.fnDelete,
  });

  @override
  Widget build(BuildContext context) {
    String dsStatus = servicosModel.status == 'A' ? 'Ativo' : 'Inativo';
    Color corStatus = servicosModel.status == 'A' ? Colors.green : Colors.red;
    return Row(
      children: [
        Expanded(flex: 4, child: Text("${servicosModel.descricao}")),
        Expanded(child: Text("${servicosModel.valorFormatado}")),
        Container(
          width: 60,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: corStatus,
          ),
          child: Text(
            dsStatus,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => fnEdit!(),
              icon: Icon(Icons.edit_document),
            ),
            IconButton(
              onPressed: () => fnDelete!(),
              icon: Icon(Icons.delete_outline_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
