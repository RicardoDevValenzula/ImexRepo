import 'package:data_entry_app/controllers/DBDataEntry.dart';

class CatalogModel extends DBDataEntry {
  int id = 0;
  String label = '';
  String icon = '';
  int status = 0;

  Map<String, dynamic> toMap() {
    return {'value': id, 'label': label, 'icon': icon};
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.label = map['label'] ?? '';
    this.icon = map['icon'] ?? 0;
  }
}
