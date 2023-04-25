import 'package:data_entry_app/models/DiameterModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class DiameterTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  DiameterTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  DiameterTabState createState() => DiameterTabState(pageEvent: pageEvent);
}

class DiameterTabState extends State<DiameterTab> {
  final ValueChanged<bool> pageEvent;
  DiameterTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _StartDepthCtrl = TextEditingController();
  TextEditingController _EndDepthCtrl = TextEditingController();
  //TextEditingController _ChkCtrl = TextEditingController();
  TextEditingController _DiameterTypeCtrl = TextEditingController();
  TextEditingController _DrillTypeCtrl = TextEditingController();
  TextEditingController _CaseTypeCtrl = TextEditingController();
  TextEditingController _CaseDiameterCtrl = TextEditingController();
  TextEditingController _Comments = TextEditingController();

  late List<Map<String, dynamic>> _itemsDiameterType = [];
  late List<Map<String, dynamic>> _itemsDrillType = [];
  late List<Map<String, dynamic>> _itemsCaseType = [];
  late List<Map<String, dynamic>> _itemsCaseDiameter = [];
  List<DataRow> _cells = [];
  String errors = "";
  int selectedRow = 0;
  bool onUpdate = false;
  bool candado = false;

  bool geolFromDifference = false;
  bool geolToDifference = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  @override
  void initState() {
    super.initState();
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_diametertype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsDiameterType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_drilltype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsDrillType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_casetype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsCaseType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_casediameter', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsCaseDiameter = rows;
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
    fnLlenarDiameter(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Diameter Tab',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Startdepth')))
              ? labelInput('Start Depth')
              : labelInput(''),
          Container(
              child: Visibility(
            visible:
                (_items.any((element) => element.values.contains('Startdepth')))
                    ? true
                    : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Start Depth',
              controller: _StartDepthCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Enddepth')))
              ? labelInput('End Depth')
              : labelInput(''),
          Container(
              child: Visibility(
            visible:
                (_items.any((element) => element.values.contains('Enddepth')))
                    ? true
                    : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'end Depth',
              controller: _EndDepthCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                if (int.tryParse(value)! > widget.totalDepth) {
                  message(CoolAlertType.error, 'Incorrect data',
                      'The End Depth cannot be grater than the total collar depth');
                  _EndDepthCtrl.clear();
                }
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('DiameterType')))
              ? sFM(_DiameterTypeCtrl, _itemsDiameterType, 'Diameter Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('DrillType')))
              ? sFM(_DrillTypeCtrl, _itemsDrillType, 'Drill Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('CaseType')))
              ? sFM(_CaseTypeCtrl, _itemsCaseType, 'Case Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('CaseDiameter')))
              ? sFM(_CaseDiameterCtrl, _itemsCaseDiameter, 'Case Diameter')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Comments')))
              ? labelInput('Comments')
              : labelInput(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Visibility(
              visible: (_items.any(
                      (element) => element.values.contains('DIameterComment')))
                  ? true
                  : false,
              child: BsInput(
                maxLines: null,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                style: BsInputStyle.outline,
                size: BsInputSize.md,
                hintText: 'Comments',
                controller: _Comments,
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
                            await insertDownholeSurvey();
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
                        await actualizarDiameter();
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
                minWidth: 600,
                columns: [
                  DataColumn2(
                    label: Text(
                      'Start Depth',
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Start Depth',
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Diameter Type',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Drill Type',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Case Type',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Case Diameter',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Comments',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                rows: _cells),
          ),
        ],
      ),
    );
  }

  Widget sFM(TextEditingController sfm_controller,
      List<Map<String, dynamic>> sfm_items, sfm_label) {
    return Container(
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
            hintStyle:
                TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 15),
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
          onChanged: (val) {
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

  Future<void> insertDownholeSurvey() async {
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
      'Startdepth': double.tryParse(
          _StartDepthCtrl.text.isEmpty ? '0.0' : _StartDepthCtrl.text),
      'Enddepth': double.tryParse(
          _EndDepthCtrl.text.isEmpty ? '0' : _EndDepthCtrl.text),
      'DiameterType': int.parse(
          _DiameterTypeCtrl.text.isEmpty ? '0' : _DiameterTypeCtrl.text),
      'DrillType':
          int.tryParse(_DrillTypeCtrl.text.isEmpty ? '0' : _DrillTypeCtrl.text),
      'CaseType':
          int.tryParse(_CaseTypeCtrl.text.isEmpty ? '0' : _CaseTypeCtrl.text),
      'CaseDiameter': int.tryParse(
          _CaseDiameterCtrl.text.isEmpty ? '0' : _CaseDiameterCtrl.text),
      'DIameterComment': _Comments.text,
      'status': 1
    };
    if (await validateRequired(valores)) {
      Loader.show(
        context,
        isAppbarOverlay: true,
        isBottomBarOverlay: true,
        progressIndicator: widgetLoading(context),
        overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
      );
      registerDownholeSurvey(valores);
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
              await registerDownholeSurvey(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> registerDownholeSurvey(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    valores['status_sync'] = 4;
    int response = await _db.fnInsertarRegistro('tb_diameter', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarDiameter(widget.holeId);

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Diameter data has been saved successfully',
      );
    }
  }

  Future<void> actualizarDiameter() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'Startdepth': double.tryParse(_StartDepthCtrl.text.toString()),
      'Enddepth': int.tryParse(_EndDepthCtrl.text.toString()),
      'DiameterType': int.parse(_DiameterTypeCtrl.text.toString()),
      'DrillType': int.tryParse(_DrillTypeCtrl.text.toString()),
      'CaseType': int.tryParse(_CaseTypeCtrl.text.toString()),
      'CaseDiameter': int.tryParse(_CaseDiameterCtrl.text.toString()),
      'DIameterComment': _Comments.text.toString(),
      'status': 1
    };
    int response = await _db.fnActualizarRegistro(
        'tb_diameter', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarDiameter(widget.holeId);
      selectedRow = 0;
      onUpdate = false;
      setState(() {});

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Diameter data has been updated successfully',
      );
    }
  }

  Future<dynamic> validateRequired(Map<String, Object?> valores) async {
    errors = '';

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

  /*Future<void> _addRowTable() async {
    _cells.add(DataRow(cells: [
      DataCell(Text(
        double.parse(_geolFrom.text).toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        double.parse(_geolTo.text).toString(),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_geologist', 'id', int.parse(_geologist.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        DateFormat('MM/dd/yyyy').format(_dateLogged ?? DateTime.now()),
        textAlign: TextAlign.center,
      )),
    ]));
    _lastGeolFrom = double.parse(_geolFrom.text);
    _lastGeolTo = double.parse(_geolTo.text);
    _geolFrom.text = _geolTo.text;
    _geolTo.clear();
  }*/

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

  Future<void> fnLlenarDiameter(int collarId) async {
    _cells.clear();
    List<DiameterModel> listDiameterModel = await new DiameterModel()
        .fnObtenerRegistrosPorCollarId(
            collarId: collarId, orderByCampo: 'Startdepth')
        .then((value) => value);
    listDiameterModel.forEach((model) {
      _cells.add(
        DataRow(
          cells: [
            DataCell(
              Text('${model.start_depth.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.end_depth.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.diameterTypeName}'),
            ),
            DataCell(
              Text('${model.drillTypeName.toString()}'),
            ),
            DataCell(
              Text('${model.caseTypeName.toString()}'),
            ),
            DataCell(
              Text('${model.caseDiameterName.toString()}'),
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
    });

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
                              nombreTabla: 'tb_diameter',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _StartDepthCtrl.text =
                              rows.values.elementAt(2).toString();
                          _EndDepthCtrl.text =
                              rows.values.elementAt(3).toString();
                          _DiameterTypeCtrl.text =
                              rows.values.elementAt(5).toString();
                          _DrillTypeCtrl.text =
                              rows.values.elementAt(6).toString();
                          _CaseTypeCtrl.text =
                              rows.values.elementAt(7).toString();
                          _CaseDiameterCtrl.text =
                              rows.values.elementAt(8).toString();
                          _Comments.text = rows.values.elementAt(9).toString();
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
        fnEliminarDiameter(selectedRow);
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
        .fnObtenerCamposActivas(widget.holeId, 'tb_diameter');
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

  Future<void> fnEliminarDiameter(int id) async {
    await new DiameterModel()
        .fnEliminarRegistro(nombreTabla: 'tb_diameter', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarDiameter(widget.holeId);
      }
    });
  }
}
