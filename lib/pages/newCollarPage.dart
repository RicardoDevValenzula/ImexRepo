import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/CollarModel.dart';
import 'package:data_entry_app/models/ProfileTabsFieldsModel.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'collarPage.dart';

class NewCollarPage extends StatefulWidget {
  final int subProyectoId, proyectoId, campaingId;
  NewCollarPage(
      {Key? key,
      required this.subProyectoId,
      required this.proyectoId,
      required this.campaingId})
      : super(key: key);

  @override
  _NewCollarPageState createState() => _NewCollarPageState();
}

class _NewCollarPageState extends State<NewCollarPage> {
  TextEditingController _textFieldController = TextEditingController();
  List<Map<String, dynamic>> _itemsProfile = [];
  final _dbDataEntry = new DBDataEntry();
  final _profileTabsFieldsModel = new ProfileTabsFieldsModel();
  String campaignId = '';
  final _collarModal = new CollarModel();
  int profileTabId = 0;
  Map<String, dynamic> _profile = Map();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      _profile = _userInfo;
    });
    /*
    _dbDataEntry
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_campaign', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsCampaign = rows;
      });
    });
    */

    campaignId = '0';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DataEntryTheme.deBrownDark,
          ),
          onPressed: () {
            fnBackPage();
          },
        ),
        title: Text(
          'New Collar.',
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String nuevoNombre = _textFieldController.text;
          fnNuevoBarreno(nuevoNombre);
        },
        backgroundColor: DataEntryTheme.deOrangeDark,
        child: Icon(Icons.save),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height / 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter the name for the new hole.',
                      style: TextStyle(
                          fontSize: 25.0, color: DataEntryTheme.deBrownDark),
                    ),
                    SizedBox(height: 20.0),
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
                    SizedBox(height: AppBar().preferredSize.height),
                    /*
                    SizedBox(height: 10.0),
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
                    SizedBox(height: 10.0),
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
                    ),*/
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }

  void fnIrPestanas(int collarId) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CollarPage(holeId: collarId),
      ),
    );
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
            //Navigator.pop(context);
            // #ACTUALIZAR/CARGAR BARRENOS DE NUEVO.
            fnIrBarreno(id);
            // #MOSTRAR MENSAGE DE OK.
            /*CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Hole created successfully.",
            );
            */
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
                  //Navigator.of(context, rootNavigator: true).pop(true);
                },
              ),
            ],
          );
        }).then((val) {});
    return asignada;
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
        confirmBtnText: 'Select a Profile',
        onConfirmBtnTap: () async {
          bool val = await fnMostrarListaPerfiles(collarId);
          if (val) {
            fnIrPestanas(collarId);
          } else {
            print('An error occurred while inserting.');
          }
          //Navigator.pop(context);
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
            print('An error occurred while inserting.');
          }
        },
      );
    } else {
      fnIrPestanas(collarId);
    }
  }
}
