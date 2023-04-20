import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';

class DownholeSurveyModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double depth = 0.0;
  int survtype = 0;
  double dip = 0.0;
  double azimuth = 0.0;
  int azimuth_type = 0;
  String survey_date = '';
  String comments = '';
  int status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  String survTypeName = '';
  String azimuthTypeName = '';

  String tbName = 'tb_downholesurveys';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'Depth': depth,
      'Survtype': survtype,
      'Dip': dip,
      'Azimuth': azimuth,
      'Azimuthtype': azimuth_type,
      'Surv_Date': survey_date,
      'Survey_Comment': comments,
      'status': status,
      // #CAMPOS DE OTRAS TABLAS.
      'SurvTypeName': survTypeName,
      'AzimuthTypeName': azimuthTypeName
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.depth = map['Depth'] ?? 0.00;
    this.survtype = map['Survtype'] ?? '';
    this.dip = map['Dip'] ?? 0;
    this.azimuth = map['Azimuth'] ?? '';
    this.azimuth_type = map['Azimuthtype'] ?? '';
    this.survey_date = map['Surv_Date'] ?? '';
    this.comments = map['Survey_Comment'] ?? '';
    this.status = map['status'] ?? 0;
    // #CAMPOS DE OTRAS TABLAS.
    this.survTypeName = map['SurvTypeName'] ?? '';
    this.azimuthTypeName = map['AzimuthTypeName'] ?? '';
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

  Future<List<DownholeSurveyModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        /*maps = await db.query(this.tbName,
            where: 'IdCollar = ?',
            whereArgs: [collarId],
            orderBy: orderByCampo);*/
        maps = await db.rawQuery(
            "SELECT " +
                "DS.*, " +
                "ST.SurveyType AS SurvTypeName, " +
                "AT.AzimuthType AS AzimuthTypeName " +
                "FROM $tbName AS DS " +
                "INNER JOIN cat_surveytype AS ST ON ST.Id = DS.Survtype " +
                "INNER JOIN cat_azimuthtype AS AT ON AT.Id = DS.Azimuthtype " +
                "WHERE DS.IdCollar = ? AND DS.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
      });
    }
    DownholeSurveyModel item;
    return List.generate(maps.length, (i) {
      item = new DownholeSurveyModel();
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
