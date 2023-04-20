import 'package:data_entry_app/controllers/DBDataEntry.dart';

class AzimuthTypeModel extends DBDataEntry {
  int id = 0;
  String azimuthType = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_azimuthtype';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'AzimuthType': azimuthType,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.azimuthType = map['AzimuthType'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
