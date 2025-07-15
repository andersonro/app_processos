class ClientesModel {
  int? id;
  String? nome;
  String? cpfCnpj;
  String? tipoPessoa;
  String? status;
  int? telefone;
  String? email;

  ClientesModel({
    this.id,
    this.nome,
    this.cpfCnpj,
    this.tipoPessoa,
    this.status,
    this.telefone,
    this.email,
  });

  ClientesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpfCnpj = json['cpf_cnpj'];
    tipoPessoa = json['tipo_pessoa'];
    status = json['status'];
    telefone = json['telefone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['cpf_cnpj'] = cpfCnpj;
    data['tipo_pessoa'] = tipoPessoa;
    data['status'] = status;
    data['telefone'] = telefone;
    data['email'] = email;
    return data;
  }
}
