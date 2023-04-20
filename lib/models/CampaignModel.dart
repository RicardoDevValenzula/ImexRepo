import 'package:data_entry_app/controllers/DBDataEntry.dart';

class CampaignModel extends DBDataEntry {
  int id = 0;
  String campaign = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_campaign';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'campaign': campaign,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.campaign = map['campaign'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
