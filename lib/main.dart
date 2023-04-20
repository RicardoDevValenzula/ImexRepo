import 'dart:async';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/DatosBaseController.dart';
import 'package:data_entry_app/pages/loginPage.dart';
import 'package:data_entry_app/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'controllers/BackgroundController.dart';
import 'controllers/CatalogoController.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
   
  // #INICIALIZAR HILOS.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: DataEntryTheme.deGrayMedium,
      ),
      title: 'Data Entry',
      //theme: DataEntryTheme.lightTheme,
      home: Init(),
    );
  }
}

class Init extends StatefulWidget {
  @override
  _InitState createState() => _InitState();
}

class _InitState extends State<Init> {
  final _baseController = new DatosBaseController();
  final _catalogoController = new CatalogoController();
  final _dbDataEntry = new DBDataEntry();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    init();
    // #INICIALIZAR TABLAS.
    _dbDataEntry.fnInitDataBaseLocal();

    // #INICIALIZAR ISOLATE DE CONEXION.
    BackgroundController.initChecarConexionIternet();
    BackgroundController.receivePortConexion.listen((result) {
      BackgroundController.conexion = (result ? 1 : 0);
      setState(() {});
    });

    // #INICIALIZAR ISOLATE DATA COLLAR.
    BackgroundController.receivePortDatosBase.listen((result) async {
      setState(() {
        BackgroundController.datosBase = 1;
      });
      Map<String, bool> mapIds = result;
      await _baseController.fnDescargaDatos(mapIds).then((res) {
        if (res) {
          BackgroundController.datosBase = 0;
        } else {
          BackgroundController.datosBase = 2;
        }
        setState(() {});
      });
    });

    // #INICIALIZAR ISOLATE DATA CATALOGOS.
    CatalogoController.receivePortCatalogo.listen((result) async {
      setState(() {
        CatalogoController.catalogo = 1;
      });
      Map<String, bool> mapIds = result;
      await _catalogoController.fnSincronizarCatalogos(mapIds).then((res) {
        if (res) {
          CatalogoController.catalogo = 0;
        } else {
          CatalogoController.catalogo = 2;
        }
        setState(() {});
      });
    });

    // #INICIALIZAR Y ACTUALIZAR PROYETOS.
    BackgroundController.receivePortProjects.listen((result) async {
      setState(() {
        BackgroundController.projects = 1;
      });
      await _baseController.fnDescargaDatosProjectosSubProyetos().then((res) {
        if (res) {
          BackgroundController.projects = 0;
        } else {
          BackgroundController.projects = 2;
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    BackgroundController.isolateConexion!.kill();
    super.dispose();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String respuesta = prefs.getString('token') ?? '';
    if (respuesta.isNotEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (content) => HomePage()));
    } else {
      /*Navigator.push(
          context, MaterialPageRoute(builder: (content) => StartPage()));*/
      Navigator.push(
          context, MaterialPageRoute(builder: (content) => LoginPage()));
    }
  }
}
