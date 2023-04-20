import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class LithologyModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  double chk = 0.0;
  String geologyComment = '';
  dynamic lithologyLocal = 0;
  dynamic lithContact = 0;
  dynamic lith1Abund = 0;
  dynamic lith1Spec = 0;
  dynamic lith1Mod = 0;
  dynamic lith1ColorMod = 0;
  dynamic lith1Color = 0;
  dynamic lith2Abund = 0;
  dynamic lith2Spec = 0;
  dynamic lith2Mod = 0;
  dynamic lith2ColorMod = 0;
  dynamic lith2Color = 0;
  dynamic lith3Abund = 0;
  dynamic lith3Spec = 0;
  dynamic lith3Mod = 0;
  dynamic lith3ColorMod = 0;
  dynamic lith3Color = 0;
  dynamic lith4Abund = 0;
  dynamic lith4Spec = 0;
  dynamic lith4Mod = 0;
  dynamic lith4ColorMod = 0;
  dynamic lith4Color = 0;
  dynamic lith5Abund = 0;
  dynamic lith5Spec = 0;
  dynamic lith5Mod = 0;
  dynamic lith5ColorMod = 0;
  dynamic lith5Color = 0;
  dynamic lithologyCategory = 0;
  int status = 0;
  // #CAMPOS RELACION A OTRAS TABLAS.
  String lithSpec5Name = '';
  String lithSpec4Name = '';
  String lithSpec3Name = '';
  String lithSpec2Name = '';
  String lithSpec1Name = '';
  String lithAbund5Name = '';
  String lithAbund4Name = '';
  String lithAbund3Name = '';
  String lithAbund2Name = '';
  String lithAbund1Name = '';
  String lithMod5Name = '';
  String lithMod4Name = '';
  String lithMod3Name = '';
  String lithMod2Name = '';
  String lithMod1Name = '';
  String lithColorMod5Name = '';
  String lithColorMod4Name = '';
  String lithColorMod3Name = '';
  String lithColorMod2Name = '';
  String lithColorMod1Name = '';
  String lithColor5Name = '';
  String lithColor4Name = '';
  String lithColor3Name = '';
  String lithColor2Name = '';
  String lithColor1Name = '';
  String lithologyCategoryName = '';
  String lithContactName = '';
  String lithLocalName = '';

  String tbName = 'tb_lithology';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'Geology_Comment': geologyComment,
      'Lithology_Local': lithologyLocal,
      'LithContact': lithContact,
      'Lith1Abund': lith1Abund,
      'Lith1Spec': lith1Spec,
      'Lith1Mod': lith1Mod,
      'Lith1ColorMod': lith1ColorMod,
      'Lith1Color': lith1Color,
      'Lith2Abund': lith2Abund,
      'Lith2Spec': lith2Spec,
      'Lith2Mod': lith2Mod,
      'Lith2ColorMod': lith2ColorMod,
      'Lith2Color': lith2Color,
      'Lith3Abund': lith3Abund,
      'Lith3Spec': lith3Spec,
      'Lith3Mod': lith3Mod,
      'Lith3ColorMod': lith3ColorMod,
      'Lith3Color': lith3Color,
      'Lith4Abund': lith4Abund,
      'lith4Spec': lith4Spec,
      'Lith4Mod': lith4Mod,
      'Lith4ColorMod': lith4ColorMod,
      'Lith4Color': lith4Color,
      'Lith5Abund': lith5Abund,
      'lith5Spec': lith5Spec,
      'Lith5Mod': lith5Mod,
      'Lith5ColorMod': lith5ColorMod,
      'Lith5Color': lith5Color,
      'Lithology_Category': lithologyCategory,
      'status': status,
      // #CAMPOS RELACION A OTRAS TABLAS.
      'lithSpec5Name': lithSpec5Name,
      'lithSpec4Name': lithSpec4Name,
      'lithSpec3Name': lithSpec3Name,
      'lithSpec2Name': lithSpec2Name,
      'lithSpec1Name': lithSpec1Name,
      'lithAbund5Name': lithAbund5Name,
      'lithAbund4Name': lithAbund4Name,
      'lithAbund3Name': lithAbund3Name,
      'lithAbund2Name': lithAbund2Name,
      'lithAbund1Name': lithAbund1Name,
      'lithologyCategoryName': lithologyCategoryName,
      'lithContactName': lithContactName,
      'lithLocalName': lithLocalName
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.geologyComment = map['Geology_Comment'] ?? '';
    this.lithologyLocal = map['Lithology_Local'] ?? 0;
    this.lithContact = map['LithContact'] ?? 0;
    this.lith1Abund = map['Lith1Abund'] ?? 0;
    this.lith1Spec = map['Lith1Spec'] ?? 0;
    this.lith1Mod = map['Lith1Mod'] ?? 0;
    this.lith1ColorMod = map['Lith1ColorMod'] ?? 0;
    this.lith1Color = map['Lith1Color'] ?? 0;
    this.lith2Abund = map['Lith2Abund'] ?? 0;
    this.lith2Spec = map['Lith2Spec'] ?? 0;
    this.lith2Mod = map['Lith2Mod'] ?? 0;
    this.lith2ColorMod = map['Lith2ColorMod'] ?? 0;
    this.lith2Color = map['Lith2Color'] ?? 0;
    this.lith3Abund = map['Lith3Abund'] ?? 0;
    this.lith3Spec = map['Lith3Spec'] ?? 0;
    this.lith3Mod = map['Lith3Mod'] ?? 0;
    this.lith3ColorMod = map['Lith3ColorMod'] ?? 0;
    this.lith3Color = map['Lith3Color'] ?? 0;
    this.lith4Abund = map['Lith4Abund'] ?? 0;
    this.lith4Spec = map['lith4Spec'] ?? 0;
    this.lith4Mod = map['Lith4Mod'] ?? 0;
    this.lith4ColorMod = map['Lith4ColorMod'] ?? 0;
    this.lith4Color = map['Lith4Color'] ?? 0;
    this.lith5Abund = map['Lith5Abund'] ?? 0;
    this.lith5Spec = map['lith5Spec'] ?? 0;
    this.lith5Mod = map['Lith5Mod'] ?? 0;
    this.lith5ColorMod = map['Lith5ColorMod'] ?? 0;
    this.lith5Color = map['Lith5Color'] ?? 0;
    this.lithologyCategory = map['Lithology_Category'] ?? 0;
    this.status = map['status'] ?? 0;
    // #CAMPOS RELACION A OTRAS TABLAS.
    this.lithSpec5Name = map['lithSpec5Name'] ?? '';
    this.lithSpec4Name = map['lithSpec4Name'] ?? '';
    this.lithSpec3Name = map['lithSpec3Name'] ?? '';
    this.lithSpec2Name = map['lithSpec2Name'] ?? '';
    this.lithSpec1Name = map['lithSpec1Name'] ?? '';
    this.lithAbund5Name = map['lithAbund5Name'] ?? '';
    this.lithAbund4Name = map['lithAbund4Name'] ?? '';
    this.lithAbund3Name = map['lithAbund3Name'] ?? '';
    this.lithAbund2Name = map['lithAbund2Name'] ?? '';
    this.lithAbund1Name = map['lithAbund1Name'] ?? '';
    this.lithMod5Name = map['lithMod5Name'] ?? '';
    this.lithMod4Name = map['lithMod4Name'] ?? '';
    this.lithMod3Name = map['lithMod3Name'] ?? '';
    this.lithMod2Name = map['lithMod2Name'] ?? '';
    this.lithMod1Name = map['lithMod1Name'] ?? '';
    this.lithColorMod5Name = map['lithColorMod5Name'] ?? '';
    this.lithColorMod4Name = map['lithColorMod4Name'] ?? '';
    this.lithColorMod3Name = map['lithColorMod3Name'] ?? '';
    this.lithColorMod2Name = map['lithColorMod2Name'] ?? '';
    this.lithColorMod1Name = map['lithColorMod1Name'] ?? '';
    this.lithColor5Name = map['lithColor5Name'] ?? '';
    this.lithColor4Name = map['lithColor4Name'] ?? '';
    this.lithColor3Name = map['lithColor3Name'] ?? '';
    this.lithColor2Name = map['lithColor2Name'] ?? '';
    this.lithColor1Name = map['lithColor1Name'] ?? '';
    this.lithologyCategoryName = map['lithologyCategoryName'] ?? '';
    this.lithContactName = map['lithContactName'] ?? '';
    this.lithLocalName = map['lithLocalName'] ?? '';
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

  Future<List<LithologyModel>> fnObtenerRegistrosPorCollarId(
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
            "	IFNULL(ls5.LithSpec, '') AS lithSpec5Name, " +
            "	IFNULL(ls4.LithSpec, '') AS lithSpec4Name, " +
            "	IFNULL(ls3.LithSpec, '') AS lithSpec3Name, " +
            "	IFNULL(ls2.LithSpec, '') AS lithSpec2Name, " +
            "	IFNULL(ls1.LithSpec, '') AS lithSpec1Name, " +
            "	IFNULL(l5a.LithAbund, '') AS lithAbund5Name, " +
            "	IFNULL(l4a.LithAbund, '') AS lithAbund4Name, " +
            "	IFNULL(l3a.LithAbund, '') AS lithAbund3Name, " +
            "	IFNULL(l2a.LithAbund, '') AS lithAbund2Name, " +
            "	IFNULL(l1a.LithAbund, '') AS lithAbund1Name, " +
            "	IFNULL(lm5.LithMod, '') AS lithMod5Name, " +
            "	IFNULL(lm4.LithMod, '') AS lithMod4Name, " +
            "	IFNULL(lm3.LithMod, '') AS lithMod3Name, " +
            "	IFNULL(lm2.LithMod, '') AS lithMod2Name, " +
            "	IFNULL(lm1.LithMod, '') AS lithMod1Name, " +
            "	IFNULL(lcm5.LithColorMod, '') AS lithColorMod5Name, " +
            "	IFNULL(lcm4.LithColorMod, '') AS lithColorMod4Name, " +
            "	IFNULL(lcm3.LithColorMod, '') AS lithColorMod3Name, " +
            "	IFNULL(lcm2.LithColorMod, '') AS lithColorMod2Name, " +
            "	IFNULL(lcm1.LithColorMod, '') AS lithColorMod1Name, " +
            "	IFNULL(lc5.LithColor, '') AS lithColor5Name, " +
            "	IFNULL(lc4.LithColor, '') AS lithColor4Name, " +
            "	IFNULL(lc3.LithColor, '') AS lithColor3Name, " +
            "	IFNULL(lc2.LithColor, '') AS lithColor2Name, " +
            "	IFNULL(lc1.LithColor, '') AS lithColor1Name, " +
            "	IFNULL(C.Lithology_Category, '') AS lithologyCategoryName, " +
            "	IFNULL(LC.LithContact, '') AS lithContactName, " +
            "	IFNULL(LL.LithLocal, '')  AS lithLocalName, " +
            "	L.* " +
            "FROM $tbName AS L " +
            "	LEFT JOIN cat_lithlocal AS LL ON LL.Id = L.Lithology_Local " +
            "	LEFT JOIN cat_lithcontact AS LC ON LC.Id = L.LithContact " +
            "	LEFT JOIN cat_lithology_category AS C ON C.Id = L.Lithology_Category " +
            "	LEFT JOIN cat_lith1abund AS l1a ON l1a.Id = L.Lith1Abund " +
            "	LEFT JOIN cat_lith1abund AS l2a ON l2a.Id = L.Lith2Abund " +
            "	LEFT JOIN cat_lith1abund AS l3a ON l3a.Id = L.Lith3Abund " +
            "	LEFT JOIN cat_lith1abund AS l4a ON l4a.Id = L.Lith4Abund " +
            "	LEFT JOIN cat_lith1abund AS l5a ON l5a.Id = L.Lith5Abund " +
            "	LEFT JOIN cat_lithspec AS ls1 ON ls1.Id = L.Lith1Spec " +
            "	LEFT JOIN cat_lithspec AS ls2 ON ls2.Id = L.Lith2Spec " +
            "	LEFT JOIN cat_lithspec AS ls3 ON ls3.Id = L.Lith3Spec " +
            "	LEFT JOIN cat_lithspec AS ls4 ON ls4.Id = L.Lith4Spec " +
            "	LEFT JOIN cat_lithspec AS ls5 ON ls5.Id = L.Lith5Spec " +
            "	LEFT JOIN cat_lithmod AS lm1 ON lm1.Id = L.Lith1Mod " +
            "	LEFT JOIN cat_lithmod AS lm2 ON lm2.Id = L.Lith2Mod " +
            "	LEFT JOIN cat_lithmod AS lm3 ON lm3.Id = L.Lith3Mod " +
            "	LEFT JOIN cat_lithmod AS lm4 ON lm4.Id = L.Lith4Mod " +
            "	LEFT JOIN cat_lithmod AS lm5 ON lm5.Id = L.Lith5Mod " +
            "	LEFT JOIN cat_lithcolormod AS lcm1 ON lcm1.Id = L.Lith1ColorMod " +
            "	LEFT JOIN cat_lithcolormod AS lcm2 ON lcm2.Id = L.Lith2ColorMod " +
            "	LEFT JOIN cat_lithcolormod AS lcm3 ON lcm3.Id = L.Lith3ColorMod " +
            "	LEFT JOIN cat_lithcolormod AS lcm4 ON lcm4.Id = L.Lith4ColorMod " +
            "	LEFT JOIN cat_lithcolormod AS lcm5 ON lcm5.Id = L.Lith5ColorMod " +
            "	LEFT JOIN cat_lithcolor AS lc1 ON lc1.Id = L.Lith1Color " +
            "	LEFT JOIN cat_lithcolor AS lc2 ON lc2.Id = L.Lith2Color " +
            "	LEFT JOIN cat_lithcolor AS lc3 ON lc3.Id = L.Lith3Color " +
            "	LEFT JOIN cat_lithcolor AS lc4 ON lc4.Id = L.Lith4Color " +
            "	LEFT JOIN cat_lithcolor AS lc5 ON lc5.Id = L.Lith5Color " +

            "WHERE L.IdCollar = $collarId  AND L.status = 1 " +
            "ORDER BY GeolFrom ASC");
      });
    }
    LithologyModel item;
    return List.generate(maps.length, (i) {
      item = new LithologyModel();
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
