import 'package:data_entry_app/models/ResultModel.dart';
import 'APIController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserController {
  APIController _apiController = new APIController();

  Future<ResultModel> login(String username, String password) async {
    ResultModel result = new ResultModel();
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPost(
          dotenv.env['URL_BASE'] ?? '', 'api/sign_in',
          parameters: {'username': username, 'password': password},
          ssl: ssl,
          headers: {});
      if (response['result']) {
        result = ResultModel.fromJson(response['body']);
        //result.init(true, '', response['body']);
      } else {
        result = ResultModel.fromJson(response);
        //result.init(false, response['message'], null);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }

  Future<ResultModel> renewPassword(String email) async {
    ResultModel result = new ResultModel();
    try {
      bool ssl =
          ((dotenv.env['SSL_API_HOST'] ?? '').toLowerCase().trim() == 'true'
              ? true
              : false);
      Map<String, dynamic> response = await _apiController.httpPost(
          dotenv.env['URL_BASE'] ?? '', 'api/JwtAuth/newPassword',
          parameters: {'email': email}, ssl: ssl, headers: {});
      if (response['result']) {
        result.init(true, '', response['body']);
      } else {
        result.init(false, response['message'], null);
      }
    } on Exception catch (ex) {
      result.init(false, "Error: $ex", null);
    }
    return result;
  }
}
