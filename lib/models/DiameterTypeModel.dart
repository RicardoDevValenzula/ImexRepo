import 'package:data_entry_app/controllers/DBDataEntry.dart';

class DiameterTypeModel extends DBDataEntry {
  int id = 0;
  String diameterType = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_diametertype';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'diameterType': diameterType,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.diameterType = map['diameterType'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
