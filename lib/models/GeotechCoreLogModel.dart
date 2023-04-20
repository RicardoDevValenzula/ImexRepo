
import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class GeotechCoreLogModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  dynamic chk = 0.0;
  dynamic join_sets = 0;
  dynamic type = 0;
  dynamic opening = 0.0;
  dynamic roughness = 0;
  dynamic cement_type = 0;
  dynamic location = 0.0;
  dynamic alteration_grade = 0;
  dynamic weathering = 0;
  dynamic rock_strength = 0;
  dynamic hardness = 0;
  dynamic number_structures = 0;
  String alpha = '';
  String beta = '';
  dynamic jcs = 0;
  String comments = '';
  dynamic status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  String RoughnessName = '';
  String CementTypeName = '';
  String AlterationGradeName = '';
  String WeatheringName = '';
  String RockStrengthName = '';
  String HardnessName = '';

  String tbName = 'tb_geotechcorelog';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'JoinSets': join_sets,
      'Type': type,
      'Opening': opening,
      'Roughness': roughness,
      'CementType': cement_type,
      'Location': location,
      'Alteration_Grade': alteration_grade,
      'Weathering': weathering,
      'Rock_Strength': rock_strength,
      'Hardness': hardness,
      'Number_Structures': number_structures,
      'Alpha': alpha,
      'Beta': beta,
      'JCS': jcs,
      'comments': comments,
      'status': status,
      // #CAMPOS RELACION A OTRAS TABLAS.
      'RoughnessName': RoughnessName,
      'CementTypeName': CementTypeName,
      'AlterationGradeName': AlterationGradeName,
      'WeatheringName': WeatheringName,
      'RockStrengthName': RockStrengthName,
      'HardnessName': HardnessName,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.join_sets = map['JoinSets'] ?? 0;
    this.type = map['Type'] ?? 0;
    this.opening = map['Opening'] ?? 0.0;
    this.roughness = map['Roughness'] ?? 0;
    this.cement_type = map['CementType'] ?? 0;
    this.location = map['Location'] ?? 0.0;
    this.alteration_grade = map['Alteration_Grade'] ?? 0;
    this.weathering = map['Weathering'] ?? 0;
    this.rock_strength = map['Rock_Strength'] ?? 0;
    this.hardness = map['Hardness'] ?? 0;
    this.number_structures = map['Number_Structures'] ?? 0;
    this.alpha = map['Alpha'] ?? '';
    this.beta = map['Beta'] ?? '';
    this.jcs = map['JCS'] ?? 0;
    this.comments = map['Comments'] ?? '';
    this.status = map['status'] ?? 0;

    this.RoughnessName = map['RoughnessName'] ?? '';
    this.CementTypeName = map['CementTypeName'] ?? '';
    this.AlterationGradeName = map['AlterationGradeName'] ?? '';
    this.WeatheringName = map['WeatheringName'] ?? '';
    this.RockStrengthName = map['RockStrengthName'] ?? '';
    this.HardnessName = map['HardnessName'] ?? '';
  }

  Future<int> insertarModelo() async {
    int result = 0;
    int newId = await fnObtnerNuevoId(this.tbName);
    await database.then((db) async {
      this.id = newId;
      result = await db.insert(this.tbName, toMap());
    });
    return result;
  }

  Future<List<GeotechCoreLogModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                " GCL.*, " +
                " RN.name AS RoughnessName, " +
                " CT.name AS CementTypeName, " +
                " AG.AlterationGrade AS AlterationGradeName, " +
                " W.Weathering AS WeatheringName, " +
                " RS.Rock_Strength AS RockStrengthName, " +
                " HN.Hardness AS HardnessName " +
                "FROM $tbName AS GCL " +
                " LEFT JOIN cat_roughness AS RN ON RN.Id = GCL.Roughness " +
                " LEFT JOIN cat_cementtype AS CT ON CT.Id = GCL.CementType " +
                " LEFT JOIN cat_alterationgrade AS AG ON AG.Id = GCL.Alteration_Grade " +
                " LEFT JOIN cat_weathering AS W ON W.Id = GCL.Weathering " +
                " LEFT JOIN cat_rock_strength AS RS ON RS.Id = GCL.Rock_Strength " +
                " LEFT JOIN cat_hardness AS HN ON HN.Id = GCL.Hardness " +
                "WHERE GCL.Id_Collar = $collarId AND GCL.status = 1 " +
                "ORDER BY $orderByCampo ASC ",
        );
      });
      //log('${maps}');
    }
    GeotechCoreLogModel item;
    return List.generate(maps.length, (i) {
      item = new GeotechCoreLogModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<dynamic> fnEliminarRegistro(
      {required String nombreTabla,
      required String campo,
      required dynamic valor}) async {
    int count = 0;
    await database.then((value) async {
      Map<String, dynamic> valores = Map();
      Map<String, dynamic> statusSycnc = await fnObtenerStatusSincro(campo, valor, nombreTabla, Enum_Acciones.eliminado);
      if (statusSycnc['respuesta']) {
        valores['status_sync'] = statusSycnc['status_sync'];
      }
      valores['status'] = 0;
      count = await value.update(nombreTabla, valores,
          where: '$campo = ?', whereArgs: [valor]);
      return id;
      //assert(count == 1);
    }, onError: (error) {
      return false;
    });
    return count;
  }
}
