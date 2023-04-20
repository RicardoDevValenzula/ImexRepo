import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';

class SamplesQCModel extends DBDataEntry{
  int id =0;
  int idCollar=0;
  int status=0;
  dynamic CheckId = '';
  dynamic SampleID = '';
  dynamic QCType = 0;
  dynamic StandardID = 0;
  dynamic Lab=0;
  dynamic QCComment='';

  String tbName = 'tb_sampqc';

  Map<String, dynamic> toMap(){
    return{
      'Id':id,
      'IdCollar': idCollar,
      'CheckId': CheckId,
      'SampleId': SampleID,
      'QCType': QCType,
      'StandardID': StandardID,
      'Lab': Lab,
      'QCComment': QCComment,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map){
    this.id = map['Id'] ?? 0;
    this.idCollar = map['IdCollar'] ?? 0;
    this.CheckId = map['CheckId'] ?? '';
    this.SampleID = map['SampleID'] ?? '';
    this.QCType = map['QCType'] ?? '';
    this.StandardID = map['StandardName'] ?? '';
    this.Lab = map['Lab'] ?? 0;
    this.QCComment = map['QCComment'] ?? '';
  }

  Future<int> insertarModelo() async{
    int result = 0;
    int newId = await fnObtnerNuevoId(this.tbName);
    await database.then((db) async{
      this.id= newId;
      result = await db.insert(this.tbName, toMap());
    });
    return result;
  }



  Future<List<SamplesQCModel>> fnObtenerRegistrosPorCollarId
      ({required int collarId, String? orderByCampo}) async{
    List<Map<String, dynamic>> maps=[];
    bool existe = await fnExiste(this.tbName);
    if(existe){
      await database.then((db) async{
        maps= await db.rawQuery(
          "SELECT "+
            "tb_sampqc.*, "+
            "cat_qctype.QCType, " +
            "cat_standarid.StandarId as StandardName, "+
            "cat_lab.Lab " +
            "FROM tb_sampqc "+
            "LEFT JOIN cat_qctype on cat_qctype.id = tb_sampqc.QCType "+
            "LEFT JOIN cat_standarid on cat_standarid.Id = tb_sampqc.StandardID "+
            "LEFT JOIN cat_lab on cat_lab.id = tb_sampqc.Lab "+
            "where tb_sampqc.IdCollar = ? AND  tb_sampqc.status = ?"+
              (orderByCampo != null ? "ORDER BY $orderByCampo ASC" : ""),
            [collarId, 1]);
      });
    }
    SamplesQCModel item;
    return List.generate(maps.length, (i) {
      item= new SamplesQCModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<bool> existeSampleQC (String sample, int collarId) async{
    bool respuesta = await database.then((value) async {
      List<Map<String, Object?>> resultado = await value.rawQuery(
          "SELECT * FROM tb_sampqc WHERE IdCollar = ${collarId} AND CheckId= '${sample}' AND status=1");
      return (resultado.length > 0 ? true : false);
    }, onError: (error) {
      return false;
    });
    return respuesta;
  }

  Future<bool> existeSample (String sample, int collarId) async{
    bool respuesta = await database.then((value) async {
      List<Map<String, Object?>> resultado = await value.rawQuery(
          "SELECT * FROM tb_sample WHERE IdCollar = ${collarId} AND idSample= '${sample}' AND status=1");
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

  Future<dynamic> fnBuscarRegistroQC({ required String nombreTabla,
  required campo}) async{
    List<Map<String, dynamic>> maps=[];
    await database.then((value) async{
      maps = await value
          .rawQuery('');
    });
  }

}