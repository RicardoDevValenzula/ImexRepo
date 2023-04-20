import 'package:data_entry_app/controllers/DBDataEntry.dart';

class WaterPresentModel extends DBDataEntry {
  int id = 0;
  String waterPresent = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_waterpresent';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'waterPresent': waterPresent,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.waterPresent = map['waterPresent'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
