import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/ProfileTabsFieldsModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/models/TablaSincroLocalModel.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/tabsFieldConfigPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SelectTabsFieldsPage extends StatefulWidget {
  final int perfilId;
  SelectTabsFieldsPage({Key? key, required this.perfilId}) : super(key: key);

  @override
  _SelectTabsFieldsPageState createState() => _SelectTabsFieldsPageState();
}

class _SelectTabsFieldsPageState extends State<SelectTabsFieldsPage> {
  String titulo = 'Selection of tabs / fields';
  TextEditingController txtBuscarCtrl = TextEditingController();
  bool btnLimpiar = false, checkAll = false, fnCheckAll = false;
  List<TablaSincroLocalModel> _listTabsLocal = [];
  List<Map<String, bool>> _listTabsLocalCheck = [];
  TablaSincroLocalModel _tablaSincroLocalModel = new TablaSincroLocalModel();
  Map<String, List<Map<String, dynamic>>> _mapListFields = Map();
  DBDataEntry _db = new DBDataEntry();
  int userId = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<RelProfileTabsFieldsModal> _lstLocalFields = [];

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      userId = int.parse(_userInfo['id']);
    });
    _listTabsLocal = [];
    _listTabsLocalCheck = [];
    _lstLocalFields = [];
    fnCargarTabs();
  }

  @override
  Widget build(BuildContext context) {
    return fnListaPestanas();
  }

  Widget fnListaPestanas() {
    return Container(
      child: Scaffold(
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
              fnBackPage(context);
            },
          ),
          title: Text(
            titulo,
            style: TextStyle(
              color: DataEntryTheme.deBrownDark,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
        floatingActionButton: (widget.perfilId == 0
            ? FloatingActionButton(
                backgroundColor: Colors.green[600],
                onPressed: () {
                  fnDialogoNombreNuevoPerfil();
                },
                child: Icon(Icons.save),
              )
            : FloatingActionButton(
                backgroundColor: Colors.yellow[600],
                onPressed: () {
                  fnActualizarPerfilConRelacion(widget.perfilId);
                },
                child: Icon(Icons.update),
              )),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: RefreshIndicator(
            onRefresh: () {
              return fnCargarTabs();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Card(
                    child: Container(
                      color: Colors.blue[100],
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Text(
                        'Select tabs and fields to create a viewing profile for the holes.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: (_listTabsLocalCheck.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 60.0),
                            shrinkWrap: true,
                            itemCount: _listTabsLocalCheck.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return wCardTabItem(_listTabsLocalCheck[index]);
                            },
                          )
                        : errorWidget(
                            context: context,
                            titulo: "No results found.",
                            mensaje: "You may not have the catalogs synced.")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // #LISTAR CONFIGURACIONES DE TABS.
  Future<List<Map<String, bool>>> fnCargarTabs() async {
    var modal = new RelProfileTabsFieldsModal();
    await modal.fnCreateTable();
    _lstLocalFields = await modal.fnObtenerTodos();
    if (widget.perfilId == 1) {
      _lstLocalFields = await modal.fnObtenerTodos();
      print('Entro 1');
    } else {
      _lstLocalFields = await modal.fnObtenerFiltradoPorPerfil(widget.perfilId);
      print('Entro 2');
    }

    _listTabsLocal = await _tablaSincroLocalModel.fnObtenerTablasTipoPestanas();
    _listTabsLocalCheck = [];
    _mapListFields = Map();

    for (var item in _listTabsLocal) {
      bool seleccion = false;
      // #LLENAR CAMPOS.
      if (!_mapListFields.keys.contains('${item.nombreTabla}')) {
        List<Map<String, dynamic>> campos = await _tablaSincroLocalModel
            .fnObtenerCamposPorTabla(item.nombreTabla);
        _mapListFields['${item.nombreTabla}'] = [];
        for (Map<String, dynamic> campo in campos) {
          String field = campo['name'].toString().toLowerCase().trim();
          if (field.contains('id') == false &&
              field.contains('geolfrom') == false &&
              field.contains('geolto') == false &&
              field.contains('status') == false) {
            bool exist = false;
            var myListFiltered = _lstLocalFields.where((element) =>
                element.tabName == '${item.nombreTabla}' &&
                element.fieldName == campo['name']);
            if (myListFiltered.length > 0) {
              exist = true;
              seleccion = true;
            }
            _mapListFields['${item.nombreTabla}']!.add({campo['name']: exist});
          }
        }
      }
      // #CARGAR PRINCIPAL.
      _listTabsLocalCheck.add({item.nombreTabla: seleccion});
    }
    setState(() {});
    return _listTabsLocalCheck;
  }

  Widget wCardTabItem(Map<String, bool> item) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Container(
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: item.entries.first.value,
                    onChanged: (value) {
                      item['${item.entries.first.key}'] = value!;
                      for (var idx = 0;
                          idx <
                              _mapListFields['${item.entries.first.key}']!
                                  .length;
                          idx++) {
                        var key =
                            _mapListFields['${item.entries.first.key}']![idx]
                                .keys
                                .first;
                        _mapListFields['${item.entries.first.key}']![idx][key] =
                            value;
                      }
                      setState(() {});
                    }),
                Text(item.entries.first.key),
              ],
            ),
            childrenPadding:
                EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            children: [
              Container(
                color: Colors.grey[200],
                child: Column(
                  children: (_mapListFields['${item.entries.first.key}'] != null
                      ? List.generate(
                          _mapListFields['${item.entries.first.key}']!.length,
                          (index) {
                          return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: DataEntryTheme.deOrangeDark,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_mapListFields[
                                          '${item.entries.first.key}']![index]
                                      .keys
                                      .first),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.add),
                                            Text('Default value'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              value: _mapListFields[
                                      '${item.entries.first.key}']![index]
                                  .values
                                  .first,
                              onChanged: (value) {
                                var key = _mapListFields[
                                        '${item.entries.first.key}']![index]
                                    .keys
                                    .first;
                                setState(() {
                                  _mapListFields['${item.entries.first.key}']![
                                      index][key] = value;
                                });
                              });
                        })
                      : []),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void fnNuevoPerfil() async {
    bool resultado = false;
    var model = new RelProfileTabsFieldsModal();

    await _db.database.then((db) async {
      await db.delete(model.tbName);
      resultado = await db.transaction((txn) async {
        Batch batch = txn.batch();
        for (var entry in _mapListFields.entries) {
          for (var value in entry.value) {
            var campo = value.entries.first;
            if (campo.value) {
              batch.insert(model.tbName, {
                'profileId': 1,
                'tabName': entry.key,
                'fieldName': campo.key,
                'status': 1
              });
            }
          }
        }
        var result = await batch.commit();
        return (result.length > 0 ? true : false);
      });
    });
    if (resultado) {
      Navigator.pop(context);
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "The configuration was saved successfully.",
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "An error occurred while saving the configuration.",
      );
    }
  }

  TextEditingController _textFieldController = TextEditingController();

  Future<void> fnDialogoNombreNuevoPerfil() async {
    _textFieldController.text = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New profile.'),
            content: Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                controller: _textFieldController,
                decoration: InputDecoration(
                    hintText: "Enter the name of the new profile..."),
                validator: (value) {
                  if (value == null || value == '') {
                    return "Enter the name of the new profile...";
                  } else {
                    return null;
                  }
                },
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
                  String nuevoNombre = _textFieldController.text;
                  await fnNuevoPerfilConRelacion(nuevoNombre);
                },
              ),
            ],
          );
        });
  }

  Future<bool> fnNuevoPerfilConRelacion(String nombrePerfil) async {
    bool resultado = false;
    ProfileTabsFieldsModel perfil = new ProfileTabsFieldsModel();

    bool existe = await perfil.fnYaExisteElPerfil(nombrePerfil, this.userId);

    if (!existe) {
      perfil.userId = this.userId;
      perfil.profileName = nombrePerfil;
      perfil.status = 1;

      RelProfileTabsFieldsModal item;
      List<RelProfileTabsFieldsModal> relaciones = [];

      for (var entry in _mapListFields.entries) {
        for (var value in entry.value) {
          var campo = value.entries.first;
          if (campo.value) {
            item = new RelProfileTabsFieldsModal();
            item.profileId = 0;
            item.tabName = entry.key;
            item.fieldName = campo.key;
            item.status = 1;
            relaciones.add(item);
          }
        }
      }

      resultado = await perfil.fnInsertarPerfilConRelacion(perfil, relaciones);

      if (resultado) {
        Navigator.pop(context);
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Profile created successfully.",
            onConfirmBtnTap: () {
              Navigator.pop(context);
              //Navigator.pop(context);
              fnBackPage(context);
            });
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "An error occurred while creating the profile.",
        );
      }
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "This profile name already exists.",
      );
    }

    return resultado;
  }

  Future<bool> fnActualizarPerfilConRelacion(int perfilId) async {
    bool resultado = false;

    RelProfileTabsFieldsModal item;
    List<RelProfileTabsFieldsModal> relaciones = [];

    for (var entry in _mapListFields.entries) {
      for (var value in entry.value) {
        var campo = value.entries.first;
        if (campo.value) {
          item = new RelProfileTabsFieldsModal();
          item.profileId = perfilId;
          item.tabName = entry.key;
          item.fieldName = campo.key;
          item.status = 1;
          relaciones.add(item);
        }
      }
    }

    resultado = await RelProfileTabsFieldsModal()
        .fnActualizarRelacion(perfilId, relaciones);

    if (resultado) {
      //Navigator.pop(context);
      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Profile updated successfully.",
          onConfirmBtnTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            //Navigator.pop(context);
            fnBackPage(context);
          });
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "An error occurred while updating the profile.",
      );
    }

    return resultado;
  }
}

void fnBackPage(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => TabsFieldConfigPage()));
}
