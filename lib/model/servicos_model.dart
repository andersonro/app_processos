class ServicosModel {
  int? id;
  String? descricao;
  double? valor;
  String? status;
  String? valorFormatado;

  ServicosModel({
    this.id,
    this.descricao,
    this.valor,
    this.status,
    this.valorFormatado,
  });

  ServicosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    valor = json['valor'];
    status = json['status'];
    valorFormatado = json['valor_formatado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['valor'] = valor;
    data['status'] = status;
    data['valor_formatado'] = valorFormatado;
    return data;
  }
}
