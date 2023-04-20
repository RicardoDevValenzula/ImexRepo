import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/DatosBaseController.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/pages/partials/estatusConexionPage.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'partials/errorWidget.dart';

class DataConfigPage extends StatefulWidget {
  DataConfigPage({Key? key}) : super(key: key);

  @override
  DataConfigPageState createState() => DataConfigPageState();
}

class DataConfigPageState extends State<DataConfigPage> {
  List<Map<String, dynamic>> _listASincronizar = [], _tablasFiltradas = [];
  Map<String, bool> _selectedCollar = {};
  TextEditingController txtBuscarCtrl = TextEditingController();
  bool loading = true, conectado = true, checkAll = false, disabled = true;
  List<String> dateFromatArray = [dd, '/', mm, '/', yyyy];
  int countInsertTotal = 0, countUpdareTotal = 0, countDeleteTotal = 0;
  SincronizarController _sincronizarController = SincronizarController();
  DatosBaseController _baseController = DatosBaseController();

  @override
  void initState() {
    super.initState();
    _listASincronizar = [];
    _tablasFiltradas = [];
    _selectedCollar = Map();
    countInsertTotal = 0;
    countUpdareTotal = 0;
    countDeleteTotal = 0;
    fnListaBarrenosSincronizar();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Scaffold(
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
                //Navigator.pop(context);
                //Navigator.of(context).maybePop();
                Navigator.of(context, rootNavigator: true).pop(context);
              },
            ),
            title: Text(
              'SYNC UP',
              style: TextStyle(
                color: DataEntryTheme.deBrownDark,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            actions: [
              new EstatusConexionPage()
            ],
          ),
      floatingActionButton: (_selectedCollar.isEmpty
          ? Container()
          : (disabled
              ? null
              : FloatingActionButton(
                  backgroundColor: DataEntryTheme.deOrangeDark,
                  onPressed: () {
                    //fnSinronizarBarrenos();
                  },
                  child: Icon(Icons.cloud_upload),
                ))),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () {
            return (disabled ? null : fnListaBarrenosSincronizar());
          },
          child: (!loading
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      wCtrlBuscar(),
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
              : Container()),
        ),
      ),
    )
    );
  }

  Widget fnCardTablaSincro(Map<String, dynamic> item) {
    if (item.entries.isNotEmpty) {
      String holeId = item.entries.first.key;
      List<Map<String, dynamic>> lstCambios = item.entries.first.value;

      return Card(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.green,
                width: 5.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: Column(
            children: [
              ExpansionTile(
                tilePadding: EdgeInsets.only(right: 10.0, left: 0.0),
                title: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          fnOpcionesSincro(holeId);
                        },
                        icon: Icon(Icons.more_vert)),
                    Text(holeId, style: TextStyle(fontSize: 20.0)),
                  ],
                )),
                children: fnListTabla(lstCambios),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> fnListTabla(List<Map<String, dynamic>> listTablasCambios) {
    List<Widget> lstWidget = [];
    for (Map<String, dynamic> item in listTablasCambios) {
      String nameTable =
          item.entries.first.key.replaceAll('tb_', '').toUpperCase().trim();
      List<Map<String, dynamic>> lstCambios = item.entries.first.value;
      int countInsert = 0, countUpdare = 0, countDelete = 0;
      countInsert = lstCambios.where((element) {
        if (element['status_sync'] == 4 || element['status_sync'] == 5) {
          return true;
        } else {
          return false;
        }
      }).length;

      countUpdare = lstCambios.where((element) {
        if (element['status_sync'] == 2) {
          return true;
        } else {
          return false;
        }
      }).length;

      countDelete = lstCambios.where((element) {
        if (element['status_sync'] == 3) {
          return true;
        } else {
          return false;
        }
      }).length;

      countInsertTotal = (countInsertTotal + countInsert);
      countUpdareTotal = (countUpdareTotal + countUpdare);
      countDeleteTotal = (countDeleteTotal + countDelete);
      // setStateIfMounted(() {});

      lstWidget.add(Column(
        children: [
          //Divider(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nameTable,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text('$countInsert'),
                          Text(
                            'Insert',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text('$countUpdare'),
                          Text(
                            'Update',
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text('$countDelete'),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ));
    }
    return lstWidget;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _listASincronizar;
      limpiar = false;
    } else {
      results = _listASincronizar
          .where((element) => element.entries.first.key
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

  fnListaBarrenosSincronizar() async {
    await fnObtenerListaBarrenosSincronizar();
    if (_listASincronizar.isNotEmpty) {
      _tablasFiltradas = _listASincronizar;
    } else {
      _listASincronizar = [];
      _tablasFiltradas = _listASincronizar;
    }
    disabled = false;
    loading = false;
    setStateIfMounted(() {});
  }

  void _onCategorySelected(bool selected, nombreTabla) {
    if (selected == true) {
      _selectedCollar[nombreTabla] = true;
    } else {
      _selectedCollar.remove(nombreTabla);
    }
    setStateIfMounted(() {});
  }

  void fnCheckAll(bool check) {
    for (Map<String, dynamic> item in _listASincronizar) {
      if (check) {
        _selectedCollar[item.entries.first.key] = true;
      } else {
        _selectedCollar.remove(item.entries.first.key);
      }
    }
    setStateIfMounted(() {
      checkAll = check;
    });
  }

  bool limpiar = false;

  Widget wCtrlBuscar() {
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
          /*
          Container(
            child: Checkbox(
              activeColor: DataEntryTheme.deOrangeLight,
              value: checkAll,
              onChanged: (disabled
                  ? null
                  : (value) {
                      fnCheckAll(value!);
                    }),
            ),
          ),
          */
        ],
      ),
    );
  }

  Future<void> fnSinronizarBarrenos(String holeId) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    try {
      setState(() {
        disabled = true;
      });
      _selectedCollar.clear();
      _onCategorySelected(true, holeId);
      var lstHoleUp;
      for (var item in _listASincronizar) {
        if (item.containsKey(holeId)) {
          lstHoleUp = item;
          //break;
        }
      }
      ResultModel respuesta = //new ResultModel();
          await _sincronizarController.subirDatosSincro([lstHoleUp]);
      //print(respuesta);
      if (respuesta.status) {
        print(_selectedCollar);
        _listASincronizar = [];
        _tablasFiltradas = [];
        await _baseController.fnLimpiarTablasCollar(holeId);
        await fnListaBarrenosSincronizar();
        BackgroundController.initDatosBase({holeId: true});

        CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          title: 'Synchronization',
          text: "Synchronization successful",
          /*widget: ShowResumenSyncPage(infoResumen: respuesta.data),*/
          confirmBtnText: "Ok",
          onConfirmBtnTap: () async {
            Navigator.pop(context);
          },
        );
      } else {
        Navigator.pop(context);
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: respuesta.message,
            barrierDismissible: true,
            confirmBtnText: "Ok",
            onConfirmBtnTap: () async {

              if(mounted){
                Navigator.of(context, rootNavigator: true).pop();
              }
            });
      }
    } catch (ex) {
      print(ex);
    }
    Loader.hide();
  }

  Future<List<Map<String, dynamic>>> fnObtenerListaBarrenosSincronizar() async {
    List<Map<String, dynamic>> lstDatosSincro = [], lstTabs = [];
    String statusSync = [2, 3, 4, 5, 6].join(', ');
    try {
      // #OBTENER TODOS LOS BARRENOS LOCALES DESCRGADOS POR USUARIO.
      await new DBDataEntry().database.then((db) async {
        lstDatosSincro = await db.query('tb_collar',
            where: 'status = ?',
            whereArgs: [1]).onError((error, stackTrace) => []);
        // #OBTENER LISTADO DE TABS.
        lstTabs = await db.query('tb_sincronizacion_local_app',
            where: 'estatus_id = ? AND tipo_tabla_id = ?', whereArgs: [1, 2]);
        // #RECORRER TODOS LOS BARRENOS LOCALES POR USUARIO.
        for (Map<String, dynamic> collar in lstDatosSincro) {
          List<Map<String, dynamic>> lstCollarTabs = [];
          for (Map<String, dynamic> tab in lstTabs) {
            String where = '';
            //List<dynamic> whereArg = [];

            switch (tab['nombre_tabla'].toLowerCase().trim()) {
              case 'tb_collar':
                where = "HoleId = '" + collar['HoleId'] + "'";
                break;
              case 'tb_geotechcorelog':
                where = "Id_Collar = ${collar['id']}";
                break;
              case 'tb_pumptest':
                where = "id_collar = ${collar['id']}";
                break;
              default:
                where = "IdCollar = ${collar['id']}";
                break;
            }
            List<Map<String, dynamic>> resultTable = await db
                .rawQuery("SELECT * " +
                    "FROM ${tab['nombre_tabla']} " +
                    "WHERE status_sync IN ($statusSync) AND $where")
                .onError((error, stackTrace) => []);
            if (resultTable.isNotEmpty) {
              lstCollarTabs.add({tab['nombre_tabla']: resultTable});
            }
          }
          if (lstCollarTabs.isNotEmpty) {
            _listASincronizar.add({collar['HoleId']: lstCollarTabs});
          }
        }
      });
    } catch (ex) {
      _listASincronizar = [];
      print(ex);
    }
    setStateIfMounted(() {});
    return _listASincronizar;
  }

  void fnOpcionesSincro(String holeId) {
    _settingModalBottomSheet(context, holeId);
  }

  void _settingModalBottomSheet(context, String holeId) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(bottom: 20),
            child: new Wrap(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Actions to do '$holeId'.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(10.00),
                ),
                Divider(),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await fnSinronizarBarrenos(holeId);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Icon(Icons.cloud_upload, color: Colors.green),
                          ),
                          Text('Upload to the server'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed:
                          null /*() {
                        Navigator.pop(context);
                      }*/
                      ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Icon(Icons.send_to_mobile, color: Colors.blue),
                          ),
                          Text('Export to another device'),
                        ],
                      ),
                    )
                  ],
                )),
              ],
            ),
          );
        });
  }
}
