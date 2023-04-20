import 'package:data_entry_app/controllers/DBDataEntry.dart';

class ProjectModel extends DBDataEntry {
  int id = 0;
  String name = '';
  String longitude = '';
  String latitude = '';
  int idCountry = 0;
  int idState = 0;
  int idCompany = 0;
  String generalLeader = '';
  String environmentalLeader = '';
  String lastUpdate = '';
  String comments = '';
  int status = 0;
  double magneticDeclination = 0.0;
  // #CAMPO DE OTRO TABLA.
  String country = '';
  String company = '';
  String state = '';

  String tbName = 'tb_projects';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'id_country': idCountry,
      'country': country,
      'id_state': idState,
      'state': state,
      'id_company': idCompany,
      'company': company,
      'general_leader': generalLeader,
      'environmental_leader': environmentalLeader,
      'last_update': lastUpdate,
      'comments': comments,
      'status': status,
      'magnetic_declination': magneticDeclination
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.name = map['name'] ?? '';
    this.longitude = map['longitude'] ?? '';
    this.latitude = map['latitude'] ?? '';
    this.idCountry = map['id_country'] ?? 0;
    this.country = map['country'] ?? '';
    this.idState = map['id_state'] ?? 0;
    this.state = map['state'] ?? '';
    this.idCompany = map['id_company'] ?? 0;
    this.company = map['company'] ?? '';
    this.generalLeader = map['general_leader'] ?? '';
    this.environmentalLeader = map['environmental_leader'];
    this.lastUpdate = map['last_update'] ?? '';
    this.comments = map['comments'] ?? '';
    this.status = map['status'] ?? 0;
    this.magneticDeclination = map['magnetic_declination'] ?? 0.0;
  }

  Future<List<ProjectModel>> obtnerTodos() async {
    List<Map<String, dynamic>> maps =
        await fnObtenerTodosLosRegistros(tbName: this.tbName);
    ProjectModel item;
    return List.generate(maps.length, (i) {
      item = new ProjectModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<ProjectModel>> obtnerTodosPorUsuario(int userId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery(
          "SELECT P.*, C.company " +
              "FROM tb_asignedproject AS AP " +
              " INNER JOIN $tbName AS P ON P.id = AP.id_project AND P.`status` = 1 " +
              " INNER JOIN tb_companies AS C ON C.Id = P.id_company " +
              "WHERE AP.id_usertinformation = ? " +
              "ORDER BY P.last_update DESC",
          [userId]).onError((error, stackTrace) => []);
    });
    ProjectModel item;
    return List.generate(maps.length, (i) {
      item = new ProjectModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<ProjectModel>> obtnerTodosPorUsuarioComania(
      int userId, int companyId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery(
          "SELECT P.*, C.company " +
              "FROM tb_asignedproject AS AP " +
              "	INNER JOIN tb_projects AS P ON P.id = AP.id_project AND P.`status` = 1 " +
              "	INNER JOIN tb_companies AS C ON C.Id = P.id_company " +
              "WHERE AP.id_usertinformation = ? " +
              "UNION " +
              "SELECT P.*, C.company " +
              "FROM tb_projects AS P " +
              "	INNER JOIN tb_companies AS C ON C.Id = P.id_company " +
              "WHERE C.id = ? " +
              "GROUP BY P.id, P.name, P.longitude, " +
              "	P.latitude, P.id_country, P.id_state, " +
              "  	P.general_leader, P.environmental_leader, " +
              "  	P.last_update, P.comments, P.`status`, " +
              "  	P.magnetic_declination, C.company " +
              "ORDER BY P.last_update DESC ",
          [userId, companyId]).onError((error, stackTrace) => []);
    });
    ProjectModel item;
    return List.generate(maps.length, (i) {
      item = new ProjectModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<ProjectModel>> obtnerTodosPorEmpresaId(int empresaId) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.query(this.tbName,
            where: 'id_company = ?', whereArgs: [empresaId]);
      });
    }
    ProjectModel item;
    return List.generate(maps.length, (i) {
      item = new ProjectModel();
      item.fromMap(maps[i]);
      return item;
    });
  }
}
