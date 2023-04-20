import 'package:data_entry_app/controllers/CollarController.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/CampaignModel.dart';
import 'package:data_entry_app/models/CoordSystModel.dart';
import 'package:data_entry_app/models/CountryModel.dart';
import 'package:data_entry_app/models/EllipsoidModel.dart';
import 'package:data_entry_app/models/GeologistModel.dart';
import 'package:data_entry_app/models/GridNameModel.dart';
import 'package:data_entry_app/models/ProjectModel.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/models/SubProjectModel.dart';
import 'package:sqflite/sqflite.dart';

class CollarModel extends DBDataEntry {
  /*int id = 0;
  String holeId = '';
  int project = 0;
  int subproject = 0;
  int campaign = 0;
  int country = 0;
  int geologist = 0;
  String dateStart = '';
  String dateEnd = '';
  double depth = 0.0;
  int coordSyst = 0;
  double east = 0.0;
  double north = 0.0;
  double elevation = 0.0;
  double rLOrthometric = 0.0;
  int rLEllipsoid = 0;
  int gridName = 0;
  double azimuth = 0.0;
  int azimuthMethod = 0;
  double dip = 0.0;
  int dipMethod = 0;
  int dHCompany = 0;
  int drillCompany = 0;
  int rigID = 0;
  int drillType = 0;
  int diameterType = 0;
  int casingSize = 0;
  double topOdSulphides = 0.0;
  double baseOfOxides = 0.0;
  String depthBedRock = '';
  int waterPresent = 0;
  double waterTable = 0.0;
  String collarComment = '';
  int status = 0;
  // #EXTRA PROP
  String subProjectName = '';
  String projectName = '';
  String campaignName = '';
  String countryName = '';
  String geologistName = '';
  String coordSystName = '';
  String ellipsoidName = '';
  String gridnameName = '';*/

  int id = 0;
  dynamic holeId = '';
  dynamic project = 0;
  dynamic subproject = 0;
  dynamic campaign = 0;
  dynamic country = 0;
  dynamic geologist = 0;
  dynamic dateStart = '';
  dynamic dateEnd = '';
  dynamic depth = 0.0;
  dynamic coordSyst = 0;
  dynamic east = 0.0;
  dynamic north = 0.0;
  dynamic elevation = 0.0;
  dynamic rLOrthometric = 0.0;
  dynamic rLEllipsoid = 0;
  dynamic gridName = 0;
  dynamic azimuth = 0.0;
  dynamic azimuthMethod = 0;
  dynamic dip = 0.0;
  dynamic dipMethod = 0;
  dynamic dHCompany = 0;
  dynamic drillCompany = 0;
  dynamic rigID = 0;
  dynamic drillType = 0;
  dynamic diameterType = 0;
  dynamic casingSize = 0;
  dynamic topOdSulphides = 0.0;
  dynamic baseOfOxides = 0.0;
  dynamic depthBedRock = '';
  dynamic waterPresent = 0;
  dynamic waterTable = 0.0;
  dynamic collarComment = '';
  dynamic candado = 0;
  dynamic status = 0;
  // #EXTRA PROP
  dynamic subProjectName = '';
  dynamic projectName = '';
  dynamic campaignName = '';
  dynamic countryName = '';
  dynamic geologistName = '';
  dynamic coordSystName = '';
  dynamic ellipsoidName = '';
  dynamic gridnameName = '';

  String tbName = 'tb_collar';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'HoleId': holeId,
      'project': project,
      'subproject': subproject,
      'Campaign': campaign,
      'Country': country,
      'Geologist': geologist,
      'DateStart': dateStart,
      'DateEnd': dateEnd,
      'Depth': depth,
      'CoordSyst': coordSyst,
      'East': east,
      'North': north,
      'Elevation': elevation,
      'RLOrthometric': rLOrthometric,
      'RLEllipsoid': rLEllipsoid,
      'GridName': gridName,
      'Azimuth': azimuth,
      'Azimuth_Method': azimuthMethod,
      'Dip': dip,
      'DipMethod': dipMethod,
      'DH_Company': dHCompany,
      'Drill_Company': drillCompany,
      'RigID': rigID,
      'DrillType': drillType,
      'DiameterType': diameterType,
      'CasingSize': casingSize,
      'Top_Od_Sulphides': topOdSulphides,
      'Base_Of_Oxides': baseOfOxides,
      'Depth_BedRock': depthBedRock,
      'WaterPresent': waterPresent,
      'WaterTable': waterTable,
      'Collar_Comment': collarComment,
      'status': status,
      'candado': candado,
      // #SUBPROJECT.
      'subProjectName': subProjectName,
      // #PROJECT.
      'projectName': projectName,
      //CampaignModel.
      'campaignName': campaignName,
      //countryName.
      'countryName': countryName,
      'geologistName': geologistName,
      'coordSystName': coordSystName,
      'ellipsoidName': ellipsoidName,
      'gridnameName': gridnameName
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.holeId = map['HoleId'] ?? '';
    this.project = map['project'] ?? 0;
    this.subproject = map['subproject'] ?? 0;
    this.campaign = map['Campaign'] ?? 0;
    this.country = map['Country'] ?? 0;
    this.geologist = map['Geologist'] ?? 0;
    this.dateStart = map['DateStart'] ?? '';
    this.dateEnd = map['DateEnd'] ?? '';
    this.depth = map['Depth'] ?? 0.0;
    this.coordSyst = map['CoordSyst'] ?? 0;
    this.east = map['East'] ?? 0.0;
    this.north = map['North'] ?? 0.0;
    this.elevation = map['Elevation'] ?? 0.0;
    this.rLOrthometric = map['RLOrthometric'] ?? 0.0;
    this.rLEllipsoid = map['RLEllipsoid'] ?? 0;
    this.gridName = map['GridName'] ?? 0;
    this.azimuth = map['Azimuth'] ?? 0.0;
    this.azimuthMethod = map['Azimuth_Method'] ?? 0;
    this.dip = map['Dip'] ?? 0.0;
    this.dipMethod = map['DipMethod'] ?? 0;
    this.dHCompany = map['DH_Company'] ?? 0;
    this.drillCompany = map['Drill_Company'] ?? 0;
    this.rigID = map['RigID'] ?? 0;
    this.drillType = map['DrillType'] ?? 0;
    this.diameterType = map['DiameterType'] ?? 0;
    this.casingSize = map['CasingSize'] ?? 0;
    this.topOdSulphides = map['Top_Od_Sulphides'] ?? 0.0;
    this.baseOfOxides = map['Base_Of_Oxides'] ?? 0.0;
    this.depthBedRock = map['Depth_BedRock'] ?? '';
    this.waterPresent = map['WaterPresent'] ?? 0;
    this.waterTable = map['WaterTable'] ?? 0.0;
    this.collarComment = map['Collar_Comment'] ?? '';
    this.status = map['status'] ?? 0;
    this.candado = map['candado'] ?? 0;
    // #SUBPROJECT.
    this.subProjectName = map['subProjectName'] ?? '';
    // #PROJECT.
    this.projectName = map['projectName'] ?? '';
    //CampaignModel.
    this.campaignName = map['campaignName'] ?? '';
    //countryName.
    this.countryName = map['countryName'] ?? '';
    this.geologistName = map['geologistName'] ?? '';
    this.coordSystName = map['coordSystName'] ?? '';
    this.ellipsoidName = map['ellipsoidName'] ?? '';
    this.gridnameName = map['gridnameName'] ?? '';
  }

  Future<List<CollarModel>> getAll(int subProjectId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      /*maps = await db
          .query(tbName, where: 'subproject = ?', whereArgs: [subProjectId]);*/

      maps = await db.rawQuery(
          "SELECT c.*, " +
              " IFNULL(sp.name, 'N/D') AS subProjectName , " +
              " IFNULL(p.name, 'N/D') AS projectName, " +
              " IFNULL(camp.campaign, 'N/D') AS campaignName, " +
              " IFNULL(cont.country, 'N/D') AS countryName, " +
              " IFNULL(geo.geologist, 'N/D') AS geologistName, " +
              " IFNULL(coo.coordSyst, 'N/D') AS coordSystName, " +
              " IFNULL(ell.ellipsoid, 'N/D') AS ellipsoidName, " +
              " IFNULL(gri.gridname, 'N/D') AS gridnameName " +
              "FROM $tbName AS c " +
              " INNER JOIN ${SubProjectModel().tbName} AS sp ON sp.id = c.subproject " +
              " INNER JOIN ${ProjectModel().tbName} AS p ON p.id = sp.id_project " +
              " LEFT JOIN ${CampaignModel().tbName} AS camp ON camp.id = c.Campaign " +
              " LEFT JOIN ${CountryModel().tbName} AS cont ON cont.Id = c.Country " +
              " LEFT JOIN ${GeologistModel().tbName} AS geo ON geo.Id = c.Geologist " +
              " LEFT JOIN ${CoordSystModel().tbName} AS coo ON coo.Id = c.CoordSyst " +
              " LEFT JOIN ${EllipsoidModel().tbName} AS ell ON ell.id = c.RLEllipsoid " +
              " LEFT JOIN ${GridNameModel().tbName} AS gri ON gri.id = c.GridName " +
              "WHERE c.subproject = ? " +
              "ORDER BY id DESC",
          [subProjectId]);
    });
    CollarModel item;
    return List.generate(maps.length, (i) {
      item = new CollarModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<CollarModel>> obtenerPorSubProyectoyCampana(
      int subProjectId, int campanaId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      /*maps = await db
          .query(tbName, where: 'subproject = ?', whereArgs: [subProjectId]);*/

      maps = await db.rawQuery(
          "SELECT c.*, " +
              " IFNULL(sp.name, 'N/D') AS subProjectName , " +
              " IFNULL(p.name, 'N/D') AS projectName, " +
              " IFNULL(camp.campaign, 'N/D') AS campaignName, " +
              " IFNULL(cont.country, 'N/D') AS countryName, " +
              " IFNULL(geo.geologist, 'N/D') AS geologistName, " +
              " IFNULL(coo.coordSyst, 'N/D') AS coordSystName, " +
              " IFNULL(ell.ellipsoid, 'N/D') AS ellipsoidName, " +
              " IFNULL(gri.gridname, 'N/D') AS gridnameName " +
              "FROM $tbName AS c " +
              " INNER JOIN ${SubProjectModel().tbName} AS sp ON sp.id = c.subproject " +
              " INNER JOIN ${ProjectModel().tbName} AS p ON p.id = sp.id_project " +
              " LEFT JOIN ${CampaignModel().tbName} AS camp ON camp.id = c.Campaign " +
              " LEFT JOIN ${CountryModel().tbName} AS cont ON cont.Id = c.Country " +
              " LEFT JOIN ${GeologistModel().tbName} AS geo ON geo.Id = c.Geologist " +
              " LEFT JOIN ${CoordSystModel().tbName} AS coo ON coo.Id = c.CoordSyst " +
              " LEFT JOIN ${EllipsoidModel().tbName} AS ell ON ell.id = c.RLEllipsoid " +
              " LEFT JOIN ${GridNameModel().tbName} AS gri ON gri.id = c.GridName " +
              "WHERE c.subproject = ? AND c.Campaign = ? " +
              "ORDER BY id DESC",
          [subProjectId, campanaId]);
    });
    CollarModel item;
    return List.generate(maps.length, (i) {
      item = new CollarModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<CollarModel> getModel(int id) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.query(tbName, where: 'id = ?', whereArgs: [id]);
    });
    CollarModel item = new CollarModel();
    if (maps.length > 0) {
      item.fromMap(maps.first);
    }
    return item;
  }

  Future<int> insertarBase(String nombre, int projectId, int subProjectId,
      int campaignId, int statusSync) async {
    int result = 0;
    int newId = await fnObtnerNuevoId(this.tbName);
    await database.then((db) async {
      result = await db.insert(this.tbName, {
        'id': newId,
        "HoleId": nombre,
        "project": projectId,
        "subproject": subProjectId,
        "Campaign": campaignId,
        "Country": 0,
        "Geologist": 0,
        "RigID": 0,
        "status": 1,
        "status_sync": statusSync,
      });
    });
    return (result>0? newId : 0);
  }

  Future<int> fnActualizarCollar(
      int holeId,
      String nombreTabla,
      Map<String, Object?> valores,
      String whereCampo,
      dynamic whereValor) async {
    int id = 0;
    bool existe = await fnExisteCollar(holeId);
    if (existe) {
      await database.then((db) async {
        id = await db.update(nombreTabla, valores,
            where: '$whereCampo = ?', whereArgs: [whereValor]);
        return id;
      });
    }
    return id;
  }

  Future<bool> fnExisteCollar(int id) async {
    bool respuesta = await database.then((value) async {
      List<Map<String, Object?>> resultado =
          await value.rawQuery("SELECT id FROM tb_collar WHERE id = '$id'");
      return (resultado.length > 0 ? true : false);
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }

  //collars_x_usuario

  Future<List<CollarModel>> getModelsForUser() async {
    Map<String, dynamic> maps = Map();
    ResultModel model = await new CollarController().getCollarsForUser();
    if (model.status) {
      maps = model.data;
    }
    CollarModel item;
    return List.generate(maps.length, (i) {
      item = new CollarModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<Map<String, dynamic>>> fnObtenerListaDeCampanas(
      int subProyectoId) async {
    List<Map<String, dynamic>> maps = [];
    await this.database.then((db) async {
      maps = await db.rawQuery('SELECT ' +
          ' DISTINCT CA.* ' +
          'FROM tb_collar AS C ' +
          '  INNER JOIN cat_campaign AS CA ON CA.id = C.Campaign ' +
          'WHERE C.subproject = $subProyectoId ' +
          'ORDER BY CA.campaign ASC ');
    });
    return maps;
  }

  Future<List<Map<String, dynamic>>> fnPerfilTabAsignado(int collarId) async {
    List<Map<String, dynamic>> maps = [];
    await this.database.then((db) async {
      maps = await db.query('tb_rel_profile_collars',
          where: 'collarId = ?',
          whereArgs: [collarId]).onError((error, stackTrace) => []);
    });
    return maps;
  }

  Future<bool> fnAsignadoPerfilTab(
      int profileTabId, int collarId, int userId) async {
    bool resultado = false;
    await this.database.then((db) async {
      int id = await db
          .insert(
              'tb_rel_profile_collars',
              {
                'profileId': profileTabId,
                'collarId': collarId,
                'userId': userId,
                'status': 1,
                'created_at': ''
              },
              conflictAlgorithm: ConflictAlgorithm.replace)
          .onError((error, stackTrace) => 0);
      resultado = (id > 0 ? true : false);
    });
    return resultado;
  }

  bool fnEliminarBarrenoCompleto(String holeId) {
    return false;
  }
}
