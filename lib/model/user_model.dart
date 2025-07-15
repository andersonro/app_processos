class UserModel {
  String? nome;
  String? email;
  String? token;
  String? status;

  UserModel({this.nome, this.email, this.token, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    email = json['email'];
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['email'] = email;
    data['token'] = token;
    data['status'] = status;
    return data;
  }
}
