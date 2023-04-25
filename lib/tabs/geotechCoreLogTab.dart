import 'dart:developer';

import 'package:data_entry_app/models/GeotechCoreLogModel.dart';
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

class GeotechCoreLogTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  GeotechCoreLogTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  GeotechCoreLogTabState createState() =>
      GeotechCoreLogTabState(pageEvent: pageEvent);
}

class GeotechCoreLogTabState extends State<GeotechCoreLogTab> {
  final ValueChanged<bool> pageEvent;
  GeotechCoreLogTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _GeolFromCtrl = TextEditingController();
  TextEditingController _GeolToCtrl = TextEditingController();
  TextEditingController _JoinsetsCtrl = TextEditingController();
  TextEditingController _TypeCtrl = TextEditingController();
  TextEditingController _OpeningCtrl = TextEditingController();
  TextEditingController _RoughnessCtrl = TextEditingController();
  TextEditingController _CementTypeCtrl = TextEditingController();
  TextEditingController _LocationCtrl = TextEditingController();
  TextEditingController _AlterationGradeCtrl = TextEditingController();
  TextEditingController _WeatheringCtrl = TextEditingController();
  TextEditingController _RockStrengthCtrl = TextEditingController();
  TextEditingController _HardnessCtrl = TextEditingController();
  TextEditingController _NumberStructuresCtrl = TextEditingController();
  TextEditingController _AlphaCtrl = TextEditingController();
  TextEditingController _BetaCtrl = TextEditingController();
  TextEditingController _JCSCtrl = TextEditingController();
  TextEditingController _CommentsCtrl = TextEditingController();

  late List<Map<String, dynamic>> _itemsTypes = [];
  late List<Map<String, dynamic>> _itemsRoughness = [];
  late List<Map<String, dynamic>> _itemsCementType = [];
  late List<Map<String, dynamic>> _itemsWeathering = [];
  late List<Map<String, dynamic>> _itemsAlterationGrade = [];
  late List<Map<String, dynamic>> _itemsHardness = [];
  late List<Map<String, dynamic>> _itemsRockStrength = [];

  List<DataRow> _cells = [];
  String errors = "";
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
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
            tbName: 'cat_structype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsTypes = rows;
      });
    });

    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_roughness', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsRoughness = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_cementtype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsCementType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_weathering', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWeathering = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_alterationgrade', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsAlterationGrade = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_alterationgrade', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsAlterationGrade = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_hardness', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsHardness = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIconRockStrength(
            tbName: 'cat_rock_strength', orderByCampo: 'Rock_Strength')
        .then((rows) {
      setState(() {
        _itemsRockStrength = rows;
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
    fnLlenarGeotechCoreLog(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Geotech Core Log Tab',
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
                            controller: _GeolFromCtrl,
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
                              if (isNumeric(_GeolFromCtrl.text) &&
                                  _lastGeolTo != 0.0 &&
                                  _lastGeolTo !=
                                      double.tryParse(_GeolFromCtrl.text)) {
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
                            controller: _GeolToCtrl,
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
                              if (isNumeric(_GeolFromCtrl.text) &&
                                  isNumeric(_GeolToCtrl.text)) {
                                if (double.parse(_GeolToCtrl.text) <=
                                    double.parse(_GeolFromCtrl.text)) {
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
          (_items.any((element) => element.values.contains('JoinSets')))
              ? labelInput('JoinSets')
              : labelInput(''),
          Container(
            child: Visibility(
              visible:
                  (_items.any((element) => element.values.contains('JoinSets')))
                      ? true
                      : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'JoinSets',
                controller: _JoinsetsCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Type')))
              ? sFM(_TypeCtrl, _itemsTypes, 'Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Opening')))
              ? labelInput('Opening')
              : labelInput(''),
          Container(
            child: Visibility(
              visible:
                  (_items.any((element) => element.values.contains('Opening')))
                      ? true
                      : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Opening',
                controller: _OpeningCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Roughness')))
              ? sFM(_RoughnessCtrl, _itemsRoughness, 'Roughness')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('CementType')))
              ? sFM(_CementTypeCtrl, _itemsCementType, 'Cement Type')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Location')))
              ? labelInput('Location')
              : labelInput(''),
          Container(
            child: Visibility(
              visible:
                  (_items.any((element) => element.values.contains('Location')))
                      ? true
                      : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Location',
                controller: _LocationCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Alteration_Grade')))
              ? sFM(_AlterationGradeCtrl, _itemsAlterationGrade,
                  'Alteration Grade')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Weathering')))
              ? sFM(_WeatheringCtrl, _itemsWeathering, 'Weathering')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Rock_Strength')))
              ? sFM(_RockStrengthCtrl, _itemsRockStrength, 'Rock Strength')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Hardness')))
              ? sFM(_HardnessCtrl, _itemsHardness, 'Hardness')
              : labelInput(''),
          SizedBox(
            height: 10,
          ),
          (_items.any(
                  (element) => element.values.contains('Number_Structures')))
              ? labelInput('Number Structure')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any(
                    (element) => element.values.contains('Number_Structures')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Number Structures',
              controller: _NumberStructuresCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Alpha')))
              ? labelInput('Alpha')
              : labelInput(''),
          Container(
            child: Visibility(
              visible:
                  (_items.any((element) => element.values.contains('Alpha')))
                      ? true
                      : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Alpha',
                controller: _AlphaCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Beta')))
              ? labelInput('Beta')
              : labelInput(''),
          Container(
            child: Visibility(
              visible:
                  (_items.any((element) => element.values.contains('Beta')))
                      ? true
                      : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Beta',
                controller: _BetaCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('JCS')))
              ? labelInput('JCS')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any((element) => element.values.contains('JCS')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'JCS',
              controller: _JCSCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
            ),
          )),
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
                visible: (_items
                        .any((element) => element.values.contains('Comments')))
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
                    onPressed: () async {
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
                        await actualizarGeotechCoreLog();
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
                minWidth: 1200,
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
                      'JoinSets',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Tye',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Opening',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Roughness',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Cement Type',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Location',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Alteration Grade',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Weathering',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Rock Strength',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Hardness',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Number Structures',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Alpha',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'Beta',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn2(
                    label: Text(
                      'JCS',
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

  Future<void> insertStructure() async {
    FocusScope.of(context).unfocus();
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    /*
    Map<String, dynamic> valores = {
      'Id_Collar': widget.holeId,
      'GeolFrom': _GeolFromCtrl.text,
      'GeolTo': _GeolToCtrl.text,
      'Chk': 0,
      'JoinSets': int.tryParse(_JoinsetsCtrl.text.toString()),
      'Type': int.tryParse(_TypeCtrl.text.toString()),
      'Opening': double.tryParse(_OpeningCtrl.text.toString()),
      'Roughness': int.tryParse(_RoughnessCtrl.text.toString()),
      'CementType': int.tryParse(_CementTypeCtrl.text.toString()),
      'Location': double.tryParse(_LocationCtrl.text.toString()),
      'Alteration_Grade': int.tryParse(_AlterationGradeCtrl.text.toString()),
      'Weathering': int.tryParse(_WeatheringCtrl.text.toString()),
      'Rock_Strength': int.tryParse(_RockStrengthCtrl.text.toString()),
      'Hardness': int.tryParse(_HardnessCtrl.text.toString()),
      'Number_Structures': int.tryParse(_NumberStructuresCtrl.text.toString()),
      'Alpha': int.tryParse(_AlphaCtrl.text.toString()),
      'Beta': int.tryParse(_BetaCtrl.text.toString()),
      'JCS': int.tryParse(_JCSCtrl.text.toString()),
      'Comments': _CommentsCtrl.text.toString(),
      'status': 1
    };

     */
    Map<String, dynamic> valores = {
      'Id_Collar': widget.holeId,
      'GeolFrom': _GeolFromCtrl.text,
      'GeolTo': _GeolToCtrl.text,
      'Chk': 0,
      'JoinSets': _JoinsetsCtrl.text.toString(),
      'Type': _TypeCtrl.text.toString(),
      'Opening': _OpeningCtrl.text.toString(),
      'Roughness': _RoughnessCtrl.text.toString(),
      'CementType': _CementTypeCtrl.text.toString(),
      'Location': _LocationCtrl.text.toString(),
      'Alteration_Grade': _AlterationGradeCtrl.text.toString(),
      'Weathering': _WeatheringCtrl.text.toString(),
      'Rock_Strength': _RockStrengthCtrl.text.toString(),
      'Hardness': _HardnessCtrl.text.toString(),
      'Number_Structures': _NumberStructuresCtrl.text.toString(),
      'Alpha': _AlphaCtrl.text.toString(),
      'Beta': _BetaCtrl.text.toString(),
      'JCS': _JCSCtrl.text.toString(),
      'Comments': _CommentsCtrl.text.toString(),
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
      registerGeotechCoreLog(valores);
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
              await registerGeotechCoreLog(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> registerGeotechCoreLog(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    int response = await _db.fnInsertarRegistro('tb_geotechcorelog', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarGeotechCoreLog(widget.holeId);
      _GeolToCtrl.clear();
      _JoinsetsCtrl.clear();
      _TypeCtrl.clear();
      _OpeningCtrl.clear();
      _RoughnessCtrl.clear();
      _CementTypeCtrl.clear();
      _LocationCtrl.clear();
      _AlterationGradeCtrl.clear();
      _WeatheringCtrl.clear();
      _RockStrengthCtrl.clear();
      _HardnessCtrl.clear();
      _NumberStructuresCtrl.clear();
      _AlphaCtrl.clear();
      _BetaCtrl.clear();
      _JCSCtrl.clear();
      _CommentsCtrl.clear();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Geotech Core Log data has been saved successfully',
      );
    }
  }

  Future<void> actualizarGeotechCoreLog() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    /*
    Map<String, dynamic> valores = {
      'Id_Collar': widget.holeId,
      'GeolFrom': _GeolFromCtrl.text,
      'GeolTo': _GeolToCtrl.text,
      'Chk': 0,
      'JoinSets': int.tryParse(_JoinsetsCtrl.text.toString()),
      'Type': int.tryParse(_TypeCtrl.text.toString()),
      'Opening': double.tryParse(_OpeningCtrl.text.toString()),
      'Roughness': int.tryParse(_RoughnessCtrl.text.toString()),
      'CementType': int.tryParse(_CementTypeCtrl.text.toString()),
      'Location': double.tryParse(_LocationCtrl.text.toString()),
      'Alteration_Grade': int.tryParse(_AlterationGradeCtrl.text.toString()),
      'Weathering': int.tryParse(_WeatheringCtrl.text.toString()),
      'Rock_Strength': int.tryParse(_RockStrengthCtrl.text.toString()),
      'Hardness': int.tryParse(_HardnessCtrl.text.toString()),
      'Number_Structures': int.tryParse(_NumberStructuresCtrl.text.toString()),
      'Alpha': int.tryParse(_AlphaCtrl.text.toString()),
      'Beta': int.tryParse(_BetaCtrl.text.toString()),
      'JCS': int.tryParse(_JCSCtrl.text.toString()),
      'Comments': _CommentsCtrl.text.toString(),
      'status': 1
    };*/
    Map<String, dynamic> valores = {
      'Id_Collar': widget.holeId,
      'GeolFrom': _GeolFromCtrl.text,
      'GeolTo': _GeolToCtrl.text,
      'Chk': 0,
      'JoinSets': _JoinsetsCtrl.text.toString(),
      'Type': _TypeCtrl.text.toString(),
      'Opening': _OpeningCtrl.text.toString(),
      'Roughness': _RoughnessCtrl.text.toString(),
      'CementType': _CementTypeCtrl.text.toString(),
      'Location': _LocationCtrl.text.toString(),
      'Alteration_Grade': _AlterationGradeCtrl.text.toString(),
      'Weathering': _WeatheringCtrl.text.toString(),
      'Rock_Strength': _RockStrengthCtrl.text.toString(),
      'Hardness': _HardnessCtrl.text.toString(),
      'Number_Structures': _NumberStructuresCtrl.text.toString(),
      'Alpha': _AlphaCtrl.text.toString(),
      'Beta': _BetaCtrl.text.toString(),
      'JCS': _JCSCtrl.text.toString(),
      'Comments': _CommentsCtrl.text.toString(),
      'status': 1
    };

    int response = await _db.fnActualizarRegistro(
        'tb_geotechcorelog', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarGeotechCoreLog(widget.holeId);
      selectedRow = 0;
      onUpdate = false;
      _GeolToCtrl.clear();
      _JoinsetsCtrl.clear();
      _TypeCtrl.clear();
      _OpeningCtrl.clear();
      _RoughnessCtrl.clear();
      _CementTypeCtrl.clear();
      _LocationCtrl.clear();
      _AlterationGradeCtrl.clear();
      _WeatheringCtrl.clear();
      _RockStrengthCtrl.clear();
      _HardnessCtrl.clear();
      _NumberStructuresCtrl.clear();
      _AlphaCtrl.clear();
      _BetaCtrl.clear();
      _JCSCtrl.clear();
      _CommentsCtrl.clear();
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
        errors += '• The value of GeolFrom cannot be greater than TotalDepth(' +
            widget.totalDepth.toString() +
            ') of Collar.\n';
      }

      if (double.parse(valores['GeolTo'].toString()) > widget.totalDepth) {
        errors += '• The value of GeolTo cannot be greater than TotalDepth(' +
            widget.totalDepth.toString() +
            ') of Collar.\n';
      }

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

  Future<void> fnLlenarGeotechCoreLog(int collarId) async {
    double _geolTo = 0;
    _GeolFromCtrl.text = '';
    _cells.clear();
    int currentRow = 0;
    List<GeotechCoreLogModel> listStructureModel =
        await new GeotechCoreLogModel()
            .fnObtenerRegistrosPorCollarId(
                collarId: collarId, orderByCampo: 'GeolFrom')
            .then((value) => value);
    _lastGeolTo = 0;
    log('${listStructureModel}');
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
              Text('${model.join_sets.toString()}'),
            ),
            DataCell(
              Text('${model.type.toString()}'),
            ),
            DataCell(
              Text('${model.opening}'),
            ),
            DataCell(
              Text('${model.RoughnessName}'),
            ),
            DataCell(
              Text('${model.CementTypeName}'),
            ),
            DataCell(
              Text('${model.location}'),
            ),
            DataCell(
              Text('${model.AlterationGradeName}'),
            ),
            DataCell(
              Text('${model.WeatheringName}'),
            ),
            DataCell(
              Text('${model.RockStrengthName}'),
            ),
            DataCell(
              Text('${model.HardnessName}'),
            ),
            DataCell(
              Text('${model.number_structures.toString()}'),
            ),
            DataCell(
              Text('${model.alpha.toString()}'),
            ),
            DataCell(
              Text('${model.beta.toString()}'),
            ),
            DataCell(
              Text('${model.jcs.toString()}'),
            ),
            DataCell(
              Text('${model.comments}'),
            ),
          ],
          onSelectChanged: (newValue) {
            _getSelectedRowInfo(model);
          },
        ),
      );
      //_lastGeolFrom = double.parse(model.geolFrom.toString());
      //_lastGeolTo = double.parse(model.geolTo.toString());
      _lastGeolTo = model.geolTo;
      _geolTo = model.geolTo;
    });
    if (_geolTo != 0) {
      _GeolFromCtrl.text = _geolTo.toString();
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
                              nombreTabla: 'tb_geotechcorelog',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _GeolFromCtrl.text =
                              rows.values.elementAt(2).toString();
                          _GeolToCtrl.text =
                              rows.values.elementAt(3).toString();
                          _JoinsetsCtrl.text =
                              rows.values.elementAt(5).toString();
                          _TypeCtrl.text = rows.values.elementAt(6).toString();
                          _OpeningCtrl.text =
                              rows.values.elementAt(7).toString();
                          _RoughnessCtrl.text =
                              rows.values.elementAt(8).toString();
                          _CementTypeCtrl.text =
                              rows.values.elementAt(9).toString();
                          _LocationCtrl.text =
                              rows.values.elementAt(10).toString();
                          _AlterationGradeCtrl.text =
                              rows.values.elementAt(11).toString();
                          _WeatheringCtrl.text =
                              rows.values.elementAt(12).toString();
                          _RockStrengthCtrl.text =
                              rows.values.elementAt(13).toString();
                          _HardnessCtrl.text =
                              rows.values.elementAt(14).toString();
                          _NumberStructuresCtrl.text =
                              rows.values.elementAt(15).toString();
                          _AlphaCtrl.text =
                              rows.values.elementAt(16).toString();
                          _BetaCtrl.text = rows.values.elementAt(17).toString();
                          _JCSCtrl.text = rows.values.elementAt(18).toString();
                          _CommentsCtrl.text =
                              rows.values.elementAt(19).toString();

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

  Future<bool> fnCargarTabs() async {
    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerCamposActivas(widget.holeId, 'tb_geotechcorelog');
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
        fnEliminarGeotechCoreLog(selectedRow);
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

  Future<void> fnEliminarGeotechCoreLog(int id) async {
    await new GeotechCoreLogModel()
        .fnEliminarRegistro(
            nombreTabla: 'tb_geotechcorelog', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarGeotechCoreLog(widget.holeId);
      }
    });
    /*await new StructureModel()
        .fnEliminarRegistro('tb_geotechcorelog','Id',id)
        .then((value) => value);*/
    //setState(() {});
  }
}
