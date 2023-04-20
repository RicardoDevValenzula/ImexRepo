import 'package:data_entry_app/controllers/DBDataEntry.dart';

class DrillTypeModel extends DBDataEntry {
  int id = 0;
  String drillType = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_drilltype';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'drilltype': drillType,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.drillType = map['drilltype'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
