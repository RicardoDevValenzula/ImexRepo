import 'package:data_entry_app/controllers/DBDataEntry.dart';

class GridNameModel extends DBDataEntry {
  int id = 0;
  String gridname = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_gridname';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gridname': gridname,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.gridname = map['gridname'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
