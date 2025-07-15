class FaturasModel {
  int? id;
  String? fatura;
  String? descricao;
  double? valor;
  String? dhCadastro;
  String? dhPago;
  int? idStatus;
  int? idClientes;
  int? idServicos;
  int? idUsuarios;
  String? observacao;
  String? clienteNome;
  String? clienteCpfCnpj;
  String? statusDescricao;
  String? valorFormatado;
  String? dhCadastroFormatada;

  FaturasModel({
    this.id,
    this.fatura,
    this.descricao,
    this.valor,
    this.dhCadastro,
    this.dhPago,
    this.idStatus,
    this.idClientes,
    this.idServicos,
    this.idUsuarios,
    this.observacao,
    this.clienteNome,
    this.clienteCpfCnpj,
    this.statusDescricao,
    this.valorFormatado,
    this.dhCadastroFormatada,
  });

  FaturasModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fatura = json['fatura'];
    descricao = json['descricao'];
    valor = json['valor'];
    dhCadastro = json['dh_cadastro'];
    dhPago = json['dh_pago'];
    idStatus = json['id_status'];
    idClientes = json['id_clientes'];
    idServicos = json['id_servicos'];
    idUsuarios = json['id_usuarios'];
    observacao = json['observacao'];
    clienteNome = json['cliente_nome'];
    clienteCpfCnpj = json['cliente_cpf_cnpj'];
    statusDescricao = json['status_descricao'];
    valorFormatado = json['valor_formatado'];
    dhCadastroFormatada = json['dh_cadastro_formatada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fatura'] = fatura;
    data['descricao'] = descricao;
    data['valor'] = valor;
    data['dh_cadastro'] = dhCadastro;
    data['dh_pago'] = dhPago;
    data['id_status'] = idStatus;
    data['id_clientes'] = idClientes;
    data['id_servicos'] = idServicos;
    data['id_usuarios'] = idUsuarios;
    data['observacao'] = observacao;
    data['cliente_nome'] = clienteNome;
    data['cliente_cpf_cnpj'] = clienteCpfCnpj;
    data['status_descricao'] = statusDescricao;
    data['valor_formatado'] = valorFormatado;
    data['dh_cadastro_formatada'] = dhCadastroFormatada;
    return data;
  }
}
