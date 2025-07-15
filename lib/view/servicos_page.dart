import 'package:brasil_fields/brasil_fields.dart';
import 'package:controle_processos/controller/servicos_controller.dart';
import 'package:controle_processos/model/servicos_model.dart';
import 'package:controle_processos/ultis/functions_global.dart';
import 'package:controle_processos/view/widgets/menu_widget.dart';
import 'package:controle_processos/view/widgets/servicos/servico_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  late ServicosController servicosController = ServicosController();
  late ServicosModel servicosModel = ServicosModel();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loadServicos();
    super.initState();
  }

  _loadServicos() async {
    await servicosController.loadServicos();
  }

  final List<Map<String, dynamic>> _statusServico = [
    {'id': " ", 'descricao': 'Selecione uma opção'},
    {'id': "A", 'descricao': 'Ativo'},
    {'id': "I", 'descricao': 'Inativo'},
  ];

  _salvarServico(BuildContext myContext, ServicosModel? servicoModel) async {
    if (formKey.currentState?.validate() != null) {
      formKey.currentState?.save();

      try {
        Navigator.of(context).pop(false);
        await servicosController.saveServicos(servicoModel!);
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

  _deleteServico(ServicosModel? servicoModel) async {
    try {
      await servicosController.deleteServicos(servicoModel!);
      if (mounted) {
        scaffoldMessenger(
          context: context,
          message: "Registro deletado com sucesso!!",
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

  _formServico(ServicosModel servicoModel) {
    showDialog(
      context: context,
      builder: (BuildContext showDialogContext) => SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: AlertDialog(
          scrollable: true,
          content: Builder(
            builder: (context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
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
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),

                          initialValue: servicoModel.descricao,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'O campo descrição é obrigatório!';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            debugPrint("onSaved: $newValue");
                            if (newValue != null) {
                              servicoModel.descricao = newValue;
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
                                  hintText: 'Valor',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.attach_money_rounded),
                                ),
                                initialValue: servicoModel.valorFormatado,
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
                                    servicoModel.valor =
                                        UtilBrasilFields.converterMoedaParaDouble(
                                          newValue,
                                        );
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: servicoModel.status ?? null,
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
                                  return _statusServico.map((
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
                                items: _statusServico.map((
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
                                    servicoModel.status = newValue,
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
                              _salvarServico(showDialogContext, servicoModel);
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
  Widget build(BuildContext context) {
    double widthMenuScreen = getSizeMenuDesktop(
      sizeScreen: getSizeScreen(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Serviços")),
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
                        servicosController.getState.value ==
                            ServicosState.loading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton.icon(
                                      onPressed: () =>
                                          _formServico(servicosModel),
                                      label: Text("Novo Serviço"),
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
                                        ServicosModel servico =
                                            servicosController.getLista[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ServicoWidget(
                                            servicosModel: servico,
                                            fnEdit: () {
                                              _formServico(servico);
                                            },
                                            fnDelete: () {
                                              _deleteServico(servico);
                                            },
                                          ),
                                        );
                                      },
                                  itemCount: servicosController.getLista.length,
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
