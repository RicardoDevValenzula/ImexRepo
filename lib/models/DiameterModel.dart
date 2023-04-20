
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';

class DiameterModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double start_depth = 0.0;
  double end_depth = 0;
  int diameter_type = 0;
  int drill_type = 0;
  int case_type = 0;
  int case_diameter = 0;
  String comments = '';
  int status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  String diameterTypeName = '';
  String drillTypeName = '';
  String caseTypeName = '';
  String caseDiameterName = '';

  String tbName = 'tb_diameter';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'Startdepth': start_depth,
      'Enddepth': end_depth,
      'DiameterType': diameter_type,
      'DrillType': drill_type,
      'CaseType': case_type,
      'CaseDiameter': case_diameter,
      'DIameterComment': comments,
      'status': status,
      // #CAMPOS DE OTRAS TABLAS.
      'diameterTypeName': diameterTypeName,
      'drillTypeName': drillTypeName,
      'caseTypeName': caseTypeName,
      'caseDiameterName': caseDiameterName,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.start_depth = map['Startdepth'] ?? 0.0;
    this.end_depth = map['Enddepth'] ?? 0.0;
    this.diameter_type = map['DiameterType'] ?? 0;
    this.drill_type = map['DrillType'] ?? 0;
    this.case_type = map['CaseType'] ?? 0;
    this.case_diameter = map['CaseDiameter'] ?? 0;
    this.comments = map['DIameterComment'] ?? '';
    this.status = map['status'] ?? 0;
    // #CAMPOS DE OTRAS TABLAS.
    this.diameterTypeName = map['diameterTypeName'] ?? '';
    this.drillTypeName = map['drillTypeName'] ?? '';
    this.caseTypeName = map['caseTypeName'] ?? '';
    this.caseDiameterName = map['caseDiameterName'] ?? '';
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

  Future<List<DiameterModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                "DM.*, " +
                "DIT.diameterType AS diameterTypeName, " +
                "DRT.drilltype AS drillTypeName, " +
                "CT.Case_Type AS caseTypeName, " +
                "CD.CaseDiameter AS caseDiameterName " +
                "FROM $tbName AS DM " +
                "LEFT JOIN cat_diametertype AS DIT ON DIT.Id = DM.DiameterType " +
                "LEFT JOIN cat_drilltype AS DRT ON DRT.Id = DM.DrillType " +
                "LEFT JOIN cat_casetype AS CT ON CT.Id = DM.CaseType " +
                "LEFT JOIN cat_casediameter AS CD ON CD.Id = DM.CaseDiameter " +
                "WHERE DM.IdCollar = ? AND DM.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
      });
    }
    DiameterModel item;
    return List.generate(maps.length, (i) {
      item = new DiameterModel();
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
      /*
      count = await value
          .rawDelete('DELETE FROM $nombreTabla WHERE $campo = $valor');
      */
      // #DEFINIR COMO UNA DESCARGA ELIMINADA.
      Map<String, dynamic> valores = Map();
      Map<String, dynamic> statusSycnc = await fnObtenerStatusSincro(
          campo, valor, nombreTabla, Enum_Acciones.eliminado);
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
