import 'package:data_entry_app/controllers/DBDataEntry.dart';

class CountryModel extends DBDataEntry {
  int id = 0;
  String country = '';
  int repetitions = 0;

  String tbName = 'cat_country';

  Map<String, dynamic> toMap() {
    return {'Id': id, 'country': country, 'repetitions': repetitions};
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['Id'] ?? 0;
    this.country = map['country'] ?? '';
    this.repetitions = map['repetitions'] ?? 0;
  }
}
