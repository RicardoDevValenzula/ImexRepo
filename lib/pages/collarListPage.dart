import 'dart:convert';
import 'dart:developer';

import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/CollarController.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/DatosBaseController.dart';
import 'package:data_entry_app/models/ProfileTabsFieldsModel.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/pages/collarPage.dart';
import 'package:data_entry_app/models/CollarModel.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/pages/partials/searchCtrlWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollarListPage extends StatefulWidget {
  final int subProyectoId, proyectoId, campaingId, collerActive;
  final bool fromServer;
  CollarListPage(
      {Key? key,
      required this.subProyectoId,
      required this.proyectoId,
      required this.campaingId,
      this.collerActive = 0,
      this.fromServer = false})
      : super(key: key);

  @override
  _CollarListPageState createState() => _CollarListPageState();
}

class _CollarListPageState extends State<CollarListPage> {
  List<CollarModel> _listCollar = [];
  List<CollarModel> _listCollarFilter = [];
  bool visible = false;
  TextEditingController txtBuscarCtrl = TextEditingController();
  List<String> dateFromatArray = [dd, '/', mm, '/', yyyy];
  TextEditingController _textFieldController = TextEditingController();
  int totalCollarFilter = 0;
  bool activeAdd = false;
  final _dbDataEntry = new DBDataEntry();
  final _collarModal = new CollarModel();
  final _profileTabsFieldsModel = new ProfileTabsFieldsModel();
  String campaignId = '';
  int profileTabId = 0;
  List<Map<String, dynamic>> _itemsCampaign = [], _itemsProfile = [];
  Map<String, dynamic> _profile = Map();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _collarController = CollarController();
  List<CollarModel> lstLocalCollars = [];

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      _profile = _userInfo;
    });

    fnCargarBarrenos();
    activeAdd = false;
    _dbDataEntry
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_campaign', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsCampaign = rows;
      });
    });

    _profileTabsFieldsModel.selectActivos().then((model) {
      model.forEach((item) {
        _itemsProfile.add({
          'value': item.id,
          'label': item.profileName,
          'icon': Icon(Icons.filter_list_rounded)
        });
      });
    });

    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () {
            return fnCargarBarrenos();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SearchCtrlWidget(
                  fnFilter: _runFilter,
                  checkBoxShow: false,
                  titleText: "Search 'HoleId' and 'Campaign'...",
                ),
                Expanded(
                  child: (_listCollarFilter.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.only(bottom: 60.0),
                          shrinkWrap: true,
                          itemCount: _listCollarFilter.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return fnCardBarreno(_listCollarFilter[index]);
                          })
                      : errorWidget(
                          context: context, mensaje: "No result found.")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fnCargarBarrenos() async {
    //var localTable = new DBDataEntry();
    //var collarModel = new CollarModel();
    //bool existe = false;
    try {
      _listCollar = [];

      var collarModel = new CollarModel();
      lstLocalCollars = await collarModel.getAll(widget.subProyectoId);

      if (widget.fromServer) {
        // #DATOS INTERNET.
        if (BackgroundController.conexion == 1) {
          ResultModel collars = await _collarController
              .getCollarsForUserAndSubProject(widget.subProyectoId);
          if (collars.status) {
            CollarModel item;
            /*_listCollar = */ List.generate(collars.data.length, (i) {
              item = new CollarModel();
              if (lstLocalCollars
                  .where(
                      (element) => element.holeId == collars.data[i]['HoleId'])
                  .isEmpty) {
                item.id = int.parse(collars.data[i]['id']);
                item.holeId = collars.data[i]['HoleId'];
                item.project = collars.data[i]['project'];
                item.projectName = collars.data[i]['projectName'];
                item.subproject = collars.data[i]['subproject'];
                item.subProjectName = collars.data[i]['subProjectName'];
                item.campaign = collars.data[i]['Campaign'];
                item.campaignName = collars.data[i]['campaignName'];
                item.country = collars.data[i]['Country'];
                item.countryName = collars.data[i]['countryName'];
                item.geologist = collars.data[i]['Geologist'];
                item.geologistName = collars.data[i]['geologistName'];
                item.dateStart = collars.data[i]['DateStart'];
                item.dateStart = collars.data[i]['DateStart'];

                _listCollar.add(item);
              }
              /*return item;*/
            });
          }
        }
      } else {
        // #DATOS LOCAL.
        _listCollar = lstLocalCollars;
      }

      _listCollarFilter = _listCollar;
      totalCollarFilter = _listCollarFilter.length;
    } catch (ex) {
      print(ex);
    }
    setStateIfMounted(() {
      visible = true;
    });
    return _listCollar;
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }

  Widget fnCardBarreno(CollarModel collar) {
    return InkWell(
      onTap: () {
        if (lstLocalCollars
                .indexWhere((item) => item.holeId == collar.holeId) ==
            -1) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.info,
            text: "Download is required before accessing a collar.",
          );
        } else {
          fnIrBarreno(collar.id);
        }
      },
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.blueAccent,
                width: 5.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    //Hole ID
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            collar.holeId,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          fnIconDownloadCollar('${collar.holeId}'),
                        ]),
                    SizedBox(height: 20.0),
                    //Project
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.folder_special, size: 12.0),
                            Text(
                              ' ${collar.projectName}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text("Project",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
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
                              ' ${collar.subProjectName}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text("Sub-Project/Area",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                    Divider(),
                    //Campaing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cabin, size: 12.0),
                            Text(
                              ' ${collar.campaignName}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text("Campaing",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                    //Country
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag, size: 12.0),
                            Text(
                              ' ${collar.countryName}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text("Country",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                    Divider(),
                    //Geologist
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.terrain, size: 12.0),
                            Text(
                              ' ${collar.geologistName}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text("Geologist",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fnIconDownloadCollar(String holeId) {
    Widget widgetIconDown;
    if (lstLocalCollars.indexWhere((item) => item.holeId == holeId) == -1) {
      widgetIconDown = IconButton(
          onPressed: () async {
            await fnSinronizarBarrenos({'$holeId': true});
          },
          icon: Icon(Icons.download),
          color: Colors.green);
    } else {
      widgetIconDown = IconButton(
          onPressed: () async {
            await fnEliminarBarrenos(holeId);
          },
          icon: Icon(Icons.clear),
          color: Colors.red);
    }
    return widgetIconDown;
  }

  fnIrBarreno(int collarId) async {
    // #BUSCAR SI TIENE UN PEFIL ASIGNADO, SI NO ASIGNAR EL DEFAULT.

    List<dynamic> resultado = [];
    resultado = await _collarModal.fnPerfilTabAsignado(collarId);
    if (resultado.isEmpty) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text:
            "This 'Hole' does not have a viewing profile assigned, do you want to select one already created or use the default profile?.",
        confirmBtnText: 'Select a Profi',
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          bool val = await fnMostrarListaPerfiles(collarId);
          if (val) {
            fnIrPestanas(collarId);
          } else {
            print('Ocurrio un error al insertar.');
          }
        },
        showCancelBtn: true,
        cancelBtnText: 'Default profile',
        onCancelBtnTap: () async {
          int userId = int.parse(_profile['id'].toString());
          bool asignada =
              await _collarModal.fnAsignadoPerfilTab(1, collarId, userId);
          if (asignada) {
            fnIrPestanas(collarId);
          } else {
            print('Ocurrio un error al insertar.');
          }
        },
      );
    } else {
      fnIrPestanas(collarId);
    }
  }

  void fnIrPestanas(int collarId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CollarPage(holeId: collarId),
      ),
    );
  }

  Future<void> fnCrearNuevoBarreno() async {
    _textFieldController.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New hole.'),
            content: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                          labelText: 'Hole Id', hintText: "Hole Id..."),
                      validator: (value) {
                        if (value == null || value == '') {
                          return "enter the name for the new hole...";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SelectFormField(
                      type: SelectFormFieldType.dialog, // or can be dialog
                      initialValue: 'circle',
                      changeIcon: false,
                      dialogTitle: 'Pick a Campaign',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search Campaign',
                      labelText: 'Campaign',
                      items: _itemsCampaign,
                      onChanged: (val) {
                        setState(() {
                          campaignId = val;
                        });
                      },
                      onSaved: (val) => print(val),
                      validator: (value) {
                        if (value == null || value == '') {
                          return "An 'Campaign' has not been selected...";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  String nuevoNombre = _textFieldController.text;
                  fnNuevoBarreno(nuevoNombre);
                },
              ),
            ],
          );
        });
  }

  void fnNuevoBarreno(String nombre) async {
    // #VALIDAR SI EL NOMBRE ESTA VACIO.
    if (nombre.isNotEmpty) {
      List<dynamic> lstExist = [];
      // #VALIDAR SI EXISTE YA ESE NOMBRE.
      await _dbDataEntry.database.then((db) async {
        lstExist = await db.query(_collarModal.tbName,
            where: 'HoleId = ?', whereArgs: [nombre]);
      });
      // #VALIDAR SI EL NOMBRE YA EXISTE.
      if (lstExist.isEmpty) {
        if (int.tryParse(campaignId) != null) {
          // #INSERTAR REGISTRO DEL BARRENO CON DATOS BASE.
          int id = await _collarModal.insertarBase(nombre, widget.proyectoId,
              widget.subProyectoId, int.parse(campaignId), 4);
          if (id > 0) {
            // #CERRAR MODAL DE CAPTURA.
            Navigator.pop(context);
            // #ACTUALIZAR/CARGAR BARRENOS DE NUEVO.
            await fnCargarBarrenos();
            // #MOSTRAR MENSAGE DE OK.
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Hole created successfully.",
            );
          } else {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "An error occurred while trying to create the hole.",
            );
          }
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "An 'campaign' has not been selected.",
          );
        }
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "This 'HoleId' name already exists.",
        );
      }
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "The hole name must not be empty.",
      );
    }
  }

  void _runFilter(String enteredKeyword) {
    List<CollarModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _listCollar;
    } else {
      results = _listCollar.where((element) {
        if (element.holeId
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) ||
            element.campaignName
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    setStateIfMounted(() {
      _listCollarFilter = results;
      totalCollarFilter = _listCollarFilter.length;
    });
  }

  Future<bool> fnMostrarListaPerfiles(int collarId) async {
    bool asignada = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select a profile.'),
            content: Form(
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SelectFormField(
                      type: SelectFormFieldType.dialog, // or can be dialog
                      initialValue: 'circle',
                      changeIcon: false,
                      dialogTitle: 'Pick a Profile',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search Profile',
                      labelText: 'Profile',
                      items: _itemsProfile,
                      onChanged: (val) {
                        setState(() {
                          profileTabId = int.parse(val);
                        });
                      },
                      onSaved: (val) => print(val),
                      validator: (value) {
                        if (value == null || value == '') {
                          return "An 'Profile' has not been selected...";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  int userId = int.parse(_profile['id'].toString());
                  asignada = await _collarModal.fnAsignadoPerfilTab(
                      profileTabId, collarId, userId);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }).then((val) {});
    return asignada;
  }

  Future<dynamic> fnSinronizarBarrenos(
      Map<String, bool> lstCollarDownload) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    await new DatosBaseController()
        .fnDescargaDatos(lstCollarDownload)
        .then((res) async {
      if (res) {
        BackgroundController.datosBase = 0;
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: 'Download.',
          text: 'The hole discharged correctly.',
        );
        log('Termio si.');
        await fnCargarBarrenos();
      } else {
        BackgroundController.datosBase = 2;
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          title: 'Download.',
          text: 'An error occurred while unloading the hole.',
        );
        log('Termio no.');
      }
      Loader.hide();
      setStateIfMounted(() {});
    });
  }

  Future<dynamic> fnEliminarBarrenos(String holeId) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Are you sure you want to delete it?.",
        confirmBtnText: "Ok",
        onConfirmBtnTap: () async {
          Loader.show(
            context,
            isAppbarOverlay: true,
            isBottomBarOverlay: true,
            progressIndicator: widgetLoading(context),
            overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
          );
          await new DatosBaseController()
              .fnLimpiarTablasCollar(holeId)
              .then((res) async {
            print('Termio si.');
            await fnCargarBarrenos();
            Loader.hide();
            setStateIfMounted(() {});
            Navigator.pop(context);
          });
        });
  }
}
