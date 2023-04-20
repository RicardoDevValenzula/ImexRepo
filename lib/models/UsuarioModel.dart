class UsuarioModel {
  int id = 0;
  String username = '';
  String password = '';
  String status = '';
  int idRol = 0;
  String rol = '';
  String email = '';
  String lastName = '';
  String middleName = '';
  String name = '';
  int idCompany = 0;
  String company = '';

  UsuarioModel(
      {required int id,
      required String username,
      String? password,
      required String status,
      required int idRol,
      required String rol,
      required String email,
      required String lastName,
      required String middleName,
      required String name,
      required int idCompany,
      required String company}) {
    this.username = username;
    this.password = password ?? '';
    this.status = status;
    this.idRol = idRol;
    this.rol = rol;
    this.email = email;
    this.lastName = lastName;
    this.middleName = middleName;
    this.name = name;
    this.idCompany = idCompany;
    this.company = company;
  }

  UsuarioModel.fromJson(Map json) {
    this.id = json['id'];
    this.username = json['username'];
    this.password = json['password'];
    this.status = json['status'];
    this.idRol = json['idRol'];
    this.rol = json['rol'];
    this.email = json['email'];
    this.lastName = json['lastName'];
    this.middleName = json['middleName'];
    this.name = json['name'];
    this.idCompany = json['idCompany'];
    this.company = json['company'];
  }
}
