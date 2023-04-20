import 'dart:async';
import 'dart:io';
import 'dart:isolate';

class BackgroundController {
  // #CONEXION DE INTERNTER.
  static int _conexion = 0;
  static Isolate? _isolateConexion;
  static ReceivePort _receivePortConexion = ReceivePort();

  static Isolate? get isolateConexion => _isolateConexion;
  static ReceivePort get receivePortConexion => _receivePortConexion;
  static int get conexion => _conexion;
  static set conexion(int value) {
    _conexion = value;
  }

  static Future<void> initChecarConexionIternet() async {
    try {
      _isolateConexion?.kill();
      _isolateConexion = await Isolate.spawn<SendPort>(
          _checkConnection, _receivePortConexion.sendPort);
    } on IsolateSpawnException catch (e) {
      print(e);
    }
  }

  static void _checkConnection(SendPort sendPort) async {
    bool conected = false;
    Timer.periodic(Duration(seconds: 3), (_) async {
      final result;
      try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          conected = true;
        }
      } catch (ex) {
        conected = false;
      }
      conexion = (conected ? 1 : 0);

      sendPort.send(conected);
    });
  }

  // #HILO DE DATOS BASE(COLLAR).
  static int _datosBase = 0;
  static Isolate? _isolateDatosBase;
  static ReceivePort _receivePortDatosBase = ReceivePort();

  static Isolate? get isolateDatosBase => _isolateDatosBase;
  static ReceivePort get receivePortDatosBase => _receivePortDatosBase;
  static int get datosBase => _datosBase;
  static set datosBase(int value) {
    _datosBase = value;
  }

  static Future<void> initDatosBase(Map<String, bool> listaHolds) async {
    try {
      _isolateDatosBase?.kill();
      var param =
          new ParametroDatosBase(listaHolds, _receivePortDatosBase.sendPort);
      _isolateDatosBase =
          await Isolate.spawn<ParametroDatosBase>(_checkDatosBase, param);
    } on IsolateSpawnException catch (e) {
      print(e);
    }
  }

  static void _checkDatosBase(ParametroDatosBase param) async {
    param.sendPort.send(param.lstHoldIds);
  }

  // #HILO DE DATOS BASE(COLLAR).
  static int _projects = -1;
  static Isolate? _isolateProjects;
  static ReceivePort _receivePortProjects = ReceivePort();

  static Isolate? get isolateProjects => _isolateProjects;
  static ReceivePort get receivePortProjects => _receivePortProjects;
  static int get projects => _projects;
  static set projects(int value) {
    _projects = value;
  }

  static Future<void> initProjects() async {
    try {
      _isolateDatosBase?.kill();
      var param = new ParametroProyectos(Map(), _receivePortProjects.sendPort);
      _isolateDatosBase =
          await Isolate.spawn<ParametroProyectos>(_checkProjects, param);
    } on IsolateSpawnException catch (e) {
      print(e);
    }
  }

  static void _checkProjects(ParametroProyectos param) async {
    param.sendPort.send(param.lstHoldIds);
  }
}

class ParametroDatosBase {
  Map<String, bool> lstHoldIds = Map();
  late SendPort sendPort;

  ParametroDatosBase(this.lstHoldIds, this.sendPort);
}

class ParametroProyectos {
  Map<String, bool> lstHoldIds = Map();
  late SendPort sendPort;

  ParametroProyectos(this.lstHoldIds, this.sendPort);
}
