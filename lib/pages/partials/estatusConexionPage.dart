import 'dart:async';
import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/CatalogoController.dart';
import 'package:data_entry_app/pages/partials/IconSyncroAnimate.dart';
import 'package:flutter/material.dart';

class EstatusConexionPage extends StatefulWidget {
  const EstatusConexionPage({Key? key}) : super(key: key);

  @override
  _EstatusConexionPageState createState() => _EstatusConexionPageState();
}

class _EstatusConexionPageState extends State<EstatusConexionPage> {
  int estatusConexion = BackgroundController.conexion;
  int estatusSincro = BackgroundController.datosBase;
  int catalogoSincro = CatalogoController.catalogo;

  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      estatusConexion = BackgroundController.conexion;
      estatusSincro = BackgroundController.datosBase;
      catalogoSincro = CatalogoController.catalogo;
      setStateIfMounted(() {});
    });
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            wSincronizacionCatalogos(estatusSincro),
            wSincronizacionCatalogos(catalogoSincro),
            SizedBox(width: 10.0),
            // #ESTASTUS CONEXION INTERNET.
            (estatusConexion == 1
                ? Column(children: [
                    Icon(Icons.cloud_done, color: Colors.green),
                    Text(
                      'Connected',
                      style: TextStyle(color: Colors.grey, fontSize: 8.0),
                    )
                  ])
                : Column(children: [
                    Icon(Icons.cloud_off, color: Colors.redAccent),
                    Text(
                      'Disconnected',
                      style: TextStyle(color: Colors.grey, fontSize: 8.0),
                    )
                  ])),
            // #ESTASTUS CONEXION SINCRO CATALOGOS.
          ],
        ));
  }

  Widget wSincronizacionCatalogos(int estatusCatalogo) {
    Widget contenedor;
    switch (estatusCatalogo) {
      case 1:
        contenedor = Column(children: [
          IconSyncroAnimate(),
          Text(
            'Syncro',
            style: TextStyle(color: Colors.grey, fontSize: 8.0),
          )
        ]);
        break;
      case 2:
        contenedor = Column(children: [
          Icon(Icons.autorenew, color: Colors.amber),
          Text(
            'Pause',
            style: TextStyle(color: Colors.grey, fontSize: 8.0),
          )
        ]);
        break;
      case 3:
        contenedor = Column(children: [
          Icon(Icons.autorenew, color: Colors.red),
          Text(
            'Error',
            style: TextStyle(color: Colors.grey, fontSize: 8.0),
          )
        ]);
        break;
      default:
        contenedor = Container(); //IconSyncroAnimate();
        break;
    }
    return contenedor;
  }
}
