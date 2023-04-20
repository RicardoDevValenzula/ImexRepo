import 'package:data_entry_app/controllers/DBDataEntry.dart';

class LithContactModal extends DBDataEntry {
  int id = 0;
  String lithContact = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_lithcontact';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'LithContact': lithContact,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.lithContact = map['LithContact'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
