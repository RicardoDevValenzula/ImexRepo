import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/models/StructureModel.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class StructureTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  StructureTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  StructureTabState createState() => StructureTabState(pageEvent: pageEvent);
}

class StructureTabState extends State<StructureTab> {
  final ValueChanged<bool> pageEvent;
  StructureTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _geolFrom = TextEditingController();
  TextEditingController _geolTo = TextEditingController();
  TextEditingController _strucTypeCtrl = TextEditingController();
  TextEditingController _strucAngleCtrl = TextEditingController();
  TextEditingController _strucCommentsCtrl = TextEditingController();

  //DateTime? _dateLogged = DateTime.now();
  late List<Map<String, dynamic>> _itemsStructureType = [];
  List<DataRow> _cells = [];
  String errors = "";
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
  int selectedRow = 0;
  bool onUpdate = false;
  bool candado = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  bool geolFromDifference = false;
  bool geolToDifference = false;

  @override
  void initState() {
    super.initState();
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_structype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsStructureType = rows;
      });
    });
    _db
        .fnObtenerRegistro(
            nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId)
        .then((rows) {
      setState(() {
        if (rows.values.elementAt(34) == 1) {
          candado = true;
        }
      });
    });
    fnCargarTabs();
    fnLlenarStructure(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Structure Tab',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: [
                    labelInput('GeolFrom'),
                    Container(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                            controller: _geolFrom,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 14.0,
                                  right: 14.0,
                                  top: 14.0,
                                  bottom: 14.0),
                              prefixIcon: Icon(Icons.label_important),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "GeolFrom",
                              fillColor: (geolFromDifference)
                                  ? Colors.yellow
                                  : Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 2.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                              ),
                            ),
                            onChanged: (text) {
                              geolFromDifference = false;
                              if (isNumeric(_geolFrom.text) &&
                                  _lastGeolTo != 0.0 &&
                                  _lastGeolTo !=
                                      double.tryParse(_geolFrom.text)) {
                                geolFromDifference = true;
                              }
                              setState(() {});
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: Column(
                  children: [
                    labelInput('GeolTo'),
                    Container(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                            controller: _geolTo,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 14.0,
                                  right: 14.0,
                                  top: 14.0,
                                  bottom: 14.0),
                              prefixIcon: Icon(Icons.label_important),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[800]),
                              hintText: "GeolTo",
                              fillColor: (geolToDifference)
                                  ? Colors.red
                                  : Colors.white70,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 2.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                              ),
                            ),
                            onChanged: (text) {
                              geolToDifference = false;
                              if (isNumeric(_geolFrom.text) &&
                                  isNumeric(_geolTo.text)) {
                                if (double.parse(_geolTo.text) <=
                                    double.parse(_geolFrom.text)) {
                                  geolToDifference = true;
                                }
                              }
                              setState(() {});
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          sFM(_strucTypeCtrl, _itemsStructureType, 'Structure_Type1'),
          SizedBox(
            height: 10,
          ),
          labelInput('Struc_Angle'),
          Container(
              child: Visibility(
            visible: (_items
                    .any((element) => element.values.contains('Struc_Angle')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Struc_Angle',
              controller: _strucAngleCtrl,
              prefixIcon: Icons.list_alt_rounded,
              //keyboardType: TextInputType.numberWithOptions(),
            ),
          )),
          SizedBox(
            height: 10,
          ),
          labelInput('Structure_Comment'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Visibility(
              visible: (_items.any((element) =>
                      element.values.contains('Structure_Comment')))
                  ? true
                  : false,
              child: BsInput(
                maxLines: null,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                style: BsInputStyle.outline,
                size: BsInputSize.md,
                hintText: 'Structure_Comment',
                controller: _strucCommentsCtrl,
                prefixIcon: Icons.comment,
                onChange: (text) {
                  setState(() {
                    pageEvent(true);
                  });
                },
              ),
            )),
          ),
          SizedBox(
            height: 20,
          ),
          (!onUpdate)
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton.icon(
                    onPressed: candado
                        ? null
                        : () async {
                            await insertStructure();
                            setState(() {});
                          },
                    style: ElevatedButton.styleFrom(
                        primary: DataEntryTheme.deOrangeDark,
                        alignment: Alignment.center),
                    icon: Icon(Icons.add_circle_outline, size: 18),
                    label: Text("ADD ROW"),
                  ),
                )
              : Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.cancel,
                        size: 24.0,
                      ),
                      onPressed: () {
                        onUpdate = false;
                        selectedRow = 0;
                        setState(() {});
                      },
                      label: Text("Cancel"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 18))),
                    )),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Expanded(
                        child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.check,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        await actualizarStructure();
                      },
                      label: Text("Update"),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(10)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 18))),
                    )),
                  ],
                ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 500,
            height: 200,
            child: DataTable2(
                showCheckboxColumn: false,
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 900,
                columns: [
                  DataColumn2(
                    label: Text(
                      'GeolFrom',
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'GeolTo',
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Structure_Type1',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Struc_Angle',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Comment',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                rows: _cells),
          )
        ],
      ),
    );
  }

  Widget sFM(TextEditingController sfm_controller,
      List<Map<String, dynamic>> sfm_items, sfm_label) {
    return Visibility(
        visible: (_items
                .any((element) => element.values.contains('Structure_Type1')))
            ? true
            : false,
        child: Column(
          children: [
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      sfm_label,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SelectFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                contentPadding: EdgeInsets.all(15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: sfm_label,
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5), fontSize: 15),
                prefixIcon: Icon(
                  Icons.list_alt_rounded,
                  color: Colors.black,
                ),
                suffixIcon: Icon(
                  Icons.list,
                  color: Colors.black,
                ),
              ),
              type: SelectFormFieldType.dialog,
              controller: sfm_controller,
              icon: Icon(Icons.filter_list),
              changeIcon: true,
              dialogTitle: 'Choose a ${sfm_label}',
              dialogCancelBtn: 'CANCEL',
              enableSearch: true,
              dialogSearchHint: 'Search option',
              items: sfm_items,
              //labelText: geoigsttext,
              onChanged: (val) async {
                setState(() {
                  pageEvent(true);
                });
              },
              /*validator: (val) {
            setState(() => sfm_validate = val ?? '');
            return null;
          },
          onSaved: (val) => setState(() => sfm_value_saved = val ?? ''),*/
            ),
          ],
        ));
  }

  Widget labelInput(text) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 5),
            child: Text(
              text,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }

  Future<void> insertStructure() async {
    FocusScope.of(context).unfocus();
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _geolFrom.text,
      'Chk': 0,
      'GeolTo': _geolTo.text,
      'Structure_Type1': int.tryParse(_strucTypeCtrl.text.toString()),
      'Struc_Angle': _strucAngleCtrl.text.toString(),
      'Structure_Comment': _strucCommentsCtrl.text.toString(),
      'status': 1
    };

    print(valores);

    if (await validateRequired(valores)) {
      Loader.show(
        context,
        isAppbarOverlay: true,
        isBottomBarOverlay: true,
        progressIndicator: widgetLoading(context),
        overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
      );
      registerStructure(valores);
    } else {
      if (errors != '') {
        Loader.hide();
        CoolAlert.show(
            context: context,
            backgroundColor: DataEntryTheme.deGrayLight,
            confirmBtnColor: DataEntryTheme.deGrayDark,
            showCancelBtn: true,
            confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
            cancelBtnText: 'Cancel',
            cancelBtnTextStyle: TextStyle(color: DataEntryTheme.deBlack),
            type: CoolAlertType.warning,
            title: 'Confirmation',
            text: 'The following errors have been detected:\n\n' +
                errors +
                '\n\nDo you want to proceed to record the data?',
            onConfirmBtnTap: () async {
              Navigator.pop(context);
              await registerStructure(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> registerStructure(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    int response = await _db.fnInsertarRegistro('tb_structure', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarStructure(widget.holeId);
      _geolTo.clear();
      _strucTypeCtrl.clear();
      _strucAngleCtrl.clear();
      _strucCommentsCtrl.clear();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Structure data has been saved successfully',
      );
    }
  }

  Future<void> actualizarStructure() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _geolFrom.text,
      'Chk': 0,
      'GeolTo': _geolTo.text,
      'Structure_Type1': int.tryParse(_strucTypeCtrl.text.toString()),
      'Struc_Angle': _strucAngleCtrl.text.toString(),
      'Structure_Comment': _strucCommentsCtrl.text.toString(),
      'status': 1
    };
    int response = await _db.fnActualizarRegistro(
        'tb_structure', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarStructure(widget.holeId);
      selectedRow = 0;
      onUpdate = false;
      _geolTo.clear();
      _strucTypeCtrl.clear();
      _strucAngleCtrl.clear();
      _strucCommentsCtrl.clear();
      setState(() {});

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Structure data has been updated successfully',
      );
    }
  }

  Future<dynamic> validateRequired(Map<String, Object?> valores) async {
    errors = '';
    if (valores['GeolFrom'].toString() == '' ||
        !isNumeric(valores['GeolFrom'].toString())) {
      /*errors += '• Please enter the GeolFrom (numeric)\n';*/
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the GeolFrom (numeric)');

      return false;
    }
    if (!isNumeric(valores['GeolTo'].toString())) {
      //errors += '• Please enter the GeolTo (numeric)\n';
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the GeolTo (numeric)');

      return false;
    }
    if (isNumeric(valores['GeolFrom'].toString()) &&
        isNumeric(valores['GeolTo'].toString())) {
      if (double.parse(valores['GeolFrom'].toString()) >
          double.parse(valores['GeolTo'].toString())) {
        //errors += '• The value of GeolFrom cannot be greater than GeolTo.\n';
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The value of GeolFrom cannot be greater than GeolTo.');

        return false;
      }
      if (double.parse(valores['GeolFrom'].toString()) > widget.totalDepth) {
        /*
        errors += '• The value of GeolFrom cannot be greater than TotalDepth(' +
            widget.totalDepth.toString() +
            ') of Collar.\n';
         */
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The value of GeolFrom cannot be greater than ${widget.totalDepth}');
        return false;
      }

      if (double.parse(valores['GeolTo'].toString()) > widget.totalDepth) {
        /*
        errors += '• The value of GeolTo cannot be greater than TotalDepth(' +
            widget.totalDepth.toString() +
            ') of Collar.\n';
         */
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The value of GeolTo cannot be greater than ${widget.totalDepth}');
        return false;
      }

      if (valores['Structure_Type1'] == null) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'Please select a Structure Type.');
        return false;
      }

      if (valores['Struc_Angle'] != null) {
        if (!isNumeric(valores['Struc_Angle'].toString())) {
          Loader.hide();
          message(CoolAlertType.error, 'Incorrect data',
              'The value of Structure Angle is not a number.');
          return false;
        }
      }

      if (!onUpdate) {
        if (double.parse(valores['GeolFrom'].toString()) >
            double.parse(_lastGeolTo.toString())) {
          errors += '• Your last GeolTo was "' +
              _lastGeolTo.toString() +
              '" and your GeolFrom is "' +
              valores['GeolFrom'].toString() +
              '", so there is a difference.\n';
        }

        if (double.parse(valores['GeolFrom'].toString()) <
            double.parse(_lastGeolTo.toString())) {
          errors += '• Your last GeolTo was "' +
              _lastGeolTo.toString() +
              '" and your GeolFrom is "' +
              valores['GeolFrom'].toString() +
              '", therefore you are overlapping values.\n';
        }
      }
    }

    if (isNumeric(valores['Struc_Angle'].toString()) &&
        double.parse(valores['Struc_Angle'].toString()) > 90) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Struc_Angle data cannot be greater than 90.');

      return false;
    }

    if (errors != '') {
      return false;
    } else {
      return true;
    }
  }

  void message(CoolAlertType type, title, message) {
    CoolAlert.show(
      context: context,
      backgroundColor: DataEntryTheme.deGrayLight,
      confirmBtnColor: DataEntryTheme.deGrayDark,
      confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
      type: type,
      title: title,
      text: message,
    );
  }

  bool isNumeric(String string) {
    // Null or empty string is not a number
    if (string.isEmpty) {
      return false;
    }

    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = double.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  Future<String> getOptionString(String table, String field, int where) async {
    String response = "Empty";
    await _db
        .fnObtenerRegistro(nombreTabla: table, campo: field, valor: where)
        .then((rows) {
      setState(() {
        response = rows.values.elementAt(1).toString();
        //_geologistString = rows.values.elementAt(1);
      });
    }).onError((error, stackTrace) {
      response = error.toString();
    });

    return response;
  }

  Future<void> fnLlenarStructure(int collarId) async {
    double _geolTo = 0;
    _geolFrom.text = '';
    _cells.clear();
    int currentRow = 0;
    List<StructureModel> listStructureModel = await new StructureModel()
        .fnObtenerRegistrosPorCollarId(
            collarId: collarId, orderByCampo: 'GeolFrom')
        .then((value) => value);
    _lastGeolTo = 0;
    listStructureModel.forEach((model) {
      Color cell_color = Colors.black;
      currentRow++;
      if (double.parse(model.geolFrom.toStringAsFixed(3)) > _lastGeolTo ||
          double.parse(model.geolFrom.toStringAsFixed(3)) < _lastGeolTo) {
        if (currentRow == 1 &&
            double.parse(model.geolFrom.toStringAsFixed(3)) == 0) {
          cell_color = Colors.black;
        } else {
          cell_color = Colors.red;
        }
      }
      _cells.add(
        DataRow(
          cells: [
            DataCell(
              Text(
                '${model.geolFrom.toStringAsFixed(3)}',
                style: TextStyle(color: cell_color),
              ),
            ),
            DataCell(
              Text('${model.geolTo.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.structureType}'),
            ),
            DataCell(
              Text('${model.structure_angle}'),
            ),
            DataCell(
              Text('${model.comments}'),
            ),
          ],
          onSelectChanged: candado
              ? null
              : (newValue) {
                  _getSelectedRowInfo(model);
                },
        ),
      );
      //_lastGeolFrom = double.parse(model.geolFrom.toString());
      _lastGeolTo = double.parse(model.geolTo.toString());
      _geolTo = model.geolTo;
    });
    if (_geolTo != 0) {
      _geolFrom.text = _geolTo.toString();
    }
    setState(() {});
  }

  void _getSelectedRowInfo(model) {
    selectedRow = model.id;
    setState(() {});
    _settingModalBottomSheet(context);
  }

  void _settingModalBottomSheet(context) {
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
                    'Actions to do',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(10.00),
                ),
                Divider(),
                new ListTile(
                    leading: new Icon(Icons.edit, color: Colors.green),
                    title: new Text('Edit record'),
                    onTap: () async {
                      await _db
                          .fnObtenerRegistro(
                              nombreTabla: 'tb_structure',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _geolFrom.text = rows.values.elementAt(2).toString();
                          _geolTo.text = rows.values.elementAt(3).toString();
                          _strucTypeCtrl.text =
                              rows.values.elementAt(5).toString();
                          _strucAngleCtrl.text =
                              rows.values.elementAt(6).toString();
                          _strucCommentsCtrl.text =
                              rows.values.elementAt(7).toString();

                          //_geologistString = rows.values.elementAt(1);
                        });
                      }).onError((error, stackTrace) {
                        //response = error.toString();
                      });
                      Navigator.pop(context);
                      onUpdate = true;
                      setState(() {});
                    }),
                new ListTile(
                  leading: new Icon(Icons.delete, color: Colors.red),
                  title: new Text('Delete'),
                  onTap: () => {showAlertDialog(context)},
                ),
              ],
            ),
          );
        });
  }

  showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.pop(context);
        fnEliminarStructure(selectedRow);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure ?"),
      content: Text("The information will be erased and cannot be recovered."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> fnCargarTabs() async {
    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerCamposActivas(widget.holeId, 'tb_structure');
    if (tb.length > 0) {
      for (RelProfileTabsFieldsModal item in tb) {
        String nombre = item.fieldName;
        String capNombre = nombre.toUpperCase();
        _items.add({
          'value': nombre,
          'label': capNombre,
          'icon': Icon(Icons.tab_unselected),
        });
      }
      setState(() {
        _initial_item_field = tb.first.fieldName;
        _valueChanged = _initial_item_field;
      });
    }
    return true;
  }

  Future<void> fnEliminarStructure(int id) async {
    await new StructureModel()
        .fnEliminarRegistro(nombreTabla: 'tb_structure', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarStructure(widget.holeId);
      }
    });
    /*await new StructureModel()
        .fnEliminarRegistro('tb_structure','Id',id)
        .then((value) => value);*/
    //setState(() {});
  }
}
