import 'dart:async';

//import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/models/TablaSincroLocalModel.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/partials/estatusConexionPage.dart';
import 'package:data_entry_app/pages/partials/favoriteFields.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/pages/partials/notInternetConnection.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class SincroCatalogosPage extends StatefulWidget {
  final int tipoTabla;
  SincroCatalogosPage({Key? key, required this.tipoTabla}) : super(key: key);

  @override
  _SincroCatalogosPageState createState() => _SincroCatalogosPageState();
}

class _SincroCatalogosPageState extends State<SincroCatalogosPage> {
  late SincronizarController _sincronizarController;
  late List<Map<String, dynamic>> _listTablas = [], _tablasFiltradas = [];
  late List<TablaSincroLocalModel> _tablasLocales = [];
  late Map<String, bool> _selectedTables = {};
  late Map<String, double> _barraProgreso = {};
  late Map<String, String> _subTitulo = {};
  late TextEditingController txtBuscarCtrl = TextEditingController();
  late bool conectado = false, checkAll = false, disabled = true;
  late DBDataEntry _dbDataEntry;
  double progressValue = 0.0;
  int _tbProcesadas = 0;
  int _totalTbProcesadas = 0;
  TextEditingController txtBuscarCampoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sincronizarController = new SincronizarController();
    _listTablas = <Map<String, dynamic>>[];
    _dbDataEntry = new DBDataEntry();
    fnCargarTablas(widget.tipoTabla);
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DataEntryTheme.deOrangeDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Catalogs",
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        actions: [new EstatusConexionPage()],
      ),
      /*backgroundColor: Colors.transparent,*/
      floatingActionButton: (_selectedTables.isEmpty
          ? Container()
          : (disabled
              ? Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: DataEntryTheme.deOrangeLight,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    'Processing $_tbProcesadas/$_totalTbProcesadas',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /*
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.green,
                      onPressed: () {
                        if (_selectedTables.length > 0) {
                          CatalogoController.initCatalogo(_selectedTables);
                          Navigator.pop(context);
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text: "No catalog has been selected.",
                          );
                        }
                      },
                      child: Icon(Icons.autorenew),
                    ),
                    */
                    FloatingActionButton(
                      backgroundColor: DataEntryTheme.deOrangeDark,
                      onPressed: () {
                        fnSincronizarTablasSeleccionadas();
                      },
                      child: Icon(Icons.cloud_download),
                    ),
                  ],
                ))),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () {
            return (disabled ? null : fnCargarTablas(widget.tipoTabla));
          },
          child: (conectado
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      fnCtrlBuscarWidget(),
                      Expanded(
                        child: (_tablasFiltradas.length > 0
                            ? ListView.builder(
                                padding: EdgeInsets.only(bottom: 60.0),
                                shrinkWrap: true,
                                itemCount: _tablasFiltradas.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return fnCardTablaSincro(
                                      _tablasFiltradas[index]);
                                },
                              )
                            : errorWidget(
                                context: context,
                                mensaje: "No results found.")),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: Center(
                      child: (conectado
                          ? notInternetConection(context)
                          : widgetLoading(context)),
                    ),
                  ),
                )),
        ),
      ),
    );
  }

  Widget fnCardTablaSincro(Map<String, dynamic> item) {
    return Card(
      child: Column(
        children: [
          CheckboxListTile(
              contentPadding: EdgeInsets.only(right: 5.0, left: 5.0),
              activeColor: DataEntryTheme.deOrangeLight,
              title: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        (item['nombre_tabla']
                                .toString()
                                .toLowerCase()
                                .contains('cat_')
                            ? IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.yellow[600],
                                ),
                                onPressed: () {
                                  fnSeleccionarFavoritos(item['nombre_tabla']);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.grey[600],
                                ),
                                onPressed: null,
                              )),
                        Text(
                          "${item['nombre_tabla']}",
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _subTitulo[item['nombre_tabla']] ?? 'error!',
                      style: TextStyle(
                          color: DataEntryTheme.deGrayMedium, fontSize: 10.0),
                    ),
                  ),
                ],
              ),
              value: _selectedTables[item['nombre_tabla']] ?? false,
              onChanged: (disabled
                  ? null
                  : (selected) {
                      _onCategorySelected(selected!, item['nombre_tabla']);
                    })),
          LinearProgressIndicator(
            backgroundColor: DataEntryTheme.deGrayLight,
            color: DataEntryTheme.deOrangeDark,
            value: _barraProgreso["${item['nombre_tabla']}"] ?? 0.0,
            semanticsLabel: 'Linear progress indicator',
          ),
        ],
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _listTablas;
      limpiar = false;
    } else {
      results = _listTablas
          .where((element) => element['nombre_tabla']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      limpiar = true;
    }
    setStateIfMounted(() {
      _tablasFiltradas = results;
    });
  }

  fnCargarTablas(int tipo) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi   ||
        connectivityResult == ConnectivityResult.ethernet) {
      conectado = true;
      ResultModel tablas =
          await _sincronizarController.listaTablasPorTipo(tipo);
      if (tablas.status) {
        _listTablas = (tablas.data["tablas"] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        _tablasFiltradas = _listTablas;
      } else {
        _listTablas = [];
        _tablasFiltradas = _listTablas;
      }
      print(_tablasFiltradas);
      // #OBTENER LISTA LOCAL.
      var model = new TablaSincroLocalModel();
      _tablasLocales = await model.getAll();
      // #GENERAR LISTASDO DE BARRAS DE PROGRESO Y SUBTITULOS.
      _listTablas.forEach((tabla) {
        _barraProgreso[tabla['nombre_tabla']] = 0.0;
        _subTitulo[tabla['nombre_tabla']] =
            fnInfoTablaLocal(tabla['nombre_tabla']);
      });
      disabled = false;
    } else {
      conectado = false;
    }
    setStateIfMounted(() {});
  }

  void _onCategorySelected(bool selected, nombreTabla) {
    if (selected == true) {
      _selectedTables[nombreTabla] = true;
    } else {
      //_selectedCollar[nombreTabla] = false;
      _selectedTables.remove(nombreTabla);
    }
    /*
    if (selected == true) {
      _selectedTables[nombreTabla] = true;
    } else {
      _selectedTables[nombreTabla] = false;
    }
    */
    setStateIfMounted(() {});
  }

  void fnCheckAll(bool check) {
    for (Map<String, dynamic> item in _listTablas) {
      _selectedTables[item['nombre_tabla']] = check;
    }
    setStateIfMounted(() {
      checkAll = check;
    });
  }

  String fnInfoTablaLocal(String nombreTabla) {
    String strResultado = "Without updating.";
    if (_tablasLocales.length > 0) {
      TablaSincroLocalModel? model = _tablasLocales.lastWhere(
          (element) =>
              element.nombreTabla.trim().toLowerCase() ==
              nombreTabla.trim().toLowerCase(), orElse: () {
        return new TablaSincroLocalModel();
      });
      if (model.id > 0) {
        String strdtnow = formatDate(DateTime.parse(model.updatedAt),
            [dd, '/', mm, '/', yyyy, ' ', hh, ':', mm, ' ', am]);
        strResultado = "Last update: $strdtnow.";
      }
    }
    return strResultado;
  }

  Future<void> fnSincronizarTablasSeleccionadas() async {
    // #OBTNER LISTA DE CATALOGOS SELECIONADOS.
    Map<String, bool> seleccionados = Map();
    for (var item in _selectedTables.entries) {
      if (item.value) {
        seleccionados[item.key] = item.value;
      }
    }

    // #VALIDAR SI HAY AGUN CATALOGO SELECCIONADO.
    if (seleccionados.length > 0) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text:
              "By accepting the selected catalogs are updated. Do not close this screen until finished.",
          confirmBtnText: "Ok",
          onConfirmBtnTap: () async {
            setStateIfMounted(() {
              disabled = true;
            });
            setStateIfMounted(() {
              _tbProcesadas = 0;
              _totalTbProcesadas = seleccionados.length;
            });
            Navigator.pop(context);
            await fnSincronizarCatalogos(seleccionados);
            setStateIfMounted(() {
              disabled = false;
            });
          },
          cancelBtnText: "Cancel",
          onCancelBtnTap: () {
            Navigator.pop(context);
          });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "No catalog has been selected.",
      );
    }
  }

  Future<void> fnSincronizarCatalogos(Map<String, bool> catalogos) async {
    try {
      // #RECORERR LISTA DE LAS TABLAS.
      for (var entry in catalogos.entries) {
        //_selectedTables.forEach((nombreTabla, valor) async {
        ResultModel registrosTabla;
        // #VALIDAR SI ESTA SELECCIONADA.
        if (entry.value) {
          // #OBTENER LA PRIMERA PAGINA DE LOS REGISTROS.
          registrosTabla = await _sincronizarController.obtenerInfoDatosTabla(
              entry.key, 1, 500);
          if (registrosTabla.status) {
            // #OBTENER CREATE DE LA TABLA.
            Map<String, dynamic> itemTabla = _listTablas
                .where((element) =>
                    element['nombre_tabla'].toString().toLowerCase().trim() ==
                    entry.key.toLowerCase().trim())
                .first;
            // #CREAR TABLA.
            String queryCreate = "${itemTabla['create_tabla_sqllite']}";
            await _dbDataEntry.fnCrearTabla(queryCreate);
            // #OBTENER NUMERO TOTAL DE PAGINAS.
            int paginasTotales =
                int.tryParse(registrosTabla.data['informacion']['paginas']) ??
                    0;
            int totalRegistros = int.tryParse(
                    registrosTabla.data['informacion']['registros_totales']) ??
                0;
            int contador = 0;
            progressValue = 0.0;
            // #BORRAR DATOS ANTERIORES.
            await _dbDataEntry.fnBorrarTabla(entry.key);
            // #RECORRER TOTAL DE PAGINAS.
            for (int i = 1; i <= paginasTotales; i++) {
              if (i != 1) {
                registrosTabla = await _sincronizarController
                    .obtenerInfoDatosTabla(entry.key, i, 500);
              }
              // #RECORRER REGISTROS DE LA PAGINA.
              for (Map<String, dynamic> registro
                  in registrosTabla.data['registros']) {
                // #INSERTAR REGISTROS EN LA TABLA LOCAL.
                await _sincronizarController.fnInsertarRegistroTabla(
                    entry.key, registro);
                //print("Insertado: $id - $registro.");
                setStateIfMounted(() {
                  contador++;
                  progressValue = (contador / totalRegistros);
                  _barraProgreso[entry.key] = progressValue;
                  _subTitulo[entry.key] =
                      'Procesando: $contador/$totalRegistros...';
                });
              }
            }
            setStateIfMounted(() {
              _selectedTables[entry.key] = false;
              _tbProcesadas++;
            });
            // #ACTUALIZAR REGISTRO DE SINCRONIZACION.
            await fnActualizarRegistroSincronizacion(
                int.tryParse(itemTabla['id']) ?? 0,
                int.tryParse(itemTabla['id']) ?? 0,
                int.tryParse(itemTabla['tipo_tabla_id']) ?? 0,
                itemTabla['nombre_tabla'],
                1);
          } else {
            print("Error: $entry.key");
          }
        }
      }
    } catch (ex) {}
  }

  Future<void> fnActualizarRegistroSincronizacion(
      int id,
      int tbSincronizacionAppId,
      int tipoTablaId,
      String nombreTabla,
      int estatusId) async {
    // #OBTENER FECHA ACTUAL DEL DISPOSITIVO.
    String dtnow = DateTime.now().toIso8601String();
    String strdtnow = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);
    // #ASIGNAR DATOS AL MODELO.
    Map<String, dynamic> valores = {
      'id': id,
      'tb_sincronizacion_app_id': tbSincronizacionAppId,
      'tipo_tabla_id': tipoTablaId,
      'nombre_tabla': nombreTabla,
      'estatus_id': estatusId,
      'created_at': dtnow,
      'updated_at': dtnow
    };
    TablaSincroLocalModel tablaSincroLocalModel = new TablaSincroLocalModel();
    tablaSincroLocalModel.fromMap(valores);
    // #ELIMINAR SI EXISTE YA EL REGISTRO.
    await tablaSincroLocalModel.fnEliminarRegistro(tablaSincroLocalModel.id);
    // #VALIDAR SI EXISTE EL EL REGISTRO.
    await tablaSincroLocalModel.insert();

    setStateIfMounted(() {
      _subTitulo[nombreTabla] = 'Last update: $strdtnow';
    });
  }

  bool limpiar = false;

  Widget fnCtrlBuscarWidget() {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                _runFilter(value);
              },
              controller: txtBuscarCtrl,
              decoration: InputDecoration(
                labelText: "Search...",
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: (limpiar
                    ? IconButton(
                        onPressed: () {
                          txtBuscarCtrl.clear();
                          _runFilter('');
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        icon: Icon(Icons.clear),
                      )
                    : null),
              ),
            ),
          ),
          Container(
            child: Checkbox(
              activeColor: DataEntryTheme.deOrangeLight,
              value: checkAll,
              onChanged: (value) {
                fnCheckAll(value!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fnSeleccionarFavoritos(String nombreTabla) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Dialog(
            /*shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(20.0)),*/
            child: FavoriteFieldsPage(nombreTable: nombreTabla),
          ),
        );
      },
    );
  }
}
