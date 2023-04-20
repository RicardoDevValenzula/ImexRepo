import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class SpecificGravityModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  dynamic depth = 0;
  dynamic chk = 0;
  dynamic length = 0;
  dynamic weightDryAir = 0;
  dynamic weightWater = 0;
  dynamic weightWaterSealed = 0;
  dynamic finalWeightNoSealed = 0;
  dynamic chk1 = 0;
  dynamic specificGravity_1 = 0;
  dynamic vol_1 = 0;
  dynamic vol_2 = 0;
  dynamic difvol = 0;
  dynamic specificGravity_2 = 0;
  String comments = '';
  int status = 0;

  String tbName = 'tb_specificgravity';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'Depth': depth,
      'Chk': chk,
      'Length': length,
      'WeightDryAir': weightDryAir,
      'WeightWater': weightWater,
      'WeigthWaterSealed': weightWaterSealed,
      'FinalWeightNoSealed': finalWeightNoSealed,
      'Chk1': chk1,
      'SpecificGravity_1': specificGravity_1,
      'Vol_1': vol_1,
      'Vol_2': vol_2,
      'DifVol': difvol,
      'SpecificGravity_2': comments,
      'SpecificGravityComment': comments,
      'status': status,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.depth = map['Depth'] ?? 0.0;
    this.length = map['Length'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.weightDryAir = map['WeightDryAir'] ?? '';
    this.weightWater = map['WeightWater'] ?? 0.0;
    this.weightWaterSealed = map['WeigthWaterSealed'] ?? 0.0;
    this.finalWeightNoSealed = map['FinalWeightNoSealed'] ?? 0.0;
    this.chk1 = map['Chk1'] ?? 0.0;
    this.specificGravity_1 = map['SpecificGravity_1'] ?? 0.0;
    this.vol_1 = map['Vol_1'] ?? 0.0;
    this.vol_2 = map['Vol_2'] ?? 0.0;
    this.difvol = map['DifVol'] ?? 0.0;
    this.specificGravity_2 = map['SpecificGravity_2'] ?? 0.0;
    this.comments = map['SpecificGravityComment'] ?? '';
    this.status = map['status'] ?? 0;
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

  Future<List<SpecificGravityModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                " SG.* " +
                "FROM $tbName AS SG " +
                "WHERE SG.IdCollar = ? AND SG.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId,1]);
      });
    }
    SpecificGravityModel item;
    return List.generate(maps.length, (i) {
      item = new SpecificGravityModel();
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
