import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_processos/model/clientes_model.dart';
import 'package:flutter/material.dart';

class ClientesWidget extends StatelessWidget {
  final ClientesModel clientesModel;
  final Function? fnEdit;
  final Function? fnDelete;
  const ClientesWidget({
    super.key,
    required this.clientesModel,
    this.fnEdit,
    this.fnDelete,
  });

  @override
  Widget build(BuildContext context) {
    String dsStatus = clientesModel.status == 'A' ? 'Ativo' : 'Inativo';
    Color corStatus = clientesModel.status == 'A' ? Colors.green : Colors.red;
    return Row(
      children: [
        Expanded(flex: 4, child: Text("${clientesModel.nome}")),
        Expanded(
          child: Text(
            clientesModel.telefone != null
                ? UtilBrasilFields.obterTelefone(
                    clientesModel.telefone.toString().padLeft(11, '0'),
                    ddd: true,
                  )
                : "",
          ),
        ),
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
