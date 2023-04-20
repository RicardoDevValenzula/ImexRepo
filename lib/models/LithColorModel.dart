import 'package:data_entry_app/controllers/DBDataEntry.dart';

class LithColorModel extends DBDataEntry {
  int id = 0;
  String lithColor = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lithcolor';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithColor': lithColor,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithColor = map['LithColor'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
