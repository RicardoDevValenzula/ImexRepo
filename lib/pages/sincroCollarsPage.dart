import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/CollarController.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/DatosBaseController.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';
import 'package:data_entry_app/models/CollarModel.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/partials/estatusConexionPage.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/pages/partials/notInternetConnection.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class SincroCollarsPage extends StatefulWidget {
  SincroCollarsPage({Key? key}) : super(key: key);

  @override
  _SincroCollarsPageState createState() => _SincroCollarsPageState();
}

class _SincroCollarsPageState extends State<SincroCollarsPage> {
  List<Map<String, dynamic>> _listTablas = [],
      _tablasFiltradas = [],
      _listTablasLocal = [];
  Map<String, bool> _selectedCollar = {};
  TextEditingController txtBuscarCtrl = TextEditingController();
  bool loading = true, conectado = true, checkAll = false, disabled = true;
  List<String> dateFromatArray = [dd, '/', mm, '/', yyyy];

  @override
  void initState() {
    super.initState();
    _listTablas = <Map<String, dynamic>>[];
    fnCagarCollars();
    if (BackgroundController.datosBase == 1) {
      disabled = true;
      //_selectedCollar.clear();
    }
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
          "Collars",
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        actions: [new EstatusConexionPage()],
      ),
      /*backgroundColor: Colors.transparent,*/
      floatingActionButton: (_selectedCollar.isEmpty
          ? Container()
          : (disabled
              ? null
              : FloatingActionButton(
                  backgroundColor: DataEntryTheme.deOrangeDark,
                  onPressed: () async {
                    //var res = await fnSinronizarBarrenos();
                    await fnSinronizarBarrenos();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cloud_download),
                ))),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () {
            return (disabled ? null : fnCagarCollars());
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
                                context: context, mensaje: "No results f.")),
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
                      child: (!conectado
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
    List<Map<String, dynamic>> lstFechaActualizado = [];
    _listTablasLocal.map((collar) {
      if (item['HoleId'] == collar['HoleId']) {
        lstFechaActualizado.add(collar);
        return true;
      }
    }).toList();

    var color = (lstFechaActualizado.length > 0 ? Colors.green : Colors.red);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color:
                  (lstFechaActualizado.length > 0 ? Colors.green : Colors.grey),
              width: 5.0,
            ),
          ),
        ),
        padding: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0, top: 0.0),
        child: Column(
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.only(right: 0.0, left: 10.0),
              activeColor: DataEntryTheme.deOrangeLight,
              title: Text(item['HoleId'], style: TextStyle(fontSize: 20.0)),
              value: _selectedCollar[item['HoleId']] ?? false,
              onChanged: (disabled
                  ? null
                  : (selected) {
                      _onCategorySelected(selected!, item['HoleId']);
                    }),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      // #FECHA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.event, size: 12.0),
                              Text(
                                (lstFechaActualizado.length > 0
                                    ? ' Download locally.'
                                    : ' Not downloaded.'),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(
                            "Last Updating",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: DataEntryTheme.deGrayMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      //Project
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.folder_special, size: 12.0),
                              Text(
                                ' ${item['projectName']}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: DataEntryTheme.deGrayMedium,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(
                            "Project",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: DataEntryTheme.deGrayMedium,
                            ),
                          )
                        ],
                      ),
                      //Sub-Project/Area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.snippet_folder, size: 12.0),
                              Text(
                                ' ${item['subProjectName']}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: DataEntryTheme.deGrayMedium,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(
                            "Sub-Project/Area",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: DataEntryTheme.deGrayMedium,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            (lstFechaActualizado.length > 0
                ? Container(
                    child: TextButton(
                      style: TextButton.styleFrom(primary: Colors.red),
                      onPressed: () {
                        fnConfirmarEliminacion("${item['HoleId']}");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  )
                : Container()),
          ],
        ),
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
          .where((element) => element['HoleId']
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

  fnCagarCollars() async {
    var localTable = new DBDataEntry();
    var collarModel = new CollarModel();

    bool existe = await localTable.fnExiste(collarModel.tbName);
    if (existe) {
      await localTable.database.then((db) async {
        _listTablasLocal = await db.query(new CollarModel().tbName);
        _listTablas = [];
        _tablasFiltradas = _listTablas;
      });
    }

    conectado = await GeneralController.hayConexionInternet();
    if (conectado) {
      ResultModel collars = await new CollarController().getCollarsForUser();
      if (collars.status) {
        _listTablas = (collars.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        _tablasFiltradas = _listTablas;
      } else {
        _listTablas = [];
        _tablasFiltradas = _listTablas;
      }
      disabled = false;
      loading = false;
    } else {
      _listTablas = [];
      _tablasFiltradas = _listTablas;
    }
    setStateIfMounted(() {});
  }

  void _onCategorySelected(bool selected, nombreTabla) {
    if (selected == true) {
      _selectedCollar[nombreTabla] = true;
    } else {
      //_selectedCollar[nombreTabla] = false;
      _selectedCollar.remove(nombreTabla);
    }
    setStateIfMounted(() {});
  }

  void fnCheckAll(bool check) {
    for (Map<String, dynamic> item in _listTablas) {
      if (check) {
        _selectedCollar[item['HoleId']] = true;
      } else {
        _selectedCollar.remove(item['HoleId']);
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

  Future<dynamic> fnSinronizarBarrenos() async {
    await CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        text: "the collars are then updated in the background.",
        barrierDismissible: true,
        confirmBtnText: "Ok",
        onConfirmBtnTap: () async {
          await BackgroundController.initDatosBase(_selectedCollar);
          Navigator.pop(context);
        });
  }

  void fnConfirmarEliminacion(String holeId) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      text: ".",
      confirmBtnText: 'Delete',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Loader.show(
          context,
          isAppbarOverlay: true,
          isBottomBarOverlay: true,
          progressIndicator: widgetLoading(context),
          overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
        );
        Navigator.pop(context);
        await fnEliminarBarreno(holeId);
      },
      showCancelBtn: true,
      cancelBtnText: 'Cancel',
    );
  }

  Future<bool> fnEliminarBarreno(String holeId) async {
    bool resultado = false;
    try {
      await new DatosBaseController().fnLimpiarTablasCollar(holeId);
      //resultado = (respuesta.length > 0 ? true : false);
      await fnCagarCollars();
      Loader.hide();
    } catch (ex) {
      print(ex);
      resultado = false;
    }
    return resultado;
  }
}
