import 'package:data_entry_app/controllers/DBDataEntry.dart';

class CompanyDrillModel extends DBDataEntry {
  int id = 0;
  String companyDrill = '';
  int repetitions = 0;
  int status = 0;

  String tbName = 'cat_companydrill';

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'AzimuthType': companyDrill,
      'repetitions': repetitions,
      'status': status
    };
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.companyDrill = map['AzimuthType'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
    this.status = map['status'] ?? 0;
  }
}
