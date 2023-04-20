import 'package:data_entry_app/controllers/DBDataEntry.dart';

class LithSpecModel extends DBDataEntry {
  int id = 0;
  String lithSpec = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lithspec';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithSpec': lithSpec,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithSpec = map['LithSpec'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
