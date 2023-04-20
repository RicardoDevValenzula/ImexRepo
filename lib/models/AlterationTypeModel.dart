

import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class AlterationTypeModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  double chk = 0.0;
  String comments = '';

  dynamic alterationType1 = 0;
  dynamic alterationType1Intensity = 0;
  dynamic alterationType1Style = 0;
  dynamic alterationType2 = 0;
  dynamic alterationType2Intensity = 0;
  dynamic alterationType2Style = 0;
  dynamic alterationType3 = 0;
  dynamic alterationType3Intensity = 0;
  dynamic alterationType3Style = 0;
  dynamic alterationType4 = 0;
  dynamic alterationType4Intensity = 0;
  dynamic alterationType4Style = 0;
  dynamic alterationType5 = 0;
  dynamic alterationType5Intensity = 0;
  dynamic alterationType5Style = 0;
  dynamic metallurgicalType = 0;

  int status = 0;
  // #CAMPOS RELACION A OTRAS TABLAS.
  String alterationType1Name = '';
  String alterationType2Name = '';
  String alterationType3Name = '';
  String alterationType4Name = '';
  String alterationType5Name = '';
  String altType1IntensityName = '';
  String altType2IntensityName = '';
  String altType3IntensityName = '';
  String altType4IntensityName = '';
  String altType5IntensityName = '';
  String altType1StyleName = '';
  String altType2StyleName = '';
  String altType3StyleName = '';
  String altType4StyleName = '';
  String altType5StyleName = '';
  String metallurgicalTypeName = '';

  String tbName = 'tb_alterationtype';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'Alteration_Comment': comments,
      'Alteration_Type1': alterationType1,
      'AltType1_Intensity': alterationType1Intensity,
      'AltType1_Style': alterationType1Style,
      'Alteration_Type2': alterationType2,
      'AltType2_Intensity': alterationType2Intensity,
      'AltType2_Style': alterationType2Style,
      'Alteration_Type3': alterationType3,
      'AltType3_Intensity': alterationType3Intensity,
      'AltType3_Style': alterationType3Style,
      'Alteration_Type4': alterationType4,
      'AltType4_Intensity': alterationType4Intensity,
      'AltType4_Style': alterationType4Style,
      'Alteration_Type5': alterationType5,
      'AltType5_Intensity': alterationType5Intensity,
      'AltType5_Style': alterationType5Style,
      'Metallurgical_Type': metallurgicalType
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.comments = map['Alteration_Comment'] ?? '';
    this.alterationType1 = map['Alteration_Type1'] ?? '';
    this.alterationType1Intensity = map['AltType1_Intensity'] ?? '';
    this.alterationType1Style = map['AltType1_Style'] ?? '';
    this.alterationType2 = map['Alteration_Type2'] ?? '';
    this.alterationType2Intensity = map['AltType2_Intensity'] ?? '';
    this.alterationType2Style = map['AltType2_Style'] ?? '';
    this.alterationType3 = map['Alteration_Type3'] ?? '';
    this.alterationType3Intensity = map['AltType3_Intensity'] ?? '';
    this.alterationType3Style = map['AltType3_Style'] ?? '';
    this.alterationType4 = map['Alteration_Type4'] ?? '';
    this.alterationType4Intensity = map['AltType4_Intensity'] ?? '';
    this.alterationType4Style = map['AltType4_Style'] ?? '';
    this.alterationType5 = map['Alteration_Type5'] ?? '';
    this.alterationType5Intensity = map['AltType5_Intensity'] ?? '';
    this.alterationType5Style = map['AltType5_Style'] ?? '';
    this.metallurgicalType = map['Metallurgical_Type'] ?? '';
    this.status = map['status'] ?? 0;
    // #CAMPOS RELACION A OTRAS TABLAS.
    this.alterationType1Name = map['alteration_Type1Name'] ?? '';
    this.altType1IntensityName = map['altType1_IntensityName'] ?? '';
    this.altType1StyleName = map['altType1_StyleName'] ?? '';
    this.alterationType2Name = map['alteration_Type2Name'] ?? '';
    this.altType2IntensityName = map['altType2_IntensityName'] ?? '';
    this.altType2StyleName = map['altType2_StyleName'] ?? '';
    this.alterationType3Name = map['alteration_Type3Name'] ?? '';
    this.altType3IntensityName = map['altType3_IntensityName'] ?? '';
    this.altType3StyleName = map['altType3_StyleName'] ?? '';
    this.alterationType4Name = map['alteration_Type4Name'] ?? '';
    this.altType4IntensityName = map['altType4_IntensityName'] ?? '';
    this.altType4StyleName = map['altType4_StyleName'] ?? '';
    this.alterationType5Name = map['alteration_Type5Name'] ?? '';
    this.altType5IntensityName = map['altType5_IntensityName'] ?? '';
    this.altType5StyleName = map['altType5_StyleName'] ?? '';
    this.metallurgicalTypeName = map['metallurgicalTypeName'];
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

  Future<List<AlterationTypeModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        /*
        maps = await db.query(this.tbName,
            where: 'IdCollar = ?',
            whereArgs: [collarId],
            orderBy: orderByCampo);
        */
        maps = await db.rawQuery("SELECT " +
            "	IFNULL(at1.Alteration_Type, '') AS alteration_Type1Name, " +
            "	IFNULL(at2.Alteration_Type, '') AS alteration_Type2Name, " +
            "	IFNULL(at3.Alteration_Type, '') AS alteration_Type3Name, " +
            "	IFNULL(at4.Alteration_Type, '') AS alteration_Type4Name, " +
            "	IFNULL(at5.Alteration_Type, '') AS alteration_Type5Name, " +
            "	IFNULL(ati1.AltType_Intensity, '') AS altType1_IntensityName, " +
            "	IFNULL(ati2.AltType_Intensity, '') AS altType2_IntensityName, " +
            "	IFNULL(ati3.AltType_Intensity, '') AS altType3_IntensityName, " +
            "	IFNULL(ati4.AltType_Intensity, '') AS altType4_IntensityName, " +
            "	IFNULL(ati5.AltType_Intensity, '') AS altType5_IntensityName, " +
            "	IFNULL(ats1.AltType_Style, '') AS altType1_StyleName, " +
            "	IFNULL(ats2.AltType_Style, '') AS altType2_StyleName, " +
            "	IFNULL(ats3.AltType_Style, '') AS altType3_StyleName, " +
            "	IFNULL(ats4.AltType_Style, '') AS altType4_StyleName, " +
            "	IFNULL(ats5.AltType_Style, '') AS altType5_StyleName, " +
            "	IFNULL(mt.Metallurgical_Type, '') AS metallurgicalTypeName, " +
            "	L.* " +
            "FROM $tbName AS L " +
            "	LEFT JOIN cat_alteration_type AS at1 ON at1.Id = L.Alteration_Type1 " +
            "	LEFT JOIN cat_alteration_type AS at2 ON at2.Id = L.Alteration_Type2 " +
            "	LEFT JOIN cat_alteration_type AS at3 ON at3.Id = L.Alteration_Type3 " +
            "	LEFT JOIN cat_alteration_type AS at4 ON at4.Id = L.Alteration_Type4 " +
            "	LEFT JOIN cat_alteration_type AS at5 ON at5.Id = L.Alteration_Type5 " +
            "	LEFT JOIN cat_alttype_intensity AS ati1 ON ati1.Id = L.AltType1_Intensity " +
            "	LEFT JOIN cat_alttype_intensity AS ati2 ON ati2.Id = L.AltType2_Intensity " +
            "	LEFT JOIN cat_alttype_intensity AS ati3 ON ati3.Id = L.AltType3_Intensity " +
            "	LEFT JOIN cat_alttype_intensity AS ati4 ON ati4.Id = L.AltType4_Intensity " +
            "	LEFT JOIN cat_alttype_intensity AS ati5 ON ati5.Id = L.AltType5_Intensity " +
            "	LEFT JOIN cat_alttype_style AS ats1 ON ats1.Id = L.AltType1_Style " +
            "	LEFT JOIN cat_alttype_style AS ats2 ON ats2.Id = L.AltType2_Style " +
            "	LEFT JOIN cat_alttype_style AS ats3 ON ats3.Id = L.AltType3_Style " +
            "	LEFT JOIN cat_alttype_style AS ats4 ON ats4.Id = L.AltType4_Style " +
            "	LEFT JOIN cat_alttype_style AS ats5 ON ats5.Id = L.AltType5_Style " +
            "	LEFT JOIN cat_metallurgial_type AS mt ON mt.Id = L.Metallurgical_Type " +
            "WHERE L.IdCollar = $collarId AND L.status = 1 "+
            "ORDER BY GeolFrom ASC"
        );
      });
    }
    AlterationTypeModel item;
    return List.generate(maps.length, (i) {
      item = new AlterationTypeModel();
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
