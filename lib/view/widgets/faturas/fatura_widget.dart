import 'package:controle_processos/model/faturas_model.dart';
import 'package:flutter/material.dart';

class FaturaWidget extends StatelessWidget {
  final FaturasModel faturasModel;
  final Function? fnEdit;
  final Function? fnDelete;
  const FaturaWidget({
    super.key,
    required this.faturasModel,
    this.fnEdit,
    this.fnDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text("${faturasModel.descricao}")),
        Expanded(flex: 2, child: Text("${faturasModel.statusDescricao}")),
        Expanded(child: Text("${faturasModel.valorFormatado}")),
        Expanded(flex: 3, child: Text("${faturasModel.clienteNome}")),
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
