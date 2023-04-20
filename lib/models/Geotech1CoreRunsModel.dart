import 'package:data_entry_app/controllers/DBDataEntry.dart';

class Geotech1CoreRunsModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  dynamic chk = 0.0;
  dynamic rqd_raw = 0.0;
  dynamic recovery_raw = 0.0;
  dynamic recovery = 0.0;
  dynamic rqd = 0;
  dynamic lith1spec = 0;
  dynamic longest_piece = 0.0;
  dynamic rock_strength = 0;
  dynamic hardness = 0;
  dynamic alteration_grade = 0;
  dynamic weathering = 0;
  String comments = '';
  int status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  String LithSpecName = '';
  String RockStrengthName = '';
  String HardnessName = '';
  String AlterationGradeName = '';
  String WeatheringName = '';

  String tbName = 'tb_geotechcorerun';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'RQDraw': rqd_raw,
      'Recoveryraw': recovery_raw,
      'RECOVERY': recovery,
      'RQD': rqd,
      'Lith1Spec': lith1spec,
      'Longest_Piece': longest_piece,
      'Rock_Strength': rock_strength,
      'Hardness': hardness,
      'AlterationGrade': alteration_grade,
      'Weathering': weathering,
      'Comment': comments,
      'status': status,
      // #CAMPOS RELACION A OTRAS TABLAS.
      'LithSpecName': LithSpecName,
      'RockStrengthName': RockStrengthName,
      'HardnessName': HardnessName,
      'AlterationGradeName': AlterationGradeName,
      'WeatheringName': WeatheringName,
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.rqd_raw = map['RQDraw'] ?? 0.0;
    this.recovery_raw = map['Recoveryraw'] ?? 0.0;
    this.recovery = map['RECOVERY'] ?? 0.0;
    this.rqd = map['RQD'] ?? 0;
    this.lith1spec = map['Lith1Spec'] ?? 0;
    this.longest_piece = map['Longest_Piece'] ?? 0.0;
    this.rock_strength = map['Rock_Strength'] ?? 0;
    this.hardness = map['Hardness'] ?? 0;
    this.alteration_grade = map['AlterationGrade'] ?? 0;
    this.weathering = map['Weathering'] ?? 0;
    this.comments = map['Comment'] ?? '';
    this.status = map['status'] ?? 0;

    this.LithSpecName = map['LithSpecName'] ?? '';
    this.RockStrengthName = map['RockStrengthName'] ?? '';
    this.HardnessName = map['HardnessName'] ?? '';
    this.AlterationGradeName = map['AlterationGradeName'] ?? '';
    this.WeatheringName = map['WeatheringName'] ?? '';
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

  Future<List<Geotech1CoreRunsModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                " GC.*, " +
                " LS.LithSpec AS LithSpecName, " +
                " RS.Rock_Strength AS RockStrengthName, " +
                " H.Hardness AS HardnessName, " +
                " AG.AlterationGrade AS AlterationGradeName, " +
                " W.Weathering AS WeatheringName " +
                "FROM tb_geotechcorerun AS GC " +
                " LEFT JOIN cat_lithspec AS LS ON LS.Id = GC.Lith1Spec " +
                " LEFT JOIN cat_rock_strength AS RS ON RS.Id = GC.Rock_Strength " +
                " LEFT JOIN cat_hardness AS H ON H.Id = GC.Hardness " +
                " LEFT JOIN cat_alterationgrade AS AG ON AG.Id = GC.AlterationGrade " +
                " LEFT JOIN cat_weathering AS W ON W.Id = GC.Weathering " +
                "WHERE GC.IdCollar = ? AND GC.status = ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
      });
    }
    Geotech1CoreRunsModel item;
    return List.generate(maps.length, (i) {
      item = new Geotech1CoreRunsModel();
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
