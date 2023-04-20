import 'package:data_entry_app/controllers/DBDataEntry.dart';

class LithLocalModel extends DBDataEntry {
  int id = 0;
  String lithLocal = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lithlocal';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithLocal': lithLocal,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithLocal = map['LithLocal'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
