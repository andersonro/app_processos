class StatusModel {
  int? id;
  String? descricao;
  String? status;

  StatusModel({this.id, this.descricao, this.status});

  StatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['status'] = status;
    return data;
  }
}
