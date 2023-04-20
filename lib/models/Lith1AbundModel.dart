import 'package:data_entry_app/controllers/DBDataEntry.dart';

class Lith1AbundModel extends DBDataEntry {
  int id = 0;
  String lithAbund = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lith1abund';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithAbund': lithAbund,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithAbund = map['LithAbund'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
