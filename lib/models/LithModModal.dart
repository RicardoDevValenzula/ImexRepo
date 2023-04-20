import 'package:data_entry_app/controllers/DBDataEntry.dart';

class LithModModal extends DBDataEntry {
  int id = 0;
  String lithMod = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lithmod';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithMod': lithMod,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithMod = map['LithMod'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
