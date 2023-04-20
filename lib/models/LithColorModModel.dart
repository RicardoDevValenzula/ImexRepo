import 'package:data_entry_app/controllers/DBDataEntry.dart';

class LithColorModModel extends DBDataEntry {
  int id = 0;
  String lithColorMod = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lithcolormod';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithColorMod': lithColorMod,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithColorMod = map['LithColorMod'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
