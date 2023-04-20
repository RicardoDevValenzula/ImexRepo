import 'package:data_entry_app/controllers/DBDataEntry.dart';

class RigIdModel extends DBDataEntry {
  int id = 0;
  String rigId = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_rigid';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'rigId': rigId,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.rigId = map['rigId'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
