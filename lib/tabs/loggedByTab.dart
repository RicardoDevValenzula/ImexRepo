import 'dart:developer';

import 'package:data_entry_app/models/LoggedByModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class LoggedByTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  final String fechaFinal;
  final String fechaInicio;

  LoggedByTab({
    Key? key,
    required this.pageEvent,
    required this.holeId,
    required this.totalDepth,
    required this.fechaInicio,
    required this.fechaFinal,
  }) : super(key: key);

  @override
  LoggedByTabState createState() => LoggedByTabState(pageEvent: pageEvent);
}

class LoggedByTabState extends State<LoggedByTab> {
  final ValueChanged<bool> pageEvent;
  LoggedByTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _geolFrom = TextEditingController();
  TextEditingController _geolTo = TextEditingController();
  TextEditingController _geologist = TextEditingController();
  TextEditingController _dateLoggedCtrl = TextEditingController();

  DateTime? _dateLogged = DateTime.now();
  String _dateEndCollar = '';
  String _dateStartCollar = '';
  late List<Map<String, dynamic>> _itemsGeologist = [];
  final List<Map<String, dynamic>> _items = [];
  List<DataRow> _cells = [];
  String errors = "";
  String _valueChanged = '';
  //String _initial_item = '';
  String tabla = 'tb_loggedby';
  String fechaloca = '';
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
  int selectedRow = 0;
  bool onUpdate = false;
  String geoigsttext = '';
  String _initial_item_field = '';

  bool geolFromDifference = false;
  bool geolToDifference = false;
  bool candado = false;

  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _db
        .fnRegistrosValueGeolog(tbName: 'cat_geologist', holeid: widget.holeId)
        .then((rows) {
      setState(() {
        _itemsGeologist = rows;
      });
    });

    _db
        .fnObtenerRegistro(
            nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId)
        .then((rows) {
      setState(() {
        String fechaInicio = rows.values.elementAt(7) ?? '';
        String fechaFinal = rows.values.elementAt(8) ?? '';

        log('${rows.values.elementAt(34)}');

        if (rows.values.elementAt(7) != null ||
            rows.values.elementAt(8) != null) {
          _dateStartCollar = fechaInicio;
          _dateEndCollar = fechaFinal;
        }

        if (rows.values.elementAt(34) == 1) {
          candado = true;
        }
      });
    });

    fnCargarTabs();
    fnLlenarLoggedBy(widget.holeId);

    //log('${fnLlenarLoggedBy(widget.holeId)}');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'LoggedBy Tab',
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
                                        double.parse(_geolFrom.text) ||
                                    double.parse(_geolTo.text) >
                                        widget.totalDepth) {
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
          sFM(_geologist, _itemsGeologist, 'Geologist'),
          SizedBox(
            height: 10,
          ),
          labelInput('Date Logged'),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: Visibility(
              visible: true,
              child: DateTimeField(
                controller: _dateLoggedCtrl,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
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
                  hintText: 'Date Logged',
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 15),
                  prefixIcon: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.black,
                  ),
                ),
                format: DateFormat("MM/dd/yyyy"),
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                },
                onChanged: (date) {
                  setState(() {
                    _dateLogged = date;

                    //log('${_dateEndCollar}');
                    //log('${_dateStartCollar}');

                    pageEvent(true);
                  });
                },
              ),
            ),
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
                            await insertLoggedBy();
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
                        await actualizarLoggedBy();
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
                      'Geologist',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'DateLogged',
                      textAlign: TextAlign.center,
                    ),
                    numeric: true,
                  ),
                ],
                rows: _cells),
          ),
        ],
      ),
    );
  }

  String selectedItem = "";

  Widget sFM(TextEditingController sfm_controller,
      List<Map<String, dynamic>> sfm_items, sfm_label) {
    return Visibility(
        visible: (_items.any((element) => element.values.contains('Geologist')))
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

  Future<void> insertLoggedBy() async {
    FocusScope.of(context).unfocus();
    /*
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );

     */
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _geolFrom.text,
      'Chk': 0,
      'GeolTo': _geolTo.text,
      'Geologist': _geologist.text.toString(),
      'DateLogged': _dateLogged.toString(),
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
      registerLoggedBy(valores);
    } else {
      if (errors != '') {
        Loader.hide();
        CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
          type: CoolAlertType.warning,
          title: 'Confirmation',
          text: 'The following errors have been detected:\n\n' + errors,
          onConfirmBtnTap: () => Navigator.pop(context),
        );
      }
    }
  }

  Future<void> registerLoggedBy(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    valores['status_sync'] = 4;
    int response = await _db.fnInsertarRegistro('tb_loggedby', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarLoggedBy(widget.holeId);
      _geolTo.clear();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'LoggedBy data has been saved successfully',
      );
    }
  }

  Future<void> actualizarLoggedBy() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'Geolto': double.parse(_geolTo.text).toStringAsFixed(3),
      'GeolFrom': double.parse(_geolFrom.text).toStringAsFixed(3),
      'Chk': 0,
      'GeolTo': double.parse(_geolTo.text).toStringAsFixed(3),
      'Geologist': _geologist.text,
      'DateLogged': _dateLogged.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
      int response = await _db.fnActualizarRegistro(
          'tb_loggedby', valores, 'Id', selectedRow);
      if (response > 0) {
        await fnLlenarLoggedBy(widget.holeId);
        selectedRow = 0;
        onUpdate = false;
        _geolTo.clear();
        setState(() {});
        Loader.hide();
        CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
          type: CoolAlertType.success,
          title: "Success!",
          text: 'LoggedBy data has been updated successfully',
        );
      }
    } else {
      if (errors != '') {
        Loader.hide();
        CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
          type: CoolAlertType.warning,
          title: 'Confirmation',
          text: 'The following errors have been detected:\n\n' + errors,
          onConfirmBtnTap: () => Navigator.pop(context),
        );
      }
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
        errors += '• The value of GeolFrom cannot be greater than TotalDepth(' +
            widget.totalDepth.toString() +
            ') of Collar.\n';
      }

      if (double.parse(valores['GeolTo'].toString()) > widget.totalDepth) {
        errors += '• The value of GeolTo cannot be greater than TotalDepth(' +
            widget.totalDepth.toString() +
            ') of Collar.\n';
      }

      if (valores['DateLogged'] != '') {
        DateTime dtStart = DateTime.parse(widget.fechaInicio);
        DateTime? dtEnd;

        if (widget.fechaFinal == '') {
          dtEnd = DateTime.now();
        } else {
          dtEnd = DateTime.parse(widget.fechaFinal);
        }
        DateTime dtLogged = DateTime.parse(valores['DateLogged'].toString());
        log('${dtStart}');
        log('${dtLogged}');
        if (dtLogged.isBefore(dtStart)) {
          Loader.hide();
          message(CoolAlertType.error, 'Incorrect data',
              'The date Logged is before the Date of the collar');
          return false;
        }

        if (dtLogged.isAfter(dtEnd)) {
          Loader.hide();
          message(CoolAlertType.error, 'Incorrect data',
              'The date Logged is After the Date of the collar');
          return false;
        }
      }

      // #INSERT.
      if (!onUpdate) {
        if (double.parse(valores['GeolFrom'].toString()) >
            double.parse(_lastGeolTo.toString())) {
          errors += '• Your last GeolTo was "' +
              _lastGeolTo.toString() +
              '" and your GeolFrom is "' +
              valores['GeolFrom'].toString() +
              '", so there is a difference.\n';
        }
      } else {}
      // #UPDATE.
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

  Future<void> fnLlenarLoggedBy(int collarId) async {
    double _geolTo = 0;
    _cells.clear();
    int currentRow = 0;
    List<LoggedByModel> listLoggedByModel = await new LoggedByModel()
        .fnObtenerRegistrosPorCollarId(
            collarId: collarId, orderByCampo: 'GeolFrom')
        .then((value) => value);
    listLoggedByModel.forEach((model) {
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
              Text('${model.geologistName}'),
            ),
            DataCell(
              Text(formatDate(
                  DateTime.parse(model.dateLogged), [mm, '/', dd, '/', yyyy])),
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
                              nombreTabla: 'tb_loggedby',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _geolFrom.text = rows.values.elementAt(2).toString();
                          _geolTo.text = rows.values.elementAt(3).toString();
                          _geologist.text = rows.values.elementAt(5).toString();
                          if (rows.values.elementAt(6).toString() != '') {
                            _dateLoggedCtrl.text = DateFormat('MM/dd/yyyy')
                                .format(DateTime.parse(
                                    rows.values.elementAt(6).toString()));
                            _dateLogged = DateTime.parse(
                                rows.values.elementAt(6).toString());
                          }

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
        fnEliminarLoggedBy(selectedRow);
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
        .fnObtenerCamposActivas(widget.holeId, 'tb_loggedby');
    if (tb.length > 0) {
      for (RelProfileTabsFieldsModal item in tb) {
        String nombre = item.fieldName;
        String capNombre = nombre.toUpperCase();
        if (nombre == 'DateLogged') {}
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

  Future<void> fnEliminarLoggedBy(int id) async {
    await new LoggedByModel()
        .fnEliminarRegistro(nombreTabla: 'tb_loggedby', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarLoggedBy(widget.holeId);
      }
    });
    /*await new LoggedByModel()
        .fnEliminarRegistro('tb_loggedby','Id',id)
        .then((value) => value);*/
    //setState(() {});
  }
}
