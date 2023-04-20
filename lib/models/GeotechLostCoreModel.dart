import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';

class GeotechLostCoreModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  dynamic geolFrom = 0.0;
  dynamic geolTo = 0.0;
  dynamic chk = 0.0;
  dynamic lostFrom = 0.0;
  dynamic lostTo = 0.0;
  String comments = '';
  int status = 0;

  String tbName = 'tb_lostcore';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'LostFrom': lostFrom,
      'LostTo': lostTo,
      'LostCoreComments': comments,
      'status': status,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.lostFrom = map['LostFrom'] ?? 0.0;
    this.lostTo = map['LostTo'] ?? 0.0;
    this.comments = map['LostCoreComments'] ?? '';
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

  Future<List<GeotechLostCoreModel>> fnObtenerRegistrosPorCollarId
      ({required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                " LC.* " +
                "FROM tb_lostcore AS LC " +
                "WHERE LC.IdCollar = ? AND LC.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
      });
    }
    GeotechLostCoreModel item;
    return List.generate(maps.length, (i) {
      item = new GeotechLostCoreModel();
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
