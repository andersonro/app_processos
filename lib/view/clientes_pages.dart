import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_processos/controller/clientes_controller.dart';
import 'package:controle_processos/model/clientes_model.dart';
import 'package:controle_processos/ultis/functions_global.dart';
import 'package:controle_processos/view/widgets/clientes/cliente_widget.dart';
import 'package:controle_processos/view/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final ClientesController clientesController = ClientesController();
  ClientesModel clientesModel = ClientesModel();
  final formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _statusClientes = [
    {'id': " ", 'descricao': 'Selecione uma opção'},
    {'id': "A", 'descricao': 'Ativo'},
    {'id': "I", 'descricao': 'Inativo'},
  ];

  _salvar(ClientesModel? clientesModel) async {
    if (formKey.currentState?.validate() != null) {
      formKey.currentState?.save();
      debugPrint("clientesModel: $clientesModel");
      try {
        Navigator.of(context).pop(false);
        await clientesController.save(clientesModel!);
        if (mounted) {
          scaffoldMessenger(
            context: context,
            message: "Registro salvo com sucesso!!",
            color: Colors.green,
          );
        }
      } catch (e) {
        debugPrint("ERRO PAGE");
        if (mounted) {
          scaffoldMessenger(context: context, message: "$e");
        }
      }
    }
  }

  _delete({required ClientesModel clientesModel}) async {
    try {
      await clientesController.delete(clientesModel);
      if (mounted) {
        scaffoldMessenger(
          context: context,
          message: "Registro deletado com sucesso!!",
          color: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger(context: context, message: "$e");
      }
    }
  }

  _form({required ClientesModel clientesModel, double sizeModal = 0.5}) {
    showDialog(
      context: context,
      builder: (BuildContext showDialogContext) => SizedBox(
        width: MediaQuery.of(context).size.width * sizeModal,
        child: AlertDialog(
          scrollable: true,
          content: Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * sizeModal,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Nome',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),

                          initialValue: clientesModel.nome,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo nome é obrigatório!';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              clientesModel.nome = newValue;
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'E-mail',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          initialValue: clientesModel.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo e-mail é obrigatório!';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              clientesModel.email = newValue;
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Telefone',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.phone),
                                ),
                                initialValue: clientesModel.telefone != null
                                    ? clientesModel.telefone.toString()
                                    : "",
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TelefoneInputFormatter(),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'O campo valor é obrigatório!';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    clientesModel.telefone =
                                        int.tryParse(
                                          UtilBrasilFields.removeCaracteres(
                                            newValue,
                                          ),
                                        ) ??
                                        0;
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: clientesModel.status,
                                decoration: InputDecoration(
                                  labelText: 'Selecione',
                                  hint: Text("Selecione"),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return _statusClientes.map((
                                    Map<String, dynamic> item,
                                  ) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        item['descricao'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList();
                                },
                                items: _statusClientes.map((
                                  Map<String, dynamic> item,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: item['id'],
                                    child: Text(
                                      item['descricao'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {},
                                onSaved: (newValue) =>
                                    clientesModel.status = newValue,
                                validator: (String? value) {
                                  if (value == null) {
                                    return 'Por favor, selecione uma opção.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _salvar(clientesModel);
                            },
                            child: Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _load() async {
    await clientesController.load();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    SizeScreen sizeScreen = getSizeScreen(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
    double widthMenuScreen = getSizeMenuDesktop(sizeScreen: sizeScreen);

    double sizeModal = 0.5;
    if (sizeScreen == SizeScreen.mobile || sizeScreen == SizeScreen.tablet) {
      sizeModal = 1;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Clientes")),
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Obx(
                    () =>
                        clientesController.getState.value ==
                            ClientesState.loading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _form(
                                        clientesModel: clientesModel,
                                        sizeModal: sizeModal,
                                      ),
                                      label: Text("Novo"),
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(height: 1),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        ClientesModel cliente =
                                            clientesController.getLista[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClientesWidget(
                                            clientesModel: cliente,
                                            fnEdit: () {
                                              _form(clientesModel: cliente);
                                            },
                                            fnDelete: () {
                                              _delete(clientesModel: cliente);
                                            },
                                          ),
                                        );
                                      },
                                  itemCount: clientesController.getLista.length,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
