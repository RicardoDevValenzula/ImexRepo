
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';

class LoggedByModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  double chk = 0.0;
  dynamic geologist = 0;
  String dateLogged = '';
  int status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  String geologistName = '';

  String tbName = 'tb_loggedby';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'Geologist': geologist,
      'DateLogged': dateLogged,
      'status': status,
      // #CAMPOS DE OTRAS TABLAS.
      'geologistName': geologistName
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.geologist = map['Geologist'] ?? 0;
    this.dateLogged = map['DateLogged'] ?? '';
    this.status = map['status'] ?? 0;
    // #CAMPOS DE OTRAS TABLAS.
    this.geologistName = map['geologistName'] ?? '';
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

  Future<List<LoggedByModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                "LB.*, " +
                "G.geologist AS geologistName " +
                "FROM tb_loggedby AS LB " +
                "LEFT JOIN cat_geologist AS G ON G.Id = LB.Geologist "+
                "WHERE LB.IdCollar = ? AND LB.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
       //dv.log('${maps}');
      });
    }
    LoggedByModel item;
    return List.generate(maps.length, (i) {
      item = new LoggedByModel();
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
