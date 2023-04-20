import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/ProjectModel.dart';

class SubProjectModel extends DBDataEntry {
  int id = 0;
  String name = '';
  int idProject = 0;
  int status = 0;
  // #PROJECT.
  String projectName = '';

  String tbName = 'tb_subprojects';

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.name = map['name'] ?? '';
    this.idProject = map['id_project'] ?? 0;
    this.status = map['status'] ?? 0;
    // #PROJECT.
    this.projectName = map['projectName'] ?? 0;
  }

  Future<List<SubProjectModel>> getAll(int projectId) async {
    List<Map<String, dynamic>> maps = [];
    await database.then((db) async {
      maps = await db.rawQuery(
          "SELECT sp.*, p.name AS projectName " +
              "FROM $tbName AS sp " +
              "INNER JOIN ${ProjectModel().tbName} AS p ON p.id = sp.id_project " +
              "WHERE sp.id_project = ?",
          [projectId]);
    });
    SubProjectModel item;
    return List.generate(maps.length, (i) {
      item = new SubProjectModel();
      item.fromMap(maps[i]);
      return item;
    });
  }
}
