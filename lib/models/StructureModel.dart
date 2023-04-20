import 'package:data_entry_app/controllers/DBDataEntry.dart';

class StructureModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  dynamic chk = 0.0;
  int structure_type = 0;
  dynamic structure_angle = 0.0;
  String comments = '';
  int status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  String structureType = '';

  String tbName = 'tb_structure';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'Structure_Type1': structure_type,
      'Struc_Angle': structure_angle,
      'Structure_Comment': comments,
      'status': status,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.structure_type = map['Structure_Type1'] ?? 0;
    this.structureType = map['StructureType'] ?? 0;

    this.structure_angle = map['Struc_Angle'] ?? 0.0;
    this.comments = map['Structure_Comment'] ?? '';
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

  Future<List<StructureModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                " LB.*, " +
                " G.StrucType AS StructureType " +
                "FROM $tbName AS LB " +
                " INNER JOIN cat_structype AS G ON G.Id = LB.Structure_Type1 " +
                "WHERE LB.IdCollar = ? AND LB.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
      });
    }
    StructureModel item;
    return List.generate(maps.length, (i) {
      item = new StructureModel();
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
      count = await value
          .rawDelete('DELETE FROM $nombreTabla WHERE $campo = $valor');
      assert(count == 1);
    }, onError: (error) {
      return false;
    });
    return count;
  }
}
