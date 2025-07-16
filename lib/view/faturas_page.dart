import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_processos/controller/clientes_controller.dart';
import 'package:controle_processos/controller/faturas_controller.dart';
import 'package:controle_processos/controller/servicos_controller.dart';
import 'package:controle_processos/controller/status_controller.dart';
import 'package:controle_processos/model/clientes_model.dart';
import 'package:controle_processos/model/faturas_model.dart';
import 'package:controle_processos/model/servicos_model.dart';
import 'package:controle_processos/model/status_model.dart';
import 'package:controle_processos/ultis/functions_global.dart';
import 'package:controle_processos/view/widgets/faturas/fatura_widget.dart';
import 'package:controle_processos/view/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FaturasPage extends StatefulWidget {
  const FaturasPage({super.key});

  @override
  State<FaturasPage> createState() => _FaturasPageState();
}

class _FaturasPageState extends State<FaturasPage> {
  final FaturasController faturasController = FaturasController();
  FaturasModel faturasModel = FaturasModel();
  final formKey = GlobalKey<FormState>();
  ClientesController clientesController = ClientesController();
  List<ClientesModel> _arrClientes = [];
  StatusController statusController = StatusController();
  List<StatusModel> _arrStatus = [];
  ServicosController servicosController = ServicosController();
  List<ServicosModel> _arrServicos = [];

  _loadClientes() async {
    await clientesController.load();
    _arrClientes = clientesController.getLista;
  }

  _loadServicos() async {
    await servicosController.loadServicos();
    _arrServicos = servicosController.getLista;
  }

  _loadStatus() async {
    await statusController.load();
    _arrStatus = statusController.getLista;
  }

  _salvar(FaturasModel? faturasModel) async {
    debugPrint("SALVAR ${faturasModel?.descricao}");
    if (formKey.currentState?.validate() != null) {
      formKey.currentState?.save();

      try {
        Navigator.of(context).pop(false);
        await faturasController.save(faturasModel!);
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

  _delete({required FaturasModel faturasModel}) async {
    try {
      await faturasController.delete(faturasModel);
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

  _form({required FaturasModel faturasModel, double sizeModal = 0.5}) async {
    if (_arrClientes.isEmpty) {
      await _loadClientes();
    }
    if (_arrServicos.isEmpty) {
      await _loadServicos();
    }
    if (_arrStatus.isEmpty) {
      await _loadStatus();
    }

    ClientesModel? clienteModelSelecionado;
    if (faturasModel.idClientes != null && _arrClientes.isNotEmpty) {
      try {
        clienteModelSelecionado = _arrClientes.firstWhere(
          (element) => element.id == faturasModel.idClientes,
        );
      } catch (e) {
        clienteModelSelecionado = null;
      }
    }

    ServicosModel? servicosModelSelecionado;
    if (faturasModel.idServicos != null && _arrServicos.isNotEmpty) {
      try {
        servicosModelSelecionado = _arrServicos.firstWhere(
          (element) => element.id == faturasModel.idServicos,
        );
      } catch (e) {
        servicosModelSelecionado = null;
      }
    }

    StatusModel? statusModelSelecionado;
    if (faturasModel.idStatus != null && _arrStatus.isNotEmpty) {
      try {
        statusModelSelecionado = _arrStatus.firstWhere(
          (element) => element.id == faturasModel.idStatus,
        );
      } catch (e) {
        statusModelSelecionado = null;
      }
    }

    setState(() {});

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
                            hintText: 'Descrição',
                            labelText: "Descrição",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.paste_outlined),
                          ),
                          initialValue: faturasModel.descricao,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo nome é obrigatório!';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              faturasModel.descricao = newValue;
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<ClientesModel>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Clientes',
                            hint: Text("Selecione"),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          value: clienteModelSelecionado?.id != null
                              ? clienteModelSelecionado
                              : null,
                          selectedItemBuilder: (BuildContext context) {
                            return _arrClientes.map((ClientesModel cliente) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  cliente.nome ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList();
                          },
                          onChanged: (ClientesModel? clienteModel) {
                            if (clienteModel != null) {
                              faturasModel.idClientes = clienteModel.id;
                            }
                          },
                          items: _arrClientes.map((ClientesModel cliente) {
                            return DropdownMenuItem<ClientesModel>(
                              value: cliente,
                              child: Text(
                                cliente.nome!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onSaved: (newValue) {
                            if (newValue != null) {
                              faturasModel.idClientes = newValue.id;
                            }
                          },
                          validator: (ClientesModel? value) {
                            if (value == null) {
                              return 'Por favor, selecione uma opção.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<ServicosModel>(
                                isExpanded: true,
                                //value: clientesModel.status,
                                decoration: InputDecoration(
                                  labelText: 'Serviços',
                                  hint: Text("Selecione"),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return _arrServicos.map((
                                    ServicosModel servico,
                                  ) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        servico.descricao!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList();
                                },
                                value: servicosModelSelecionado?.id != null
                                    ? servicosModelSelecionado
                                    : null,
                                items: _arrServicos.map((
                                  ServicosModel servico,
                                ) {
                                  return DropdownMenuItem<ServicosModel>(
                                    value: servico,
                                    child: Text(
                                      servico.descricao!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (ServicosModel? newValue) {
                                  if (newValue != null) {
                                    faturasModel.idServicos = newValue.id;
                                  }
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    faturasModel.idServicos = newValue.id;
                                  }
                                },
                                validator: (ServicosModel? value) {
                                  if (value == null) {
                                    return 'Por favor, selecione uma opção.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Valor',
                                  labelText: "Valor",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.monetization_on_outlined,
                                  ),
                                ),
                                initialValue: faturasModel.valorFormatado,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CentavosInputFormatter(casasDecimais: 2),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'O campo valor é obrigatório!';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    faturasModel.valor =
                                        UtilBrasilFields.converterMoedaParaDouble(
                                          newValue,
                                        );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<StatusModel>(
                          isExpanded: true,
                          //value: clientesModel.status,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            hint: Text("Selecione"),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return _arrStatus.map((StatusModel status) {
                              return Align(
                                alignment: AlignmentGeometry.centerLeft,
                                child: Text(
                                  status.descricao!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList();
                          },
                          value: statusModelSelecionado?.id != null
                              ? statusModelSelecionado
                              : null,
                          items: _arrStatus.map((StatusModel status) {
                            return DropdownMenuItem<StatusModel>(
                              value: status,
                              child: Text(
                                status.descricao!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (StatusModel? newValue) {
                            if (newValue != null) {
                              faturasModel.idStatus = newValue.id;
                            }
                          },
                          onSaved: (StatusModel? newValue) {
                            if (newValue != null) {
                              faturasModel.idStatus = newValue.id;
                            }
                          },
                          validator: (StatusModel? value) {
                            if (value == null) {
                              return 'Por favor, selecione uma opção.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 8),
                        TextFormField(
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Observações',
                            labelText: 'Observações',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description_outlined),
                          ),
                          //initialValue: clientesModel.email,
                          validator: (value) {
                            return null;
                          },
                          onSaved: (newValue) {
                            if (newValue != null) {
                              //clientesModel.email = newValue;
                            }
                          },
                        ),

                        SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _salvar(faturasModel);
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

  @override
  void initState() {
    super.initState();
    _load();
    _loadClientes();
    _loadServicos();
    _loadStatus();
  }

  _load() async {
    await faturasController.load();
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
        appBar: AppBar(title: Text("Faturas")),
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
                        faturasController.getState.value == FaturasState.loading
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
                                        faturasModel: faturasModel,
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
                                        FaturasModel fatura =
                                            faturasController.getLista[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FaturaWidget(
                                            faturasModel: fatura,
                                            fnEdit: () {
                                              _form(faturasModel: fatura);
                                            },
                                            fnDelete: () {
                                              _delete(faturasModel: fatura);
                                            },
                                          ),
                                        );
                                      },
                                  itemCount: faturasController.getLista.length,
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
