import 'package:data_entry_app/models/Geotech1CoreRunsModel.dart';
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

class Geotech1CoreRunsTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  Geotech1CoreRunsTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  Geotech1CoreRunsTabState createState() =>
      Geotech1CoreRunsTabState(pageEvent: pageEvent);
}

class Geotech1CoreRunsTabState extends State<Geotech1CoreRunsTab> {
  final ValueChanged<bool> pageEvent;
  Geotech1CoreRunsTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _GeolFromCtrl = TextEditingController();
  TextEditingController _GeolToCtrl = TextEditingController();
  TextEditingController _RQDRawCtrl = TextEditingController();
  TextEditingController _RecoveryRawCtrl = TextEditingController();
  TextEditingController _RecoveryCtrl = TextEditingController();
  TextEditingController _RQDCtrl = TextEditingController();
  TextEditingController _Lith1SpecCtrl = TextEditingController();
  TextEditingController _LongestPieceCtrl = TextEditingController();
  TextEditingController _RockStrengthCtrl = TextEditingController();
  TextEditingController _HardnessCtrl = TextEditingController();
  TextEditingController _AlterationGradeCtrl = TextEditingController();
  TextEditingController _WeatheringCtrl = TextEditingController();
  TextEditingController _CommentsCtrl = TextEditingController();

  late List<Map<String, dynamic>> _itemsLith1Spec = [];
  late List<Map<String, dynamic>> _itemsRockStrength = [];
  late List<Map<String, dynamic>> _itemsHardness = [];
  late List<Map<String, dynamic>> _itemsAlterationGrade = [];
  late List<Map<String, dynamic>> _itemsWeathering = [];
  List<DataRow> _cells = [];
  String errors = "";
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
  int selectedRow = 0;
  bool onUpdate = false;

  bool geolFromDifference = false;
  bool geolToDifference = false;
  bool rqdRawDifference = false;
  bool recoveryRawDifference = false;
  bool candado = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  @override
  void initState() {
    super.initState();
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_lithspec', orderByCampo: 'repetitions')
        .then((rows) {
      setStateIfMounted(() {
        _itemsLith1Spec = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIconRockStrength(
            tbName: 'cat_rock_strength', orderByCampo: 'Rock_Strength')
        .then((rows) {
      setStateIfMounted(() {
        _itemsRockStrength = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_hardness', orderByCampo: 'repetitions')
        .then((rows) {
      setStateIfMounted(() {
        _itemsHardness = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_alteration', orderByCampo: 'repetitions')
        .then((rows) {
      setStateIfMounted(() {
        _itemsAlterationGrade = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_weathering', orderByCampo: 'repetitions')
        .then((rows) {
      setStateIfMounted(() {
        _itemsWeathering = rows;
      });
    });

    _db.fnObtenerRegistro(nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId).then((rows){
      setState(() {
        if(rows.values.elementAt(34) == 1){
          candado = true;
        }
      });
    });

    fnCargarTabs();
    fnLlenarGeotech1CoreRuns(widget.holeId);
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Geotech1 Core Runs Tab',
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
                            // #RECOVERY.
                            _RecoveryCtrl.text = fnCalcularRecovery(
                                text, _GeolToCtrl.text, _RecoveryRawCtrl.text);
                            // #RQD.
                            _RQDCtrl.text = fnCalcularRecovery(
                                text, _GeolToCtrl.text, _RQDRawCtrl.text);
                            setStateIfMounted(() {});
                          },
                        ),
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
                              // #RECOVERY.
                              _RecoveryCtrl.text = fnCalcularRecovery(
                                  _GeolFromCtrl.text,
                                  text,
                                  _RecoveryRawCtrl.text);
                              // #RQD.
                              _RQDCtrl.text = fnCalcularRecovery(
                                  text, text, _RQDRawCtrl.text);
                              setStateIfMounted(() {});
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
          ( _items.any( (element) => element.values.contains('RQDraw'))) ? labelInput('RQD Raw') : labelInput(''),
          Container(
            height:45,
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('RQDraw'))) ? true : false,
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 14.0,
                        right: 14.0,
                        top: 14.0,
                        bottom: 14.0),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'RQD Raw',
                    fillColor: (rqdRawDifference) ? Colors.red : Colors.white70,
                    filled: true,
                    prefixIcon: Icon(Icons.list_alt_rounded),
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
                    )
                ),
                controller: _RQDRawCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value){
                  rqdRawDifference = false;
                  if(isNumeric(_GeolToCtrl.text) && isNumeric(_GeolFromCtrl.text) && isNumeric(value)){
                    double maxNum= double.parse(_GeolToCtrl.text) - double.parse(_GeolFromCtrl.text);
                    if(double.parse(value) > maxNum){
                      message(CoolAlertType.error, 'Incorrect data',
                          'The value of RQDRaw cannot be greater than ${maxNum}.');
                      _RQDRawCtrl.clear();
                    };
                  }
                  _RQDCtrl.text = fnCalcularRecovery(
                      _GeolFromCtrl.text, _GeolToCtrl.text, value);
                  setStateIfMounted(() {});
                },
              ),
            ) ,
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Recoveryraw'))) ? labelInput('Recovery Raw'):labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('Recoveryraw'))) ? true:false,
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 14.0,
                        right: 14.0,
                        top: 14.0,
                        bottom: 14.0),
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'Recovery Raw',
                    fillColor: (rqdRawDifference) ? Colors.red : Colors.white70,
                    filled: true,
                    prefixIcon: Icon(Icons.list_alt_rounded),
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
                    )
                ),
                controller: _RecoveryRawCtrl,
                cursorColor: Colors.red,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  recoveryRawDifference = false;
                  if(isNumeric(_GeolToCtrl.text) && isNumeric(_GeolFromCtrl.text) && isNumeric(value)){
                    double maxNum= double.parse(_GeolToCtrl.text) - double.parse(_GeolFromCtrl.text);
                    if(double.parse(value) > maxNum){
                      message(CoolAlertType.error, 'Incorrect data',
                          'The value of Recovery Raw cannot be greater than ${maxNum}.');
                      _RecoveryRawCtrl.clear();
                    };
                  }
                  _RecoveryCtrl.text = fnCalcularRecovery(
                      _GeolFromCtrl.text, _GeolToCtrl.text, value);
                  setStateIfMounted(() {});
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('RECOVERY'))) ? labelInput('Recovery'):labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('RECOVERY'))) ? true : false,
             child: BsInput(
               style: BsInputStyle.outlineRounded,
               size: BsInputSize.md,
               hintText: 'Recovery',
               controller: _RecoveryCtrl,
               prefixIcon: Icons.list_alt_rounded,
               keyboardType: TextInputType.numberWithOptions(decimal: true),
               readOnly: true,

             ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('RECOVERY'))) ? labelInput('RQD'):labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('RECOVERY'))) ? true:false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'RQD',
                controller: _RQDCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                readOnly: true,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Lith1Spec'))) ? sFM(_Lith1SpecCtrl, _itemsLith1Spec, 'Lith1Spec') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Longest_Piece'))) ? labelInput('Longest Piece') : labelInput(''),
          Container(
              child: Visibility(
                visible: ( _items.any( (element) => element.values.contains('Longest_Piece'))) ? true:false,
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Longest Piece',
                  controller: _LongestPieceCtrl,
                  prefixIcon: Icons.list_alt_rounded,
                  keyboardType: TextInputType.numberWithOptions(),
                ),
            )

          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Rock_Strength'))) ? sFM(_RockStrengthCtrl, _itemsRockStrength, 'Rock Strength'):labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Hardness'))) ? sFM(_HardnessCtrl, _itemsHardness, 'Hardness') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('AlterationGrade'))) ? sFM(_AlterationGradeCtrl, _itemsAlterationGrade, 'Alteration Grade'): labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Weathering'))) ? sFM(_WeatheringCtrl, _itemsWeathering, 'Weathering') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Comments'))) ? labelInput('Comments'):labelInput(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Visibility(
                visible: ( _items.any( (element) => element.values.contains('Comments'))) ? true : false,
                child:BsInput(
                  maxLines: null,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                  style: BsInputStyle.outline,
                  size: BsInputSize.md,
                  hintText: 'Comments',
                  controller: _CommentsCtrl,
                  prefixIcon: Icons.comment,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              )
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
                    onPressed:candado ? null : () async {
                      await insertStructure();
                      setStateIfMounted(() {});
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
                        setStateIfMounted(() {});
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
                        await actualizarGeotech1CoreRuns();
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
          DataTable2(
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
                    'RQD Raw',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Recovery Raw',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Recovery',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'RQD',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Lith1Spec',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Longest Piece',
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
                    'Comments',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              rows: _cells),
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
            setStateIfMounted(() {
              pageEvent(true);
            });
          },
          /*validator: (val) {
            setStateIfMounted(() => sfm_validate = val ?? '');
            return null;
          },
          onSaved: (val) => setStateIfMounted(() => sfm_value_saved = val ?? ''),*/
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
      'GeolFrom': _GeolFromCtrl.text,
      'Chk': 0,
      'GeolTo': _GeolToCtrl.text,
      'RQDraw': double.tryParse(_RQDRawCtrl.text.toString()),
      'Recoveryraw': double.tryParse(_RecoveryRawCtrl.text.toString()),
      'RECOVERY': double.tryParse(_RecoveryCtrl.text.toString()),
      'RQD': _RQDCtrl.text,
      'Lith1Spec': int.tryParse(_Lith1SpecCtrl.text.toString()),
      'Longest_Piece': double.tryParse(_LongestPieceCtrl.text.toString()),
      'Rock_Strength': int.tryParse(_RockStrengthCtrl.text.toString()),
      'Hardness': int.tryParse(_HardnessCtrl.text.toString()),
      'AlterationGrade': int.tryParse(_AlterationGradeCtrl.text.toString()),
      'Weathering': int.tryParse(_WeatheringCtrl.text.toString()),
      'Comment': _CommentsCtrl.text.toString(),
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
      registerGeotech1CoreRuns(valores);
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
              await registerGeotech1CoreRuns(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> registerGeotech1CoreRuns(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    int response = await _db.fnInsertarRegistro('tb_geotechcorerun', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarGeotech1CoreRuns(widget.holeId);
      _GeolToCtrl.clear();
      _RQDCtrl.clear();
      _RQDRawCtrl.clear();
      _RecoveryRawCtrl.clear();
      _RecoveryCtrl.clear();
      _Lith1SpecCtrl.clear();
      _LongestPieceCtrl.clear();
      _RockStrengthCtrl.clear();
      _HardnessCtrl.clear();
      _AlterationGradeCtrl.clear();
      _WeatheringCtrl.clear();
      _CommentsCtrl.clear();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Geotech1CoreRun data has been saved successfully',
      );
    }
  }

  Future<void> actualizarGeotech1CoreRuns() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _GeolFromCtrl.text,
      'Chk': 0,
      'GeolTo': _GeolToCtrl.text,
      'RQDraw': double.tryParse(_RQDRawCtrl.text.toString()),
      'Recoveryraw': double.tryParse(_RecoveryRawCtrl.text.toString()),
      'RECOVERY': double.tryParse(_RecoveryCtrl.text.toString()),
      'RQD': int.tryParse(_RQDCtrl.text.toString()),
      'Lith1Spec': int.tryParse(_Lith1SpecCtrl.text.toString()),
      'Longest_Piece': double.tryParse(_LongestPieceCtrl.text.toString()),
      'Rock_Strength': int.tryParse(_RockStrengthCtrl.text.toString()),
      'Hardness': int.tryParse(_HardnessCtrl.text.toString()),
      'AlterationGrade': int.tryParse(_AlterationGradeCtrl.text.toString()),
      'Weathering': int.tryParse(_WeatheringCtrl.text.toString()),
      'Comment': _CommentsCtrl.text.toString(),
      'status': 1
    };
    int response = await _db.fnActualizarRegistro(
        'tb_geotechcorerun', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarGeotech1CoreRuns(widget.holeId);
      selectedRow = 0;
      onUpdate = false;
      _GeolToCtrl.clear();
      _RQDCtrl.clear();
      _RQDRawCtrl.clear();
      _RecoveryRawCtrl.clear();
      _RecoveryCtrl.clear();
      _Lith1SpecCtrl.clear();
      _LongestPieceCtrl.clear();
      _RockStrengthCtrl.clear();
      _HardnessCtrl.clear();
      _AlterationGradeCtrl.clear();
      _WeatheringCtrl.clear();
      _CommentsCtrl.clear();
      setStateIfMounted(() {});

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Geotech1CoreRun data has been updated successfully',
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

      double dif = (double.parse(valores['GeolFrom'].toString()) - double.parse(valores['GeolTo'].toString()));

      if (valores['Longest_Piece'].toString() == '' ||
          !isNumeric(valores['Longest_Piece'].toString())) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'Please enter the Longest Piece (numeric)');
      }
      if( double.parse(valores['Longest_Piece'].toString()) > dif.abs()  ){
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The Longest Piece is larger than the interval length');
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
      setStateIfMounted(() {
        response = rows.values.elementAt(1).toString();
        //_geologistString = rows.values.elementAt(1);
      });
    }).onError((error, stackTrace) {
      response = error.toString();
    });

    return response;
  }

  Future<void> fnLlenarGeotech1CoreRuns(int collarId) async {
    double _geolTo = 0;
    _GeolFromCtrl.text = '';
    _cells.clear();
    int currentRow = 0;
    var geotech1CoreRunsModel = new Geotech1CoreRunsModel();
    List<Geotech1CoreRunsModel> listStructureModel = await geotech1CoreRunsModel
        .fnObtenerRegistrosPorCollarId(
            collarId: collarId, orderByCampo: 'GeolFrom')
        .then((value) => value);
    _lastGeolTo = 0;
    print(geotech1CoreRunsModel);
    listStructureModel.forEach((model) {
      Color cell_color = Colors.black;
      currentRow ++;
      if (double.parse(model.geolFrom.toStringAsFixed(3)) > _lastGeolTo || double.parse(model.geolFrom.toStringAsFixed(3)) < _lastGeolTo) {
        if(currentRow==1 && double.parse(model.geolFrom.toStringAsFixed(3)) == 0){cell_color = Colors.black;}else{cell_color = Colors.red;}
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
              Text('${model.rqd_raw.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.recovery_raw.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.recovery.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.rqd}'),
            ),
            DataCell(
              Text('${model.LithSpecName}'),
            ),
            DataCell(
              Text('${model.longest_piece.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.RockStrengthName}'),
            ),
            DataCell(
              Text('${model.HardnessName}'),
            ),
            DataCell(
              Text('${model.AlterationGradeName}'),
            ),
            DataCell(
              Text('${model.WeatheringName}'),
            ),
            DataCell(
              Text('${model.comments}'),
            ),
          ],
          onSelectChanged: candado ? null : (newValue) {
            _getSelectedRowInfo(model);
          },
        ),
      );
      //_lastGeolFrom = double.parse(model.geolFrom.toString());
      _lastGeolTo = double.parse(model.geolTo.toString());
      _geolTo = model.geolTo;
    });
    if (_geolTo != 0) {
      _GeolFromCtrl.text = _geolTo.toString();
    }
    setStateIfMounted(() {});
  }

  void _getSelectedRowInfo(model) {
    selectedRow = model.id;
    setStateIfMounted(() {});
    _settingModalBottomSheet(context);
  }

  Future<bool> fnCargarTabs() async {
    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerCamposActivas(widget.holeId, 'tb_geotechcorerun');
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
                              nombreTabla: 'tb_geotechcorerun',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setStateIfMounted(() {
                          _GeolFromCtrl.text =
                              rows.values.elementAt(2).toString();
                          _GeolToCtrl.text =
                              rows.values.elementAt(3).toString();
                          _RQDRawCtrl.text =
                              rows.values.elementAt(5).toString();
                          _RecoveryRawCtrl.text =
                              rows.values.elementAt(6).toString();
                          _RecoveryCtrl.text =
                              rows.values.elementAt(7).toString();
                          _RQDCtrl.text = rows.values.elementAt(8).toString();
                          _Lith1SpecCtrl.text =
                              rows.values.elementAt(9).toString();
                          _LongestPieceCtrl.text =
                              rows.values.elementAt(10).toString();
                          _RockStrengthCtrl.text =
                              rows.values.elementAt(11).toString();
                          _HardnessCtrl.text =
                              rows.values.elementAt(12).toString();
                          _AlterationGradeCtrl.text =
                              rows.values.elementAt(13).toString();
                          _WeatheringCtrl.text =
                              rows.values.elementAt(14).toString();
                          _CommentsCtrl.text =
                              rows.values.elementAt(15).toString();

                          //_geologistString = rows.values.elementAt(1);
                        });
                      }).onError((error, stackTrace) {
                        //response = error.toString();
                      });
                      Navigator.pop(context);
                      onUpdate = true;
                      setStateIfMounted(() {});
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
        fnEliminarGeotech1CoreRuns(selectedRow);
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

  Future<void> fnEliminarGeotech1CoreRuns(int id) async {
    await new Geotech1CoreRunsModel()
        .fnEliminarRegistro(
            nombreTabla: 'tb_geotechcorerun', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarGeotech1CoreRuns(widget.holeId);
      }
    });
    /*await new StructureModel()
        .fnEliminarRegistro('tb_geotechcorerun','Id',id)
        .then((value) => value);*/
    //setStateIfMounted(() {});
  }

  String fnCalcularRecovery(
      String geolfrom, String geolto, String recoveryRaw) {
    String result = '';

    if (geolfrom.isNotEmpty && geolto.isNotEmpty && recoveryRaw.isNotEmpty) {
      if (double.parse(geolfrom) >= 0 &&
          double.parse(geolto) >= 0 &&
          double.parse(recoveryRaw) >= 0) {
        result = ((double.parse(recoveryRaw) /
                    (double.parse(geolto) - double.parse(geolfrom))) *
                100)
            .toStringAsFixed(2)
            .toString();
      }
    }
    return result;
  }
}
