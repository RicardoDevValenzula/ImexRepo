import 'package:data_entry_app/models/DownholeSurveyModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:intl/intl.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class DownholeSurveysTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  final String fechaFinal;
  final String fechaInicio;
  DownholeSurveysTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth,
      required this.fechaInicio,
      required this.fechaFinal})
      : super(key: key);

  @override
  DownholeSurveysTabState createState() =>
      DownholeSurveysTabState(pageEvent: pageEvent);
}

class DownholeSurveysTabState extends State<DownholeSurveysTab> {
  final ValueChanged<bool> pageEvent;
  DownholeSurveysTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _DepthCtrl = TextEditingController();
  TextEditingController _SurveyTypeCtrl = TextEditingController();
  TextEditingController _DipCtrl = TextEditingController();
  TextEditingController _AzimuthCtrl = TextEditingController();
  TextEditingController _AzimuthTypeCtrl = TextEditingController();
  TextEditingController _SurveyDateCtrl = TextEditingController();
  TextEditingController _CommentsCtrl = TextEditingController();

  //DateTime? _dateSurvey = DateTime.now();
  late List<Map<String, dynamic>> _itemsSurvType = [];
  late List<Map<String, dynamic>> _itemsAzimuthType = [];
  DateTime? _dateSurv_Dte = DateTime.now();
  String _dateEndCollar = '';
  String _dateStartCollar = '';
  List<DataRow> _cells = [];
  String errors = "";
  int selectedRow = 0;
  bool onUpdate = false;

  bool geolFromDifference = false;
  bool geolToDifference = false;
  bool candado = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  @override
  void initState() {
    super.initState();
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_surveytype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsSurvType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_azimuthtype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsAzimuthType = rows;
      });
    });
    _db
        .fnObtenerRegistro(
            nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId)
        .then((rows) {
      setState(() {
        String fechaInicio = rows.values.elementAt(7) ?? '';
        String fechaFinal = rows.values.elementAt(8) ?? '';

        if (rows.values.elementAt(7) != null ||
            rows.values.elementAt(8) != null) {
          _dateStartCollar = fechaInicio;
          _dateEndCollar = fechaFinal;
        }
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
    fnLlenarDownholeSurvey(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Downhole Surveys Tab',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Depth')))
              ? labelInput('Depth')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any((element) => element.values.contains('Depth')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Depth',
              controller: _DepthCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                if (double.tryParse(value)! > widget.totalDepth) {
                  message(CoolAlertType.error, 'Incorrect data',
                      'The End Depth cannot be grater than the total collar depth');
                  _DepthCtrl.clear();
                }
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Survtype')))
              ? sFM(_SurveyTypeCtrl, _itemsSurvType, 'Survey Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Dip')))
              ? labelInput('Dip')
              : labelInput(''),
          Container(
            child: Visibility(
              visible: (_items.any((element) => element.values.contains('Dip')))
                  ? true
                  : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Dip',
                controller: _DipCtrl,
                prefixIcon: Icons.list_alt_rounded,
                //keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChange: (text) {
                  if (double.tryParse(text)! > 90) {
                    message(CoolAlertType.error, 'Incorrect data',
                        'Dip out of range (0 to 90).');
                    _DipCtrl.clear();
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Azimuth')))
              ? labelInput('Azimuth')
              : labelInput(''),
          Container(
              child: Visibility(
            visible:
                (_items.any((element) => element.values.contains('Azimuth')))
                    ? true
                    : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Azimuth',
              controller: _AzimuthCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (text) {
                if (double.parse(text) > 360) {
                  message(CoolAlertType.error, 'Incorrect data',
                      'Dip out of range (0 to 360).');
                  _AzimuthCtrl.clear();
                }
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Azimuthtype')))
              ? sFM(_AzimuthTypeCtrl, _itemsAzimuthType, 'Azimuth Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          labelInput('Survey Date'),
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
                controller: _SurveyDateCtrl,
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
                  hintText: 'Survey Date',
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
                    _dateSurv_Dte = date;
                    pageEvent(true);
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Survey_Comment')))
              ? labelInput('Comments')
              : labelInput(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Visibility(
              visible: (_items.any(
                      (element) => element.values.contains('Survey_Comment')))
                  ? true
                  : false,
              child: BsInput(
                maxLines: null,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                style: BsInputStyle.outline,
                size: BsInputSize.md,
                hintText: 'Comments',
                controller: _CommentsCtrl,
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
                        await actualizarDownholeSurvey();
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
                      'Depth',
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Survey Type',
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Dip',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Azimuth',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Azimuth Type',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Survey Date',
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
      'Depth': double.tryParse(_DepthCtrl.text.toString()),
      'Survtype': int.tryParse(_SurveyTypeCtrl.text.toString()),
      'Dip': double.tryParse(_DipCtrl.text.toString()),
      'Azimuth': double.tryParse(_AzimuthCtrl.text.toString()),
      'Azimuthtype': int.tryParse(_AzimuthTypeCtrl.text.toString()),
      'Surv_Date': _dateSurv_Dte.toString(),
      'Survey_Comment': _CommentsCtrl.text.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
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
    valores['status_sync'] = 4;
    int response = await _db.fnInsertarRegistro('tb_downholesurveys', valores);
    if (response > 0) {
      await fnLlenarDownholeSurvey(widget.holeId);
      Loader.hide();
      _DepthCtrl.clear();
      _SurveyTypeCtrl.clear();
      _DipCtrl.clear();
      _AzimuthCtrl.clear();
      _AzimuthTypeCtrl.clear();
      _SurveyDateCtrl.clear();
      _CommentsCtrl.clear();
      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Downhole Survey data has been saved successfully',
      );
    }
  }

  Future<void> actualizarDownholeSurvey() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'Depth': double.tryParse(_DepthCtrl.text.toString()),
      'Survtype': int.tryParse(_SurveyTypeCtrl.text.toString()),
      'Dip': double.tryParse(_DipCtrl.text.toString()),
      'Azimuth': double.parse(_AzimuthCtrl.text.toString()),
      'Azimuthtype': int.tryParse(_AzimuthTypeCtrl.text.toString()),
      'Surv_Date': _dateSurv_Dte.toString(),
      'Survey_Comment': _CommentsCtrl.text.toString(),
      'status': 1
    };
    int response = await _db.fnActualizarRegistro(
        'tb_downholesurveys', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarDownholeSurvey(widget.holeId);
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
        text: 'Downhole Survey data has been updated successfully',
      );
    }
  }

  Future<dynamic> validateRequired(Map<String, Object?> valores) async {
    errors = '';

    if (_SurveyTypeCtrl.text.toString() == '') {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the Survey Type OR Select No Data');
      return false;
    }

    if (_AzimuthTypeCtrl.text.toString() == '') {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the Azimuth Type OR Select No Data');
      return false;
    }

    if (valores['Surv_Date'] != '') {
      DateTime dtStart = DateTime.parse(widget.fechaInicio);
      DateTime? dtEnd;
      Loader.hide();
      if (widget.fechaFinal == '') {
        dtEnd = DateTime.now();
      } else {
        dtEnd = DateTime.parse(widget.fechaFinal);
      }
      //log('${dtEnd}');
      DateTime dtLogged = DateTime.parse(valores['Surv_Date'].toString());
      if (dtLogged.isBefore(dtStart)) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The date is before the Date of the collar');
        return false;
      }
      if (dtLogged.isAfter(dtEnd)) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The date is After the Date of the collar');
        return false;
      }
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

  Future<void> fnLlenarDownholeSurvey(int collarId) async {
    _cells.clear();
    List<DownholeSurveyModel> listDownholeSurveyModel =
        await new DownholeSurveyModel()
            .fnObtenerRegistrosPorCollarId(
                collarId: collarId, orderByCampo: 'Depth')
            .then((value) => value);
    listDownholeSurveyModel.forEach((model) {
      _cells.add(
        DataRow(
          cells: [
            DataCell(
              Text('${model.depth.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.survTypeName}'),
            ),
            DataCell(
              Text('${model.dip.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.azimuth.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.azimuthTypeName}'),
            ),
            DataCell(
              Text(model.survey_date),
              /*Text(formatDate(
                  DateTime.parse(model.survey_date), [mm, '/', dd, '/', yyyy])),*/
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
                              nombreTabla: 'tb_downholesurveys',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _DepthCtrl.text = rows.values.elementAt(2).toString();
                          _SurveyTypeCtrl.text =
                              rows.values.elementAt(3).toString();
                          _DipCtrl.text = rows.values.elementAt(4).toString();
                          _AzimuthCtrl.text =
                              rows.values.elementAt(5).toString();
                          _AzimuthTypeCtrl.text =
                              rows.values.elementAt(6).toString();
                          if (rows.values.elementAt(7).toString() != '') {
                            _SurveyDateCtrl.text = DateFormat('MM/dd/yyyy')
                                .format(DateTime.parse(
                                    rows.values.elementAt(7).toString()));
                            /*_dateSurvey = DateTime.parse(
                                rows.values.elementAt(7).toString());*/
                          }
                          _CommentsCtrl.text =
                              rows.values.elementAt(8).toString();

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
        fnEliminarDownholeSurvey(selectedRow);
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
        .fnObtenerCamposActivas(widget.holeId, 'tb_downholesurveys');
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

  Future<void> fnEliminarDownholeSurvey(int id) async {
    await new DownholeSurveyModel()
        .fnEliminarRegistro(
            nombreTabla: 'tb_downholesurveys', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarDownholeSurvey(widget.holeId);
      }
    });
    /*await new DownholeSurveyModel()
        .fnEliminarRegistro('tb_downholesurveys','Id',id)
        .then((value) => value);*/
    //setState(() {});
  }
}
