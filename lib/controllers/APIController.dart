import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';

class APIController {
  int timeout = 60;

  /* #POST */
  Future<Map<String, dynamic>> httpPost(String urlBase, String path,
      {required Map<String, dynamic> parameters,
      bool ssl = true,
      required Map<String, String> headers}) async {
    Uri url;
    var body, jsonResponse;
    Response response;
    bool result = true; //await DataConnectionChecker().hasConnection;
    if (result == true) {
      try {
        url = Uri.parse(urlBase + path);
        //Uri url = new Uri.http(urlBase, path, parameters);
        response = await http
            .post(url, body: parameters, headers: headers)
            .timeout(Duration(seconds: timeout));
        if (response.statusCode == 200) {
          body = jsonDecode(response.body);
          jsonResponse = {"result": true, "body": body, "message": ""};
        } else if (response.statusCode == 401) {
          body = jsonDecode(response.body);
          jsonResponse = {"result": false, "message": body['message']};
        } else {
          body = jsonDecode(response.body);
          jsonResponse = {"result": false, "message": response.body};
        }
      } on TimeoutException catch (ex) {
        jsonResponse = {"result": false, "message": "Timeout Error: [$ex]"};
      } on SocketException catch (ex) {
        jsonResponse = {"result": false, "message": "Socket Error: $ex"};
      } on Error catch (ex) {
        jsonResponse = {"result": false, "message": "General Error: [$ex]"};
      } on Exception catch (ex) {
        jsonResponse = {"result": false, "message": "Exception Error: [$ex]"};
      }
    } else {
      jsonResponse = {"result": false, "message": "No internet"};
      //print(DataConnectionChecker().lastTryResults);
    }
    return jsonResponse;
  }

  Future<Map<String, dynamic>> httpPostMultipart(String urlBase, String path,
      {required Map<String, String> parameters,
      bool ssl = true,
      required Map<String, String> headers}) async {
    log('${path}');
    log('${parameters}');
    Uri url;
    var body, jsonResponse;
    http.StreamedResponse response;
    bool result = true;
    if (result == true) {
      try {
        url = Uri.parse(urlBase + path);
        //print(url);
        var request = http.MultipartRequest('POST', url);
        request.headers.addAll(headers);
        request.fields.addAll(parameters);
        //print(request.fields);
        response = await request.send().timeout(Duration(seconds: timeout));
       // print(response.statusCode);
        if (response.statusCode == 200) {
          body = jsonDecode(await response.stream.bytesToString());
          jsonResponse = {"result": true, "body": body, "message": ""};
        } else if (response.statusCode == 401) {
          body = jsonDecode(await response.stream.bytesToString());
          jsonResponse = {"result": false, "message": body['message']};
        } else {
          body = jsonDecode(await response.stream.bytesToString());
          jsonResponse = {"result": false, "message": body};
        }
      } on TimeoutException catch (ex) {
        jsonResponse = {"result": false, "message": "Timeout Error: [$ex]"};
      } on SocketException catch (ex) {
        jsonResponse = {"result": false, "message": "Socket Error: $ex"};
      } on Error catch (ex) {
        jsonResponse = {"result": false, "message": "General Error: [$ex]"};
      } on Exception catch (ex) {
        jsonResponse = {"result": false, "message": "Exception Error: [$ex]"};
        print(ex);
      }
    } else {
      jsonResponse = {"result": false, "message": "No internet"};
    }
    return jsonResponse;
  }

  Future<Map<String, dynamic>> httpGetMultipart(String urlBase, String path,
      {required Map<String, String> parameters,
      bool ssl = true,
      required Map<String, String> headers}) async {
    Uri url;
    var body, jsonResponse;
    http.StreamedResponse response;
    bool result = true;
    if (result == true) {
      try {
        url = Uri.parse(urlBase + path);
        var request = http.MultipartRequest('GET', url);
        request.headers.addAll(headers);
        request.fields.addAll(parameters);
        response = await request.send().timeout(Duration(seconds: timeout));
        if (response.statusCode == 200) {
          body = jsonDecode(await response.stream.bytesToString());
          jsonResponse = {"result": true, "body": body, "message": ""};
        } else if (response.statusCode == 401) {
          body = jsonDecode(await response.stream.bytesToString());
          jsonResponse = {"result": false, "message": body['message']};
        } else {
          body = jsonDecode(await response.stream.bytesToString());
          jsonResponse = {"result": false, "message": body};
        }
      } on TimeoutException catch (ex) {
        log("Timeout Error: [$ex]");
        jsonResponse = {"result": false, "message": "Timeout Error"};
      } on SocketException catch (ex) {
        log("Socket Error: [$ex]");
        jsonResponse = {"result": false, "message": "Socket Error"};
      } on Error catch (ex) {
        log("General Error: [$ex]");
        jsonResponse = {"result": false, "message": "General Error"};
      } on Exception catch (ex) {
        log("Exception Error: [$ex]");
        jsonResponse = {"result": false, "message": "Exception Error"};
      }
    } else {
      jsonResponse = {"result": false, "message": "No internet"};
    }
    return jsonResponse;
  }
}
