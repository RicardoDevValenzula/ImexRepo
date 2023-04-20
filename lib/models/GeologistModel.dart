import 'package:data_entry_app/controllers/DBDataEntry.dart';

class GeologistModel extends DBDataEntry {
  int id = 0;
  String geologist = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_geologist';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'geologist': geologist,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.geologist = map['geologist'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
