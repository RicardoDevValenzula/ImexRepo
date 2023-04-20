import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:sqflite/sqflite.dart';

class TablaSincroLocalModel {
  int id = 0;
  int tbSincronizacionAppId = 0;
  int tipoTablaId = 0;
  String nombreTabla = '';
  int estatusId = 0;
  int orderTable = 0;
  String createdAt = '';
  String updatedAt = '';

  String tbName = 'tb_sincronizacion_local_app';
  DBDataEntry dataEntry = new DBDataEntry();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tb_sincronizacion_app_id': tbSincronizacionAppId,
      'tipo_tabla_id': tipoTablaId,
      'nombre_tabla': nombreTabla,
      'estatus_id': estatusId,
      'order_table': orderTable,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.tbSincronizacionAppId = map['tb_sincronizacion_app_id'];
    this.tipoTablaId = map['tipo_tabla_id'];
    this.nombreTabla = map['nombre_tabla'];
    this.estatusId = map['estatus_id'];
    this.orderTable = map['order_table'];
    this.createdAt = map['created_at'];
    this.updatedAt = map['updated_at'];
  }

  Future<int> insert() async {
    Database db = await dataEntry.database;
    int result = await db.insert(
      tbName,
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<TablaSincroLocalModel>> getAll() async {
    List<Map<String, dynamic>> maps = [];
    await dataEntry.database.then((db) async {
      maps = await db.query(tbName);
    });
    TablaSincroLocalModel item;
    return List.generate(maps.length, (i) {
      item = new TablaSincroLocalModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<TablaSincroLocalModel>> fnObtenerTablasTipoPestanas(
      {String? orderBy}) async {
    List<Map<String, dynamic>> maps = [];
    await dataEntry.database.then((db) async {
      maps = await db.query(this.tbName,
          where: 'tipo_tabla_id = ?', whereArgs: [2], groupBy: orderBy);
    });
    TablaSincroLocalModel item;
    return List.generate(maps.length, (i) {
      item = new TablaSincroLocalModel();
      item.fromMap(maps[i]);
      return item;
    });
  }

  Future<List<Map<String, dynamic>>> fnObtenerCamposPorTabla(
      String tbName) async {
    List<Map<String, dynamic>> maps = [];
    await dataEntry.database.then((db) async {
      maps = await db.rawQuery("pragma table_info('$tbName')");
    });
    return maps;
  }

  Future<int> fnEliminarRegistro(int id) async {
    int result = 0;
    await dataEntry.database.then((db) async {
      result = await db.delete(this.tbName, where: 'id = ?', whereArgs: [id]);
    });
    return result;
  }
}
