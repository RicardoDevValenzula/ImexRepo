import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'APIController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CollarController extends DBDataEntry {
  APIController _apiController = new APIController();

  Future<ResultModel> getCollarsForUser() async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpGetMultipart(
          dotenv.env['URL_BASE'] ?? '', 'sincronizar/collars_x_usuario',
          parameters: {}, ssl: ssl, headers: {'Authorization': '$token'});
      if (response['result']) {
        //result = ResultModel.fromJson(response['body']);
        result = ResultModel.fromJson(response['body']);
      } else {
        result = ResultModel.fromJson(response);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<ResultModel> getCollarsForUserAndSubProject(int subProyectoId) async {
    ResultModel result = new ResultModel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPostMultipart(
          dotenv.env['URL_BASE'] ?? '',
          'sincronizar/collars_x_usuario_and_subproject',
          parameters: {'sub_proyecto_id': '$subProyectoId'},
          ssl: ssl,
          headers: {'Authorization': '$token'});
      if (response['result']) {
        //result = ResultModel.fromJson(response['body']);
        result = ResultModel.fromJson(response['body']);
      } else {
        result = ResultModel.fromJson(response);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }
}
