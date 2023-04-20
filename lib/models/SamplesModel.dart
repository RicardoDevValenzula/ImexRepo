import 'package:data_entry_app/controllers/DBDataEntry.dart';

import '../controllers/GeneralController.dart';

class SamplesModel extends DBDataEntry {
  int id = 0;
  int idCollar = 0;
  double geolFrom = 0.0;
  double geolTo = 0.0;
  double chk = 0.0;
  dynamic idSample = 0;
  dynamic aquifer = 0;
  dynamic comments = 0;
  dynamic lab = 0;
  dynamic disparchID = 0;
  dynamic dispatchDate = 0;
  dynamic drillSampleType = 0;
  dynamic sampleMass = 0;
  dynamic sampler = 0;
  dynamic sampDate = '';
  dynamic waterSampType = 0;
  dynamic waterContainer = 0;
  dynamic waterWellType = 0;
  dynamic waterSampEquip = 0;
  dynamic waterVolume = 0;
  dynamic waterColor = 0;
  dynamic waterSmell = 0;
  dynamic conductivityField = 0;
  dynamic tdsField = 0;
  dynamic tempField = 0;
  dynamic phField = 0;
  dynamic ehField = 0;
  dynamic densityField = 0;
  dynamic naclField = 0;
  int status = 0;
  // #CAMPOS DE OTRAS TABLAS.
  dynamic aquiferName = '';
  dynamic drillSampleTypeName = '';
  dynamic samplerName = '';
  dynamic waterSampTypeName = '';
  dynamic waterContainerName = '';
  dynamic waterWellTypeName = '';
  dynamic waterSampEquipName = '';
  dynamic waterVolumeName = '';
  dynamic waterColorName = '';
  dynamic waterSmellName = '';

  String tbName = 'tb_sample';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'IdCollar': idCollar,
      'GeolFrom': geolFrom,
      'GeolTo': geolTo,
      'Chk': chk,
      'idSample': idSample,
      'Aquifer': aquifer,
      'Samp_Comments': comments,
      'Lab': lab,
      'DisparchID': disparchID,
      'DispatchDate': dispatchDate,
      'Drill_SampleType': drillSampleType,
      'Sample_Mass': sampleMass,
      'Sampler': sampler,
      'Samp_Date': sampDate,
      'WaterSampType': waterSampType,
      'WaterContainer': waterContainer,
      'WaterWellType': waterWellType,
      'WaterSampEquip': waterSampEquip,
      'WaterVolume': waterVolume,
      'WaterColor': waterColor,
      'WaterSmell': waterSmell,
      'Conductivity_Field': conductivityField,
      'TDS_Field': tdsField,
      'Temp_Field': tempField,
      'pH_Field': phField,
      'Eh_Field': ehField,
      'Density_Field': densityField,
      'NaCl_Field': naclField,
      'status': status,
      // #CAMPOS DE OTRAS TABLAS.
      'AquiferName': aquiferName,
      'DrillSampTypeName': drillSampleTypeName,
      'SamplerName': samplerName,
      'WaterSampTypeName': waterSampTypeName,
      'WaterContainerName': waterContainerName,
      'WaterWellTypeName': waterWellTypeName,
      'WaterSampEquipName': waterSampEquipName,
      'WaterVolumeName': waterVolumeName,
      'WaterColorName': waterColorName,
      'WaterSmellName': waterSmellName
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.geolFrom = map['GeolFrom'] ?? 0.0;
    this.geolTo = map['GeolTo'] ?? 0.0;
    this.chk = map['Chk'] ?? 0.0;
    this.idSample = map['idSample'] ?? '';
    this.aquifer = map['Aquifer'] ?? 0;
    this.comments = map['Samp_Comments'] ?? '';
    this.lab = map['Lab'] ?? 0;
    this.disparchID = map['DisparchID'] ?? '';
    this.dispatchDate = map['DispatchDate'] ?? '';
    this.drillSampleType = map['Drill_SampleType'] ?? 0;
    this.sampleMass = map['Sample_Mass'] ?? 0.0;
    this.sampler = map['Sampler'] ?? 0;
    this.sampDate = map['Samp_Date'] ?? '';
    this.waterSampType = map['WaterSampType'] ?? 0;
    this.waterContainer = map['WaterContainer'] ?? 0;
    this.waterWellType = map['WaterWellType'] ?? 0;
    this.waterSampEquip = map['WaterSampEquip'] ?? 0;
    this.waterVolume = map['WaterVolume'] ?? 0;
    this.waterColor = map['WaterColor'] ?? 0;
    this.waterSmell = map['WaterSmell'] ?? 0;
    this.conductivityField = map['Conductivity_Field'] ?? 0.0;
    this.tdsField = map['TDS_Field'] ?? 0.0;
    this.tempField = map['Temp_Field'] ?? 0.0;
    this.phField = map['pH_Field'] ?? 0.0;
    this.ehField = map['Eh_Field'] ?? 0.0;
    this.densityField = map['Density_Field'] ?? 0.0;
    this.naclField = map['NaCl_Field'] ?? 0.0;
    this.status = map['status'] ?? 0;
    // #CAMPOS DE OTRAS TABLAS.
    this.aquiferName = map['AquiferName'] ?? '';
    this.drillSampleTypeName = map['DrillSampTypeName'] ?? '';
    this.samplerName = map['SamplerName'] ?? '';
    this.waterSampTypeName = map['WaterSampTypeName'] ?? '';
    this.waterContainerName = map['WaterContainerName'] ?? '';
    this.waterWellTypeName = map['WaterWellTypeName'] ?? '';
    this.waterSampEquipName = map['WaterSampEquipName'] ?? '';
    this.waterVolumeName = map['WaterVolumeName'] ?? '';
    this.waterColorName = map['WaterColorName'] ?? '';
    this.waterSmellName = map['WaterSmellName'] ?? '';
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

  Future<List<SamplesModel>> fnObtenerRegistrosPorCollarId(
      {required int collarId, String? orderByCampo}) async {
    List<Map<String, dynamic>> maps = [];
    bool existe = await fnExiste(this.tbName);
    if (existe) {
      await database.then((db) async {
        maps = await db.rawQuery(
            "SELECT " +
                "	S.*, " +
                "	aq.Aquifer AS AquiferName, " +
                "	dst.DrillSampType AS DrillSampTypeName, " +
                "	sp.geologist AS SamplerName, " +
                "	wst.WaterSampType AS WaterSampTypeName, " +
                "	wc.WaterContainer AS WaterContainerName, " +
                "	wwt.WaterWellType AS WaterWellTypeName, " +
                "	wse.WaterSampEquip AS WaterSampEquipName, " +
                "	wv.WaterVolume AS WaterVolumeName, " +
                "	wcr.WaterColor AS WaterColorName, " +
                "	ws.WaterSmell AS WaterSmellName, " +
                " cl.Lab as Lab "+
                "FROM tb_sample AS S " +
                "	LEFT JOIN cat_aquifer AS aq ON aq.Id = S.Aquifer " +
                "	LEFT JOIN cat_drillsamptype AS dst ON dst.Id = S.Drill_SampleType " +
                "	LEFT JOIN cat_geologist AS sp ON sp.Id = S.Sampler " +
                "	LEFT JOIN cat_watersamptype AS wst ON wst.Id = S.WaterSampType " +
                "	LEFT JOIN cat_watercontainer AS wc ON wc.Id = S.WaterContainer " +
                "	LEFT JOIN cat_waterwelltype AS wwt ON wwt.Id = S.WaterWellType " +
                "	LEFT JOIN cat_watersampequip AS wse ON wse.Id = S.WaterSampEquip " +
                "	LEFT JOIN cat_watervolume AS wv ON wv.Id = S.WaterVolume " +
                "	LEFT JOIN cat_watercolor AS wcr ON wcr.Id = S.WaterColor " +
                "	LEFT JOIN cat_watersmell AS ws ON ws.Id = S.WaterSmell " +
                " LEFT JOIN cat_lab AS cl ON cl.id = S.Lab " +
                "WHERE S.IdCollar = ?  AND S.status= ? " +
                (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId,1]);
      });
    }
    SamplesModel item;
    return List.generate(maps.length, (i) {
      item = new SamplesModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<bool> existeSample (String idSample, int collarId) async{
    bool respuesta = await database.then((value) async {
      List<Map<String, Object?>> resultado = await value.rawQuery(
          "SELECT * FROM tb_sample WHERE IdCollar = ${collarId} AND idSample= '${idSample}' ");
      return (resultado.length > 0 ? true : false);
    }, onError: (error) {
      return false;
    });
    return respuesta;
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
