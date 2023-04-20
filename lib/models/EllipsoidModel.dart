import 'package:data_entry_app/controllers/DBDataEntry.dart';

class EllipsoidModel extends DBDataEntry {
  int id = 0;
  String ellipsoid = '';

  String tbName = 'cat_ellipsoid';

  Map<String, dynamic> toMap() {
    return {'id': id, 'ellipsoid': ellipsoid};
  }

  fromMap(Map<String, dynamic> map) {
    this.id = map['id'] ?? 0;
    this.ellipsoid = map['ellipsoid'] ?? '';
  }
}
