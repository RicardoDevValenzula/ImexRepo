import 'package:data_entry_app/controllers/DBDataEntry.dart';

class CaseDiameterModel extends DBDataEntry {
  int id = 0;
  String caseDiameter = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_casediameter';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'CaseDiameter': caseDiameter,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.caseDiameter = map['CaseDiameter'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
