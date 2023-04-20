class ResultModel {
  late bool status;
  late String message;
  dynamic data;
  late int code;

  ResultModel() {
    this.status = false;
    this.message = '';
    this.data = '';
    this.code = 0;
  }

  init(bool _status, String _message, dynamic _data) {
    this.status = _status;
    this.message = _message;
    this.data = _data;
  }

  ResultModel.fromJson(Map json) {
    this.status = json['status'] ?? false;
    this.message = json['message'] ?? '';
    this.data = json['data'] ?? '';
    this.code = json['code'] ?? 500;
  }
}
