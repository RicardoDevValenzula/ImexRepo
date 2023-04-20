import 'package:data_entry_app/controllers/DBDataEntry.dart';

class CoordSystModel extends DBDataEntry {
  int id = 0;
  String coordSyst = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_coordsyst';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coordSyst': coordSyst,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.coordSyst = map['coordSyst'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
