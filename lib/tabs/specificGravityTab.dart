
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/models/SpecificGravityModel.dart';

import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class SpecificGravityTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;

  SpecificGravityTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  SpecificGravityState createState() =>
      SpecificGravityState(pageEvent: pageEvent);
}

class SpecificGravityState extends State<SpecificGravityTab> {
  final ValueChanged<bool> pageEvent;
  SpecificGravityState({required this.pageEvent});

  final _db = new DBDataEntry();
  TextEditingController _DepthCtrl = TextEditingController();
  TextEditingController _LengthCtrl = TextEditingController();
  TextEditingController _WeightDryAirCtrl = TextEditingController();
  TextEditingController _WeightWaterCtrl = TextEditingController();
  TextEditingController _WeightWaterSealedCtrl = TextEditingController();
  TextEditingController _FinalWeightNoSealedCtrl = TextEditingController();
  TextEditingController _Chk1Ctrl = TextEditingController();
  TextEditingController _Chk2Ctrl = TextEditingController();
  TextEditingController _SpecificGravity_1Ctrl = TextEditingController();
  TextEditingController _Vol_1Ctrl = TextEditingController();
  TextEditingController _Vol_2Ctrl = TextEditingController();
  TextEditingController _DifVolCtrl = TextEditingController();
  TextEditingController _SpecificGravity_2Ctrl = TextEditingController();
  TextEditingController _CommentsCtrl = TextEditingController();

  List<DataRow> _cells = [];
  String errors = "";
  int selectedRow = 0;
  bool onUpdate = false;
  bool menorque10 = false;
  bool candado = false;

  bool geolFromDifference = false;
  bool geolToDifference = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';
  @override
  void initState() {
    super.initState();
    //log('${widget.totalDepth}');
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
    fnLlenarSpecificGravity(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Specific Gravity Tab',
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
              visible:
                  (_items.any((element) => element.values.contains('Depth')))
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
                  if (double.tryParse(value)! < widget.totalDepth) {
                    _SpecificGravity_1Ctrl.text = fnCalcularSpecificGraity1(
                        value,
                        _WeightDryAirCtrl.text,
                        _WeightWaterSealedCtrl.text);
                    _DifVolCtrl.text = fnCalcularDifVol(
                        value, _Vol_1Ctrl.text, _Vol_2Ctrl.text);
                  } else {
                    message(CoolAlertType.error, 'Incorrect data',
                        'The Depth cannot be grater than the total collar depth');
                    _DepthCtrl.clear();
                  }

                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Length')))
              ? labelInput('Length')
              : labelInput(''),
          Container(
              child: Visibility(
            visible:
                (_items.any((element) => element.values.contains('Length')))
                    ? true
                    : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Length',
              controller: _LengthCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('WeightDryAir')))
              ? labelInput('Weight Dry Air')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items
                    .any((element) => element.values.contains('WeightDryAir')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Weight Dry Air',
              controller: _WeightDryAirCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                _SpecificGravity_1Ctrl.text = fnCalcularSpecificGraity1(
                    _DepthCtrl.text, value, _WeightWaterSealedCtrl.text);
                _SpecificGravity_2Ctrl.text = fnCalcularSpecificGraity2(
                    _DepthCtrl.text, value, _DifVolCtrl.text);
                _Chk2Ctrl.text = fnCalcularChk2(
                    _DepthCtrl.text, value, _FinalWeightNoSealedCtrl.text);
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('WeightWater')))
              ? labelInput('Weight Water')
              : labelInput(''),
          Container(
            child: Visibility(
              visible: (_items
                      .any((element) => element.values.contains('WeightWater')))
                  ? true
                  : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Weight Water',
                controller: _WeightWaterCtrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChange: (value) {
                  _SpecificGravity_1Ctrl.text = fnCalcularSpecificGraity1(
                      _DepthCtrl.text, _WeightDryAirCtrl.text, value);
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any(
                  (element) => element.values.contains('WeigthWaterSealed')))
              ? labelInput('Weight Water Sealed')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any(
                    (element) => element.values.contains('WeigthWaterSealed')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Weight Water Sealed',
              controller: _WeightWaterSealedCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                _SpecificGravity_1Ctrl.text = fnCalcularSpecificGraity1(
                    _DepthCtrl.text,
                    _WeightDryAirCtrl.text,
                    _WeightWaterSealedCtrl.text);
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any(
                  (element) => element.values.contains('FinalWeightNoSealed')))
              ? labelInput('Final Weight No Sealed')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any((element) =>
                    element.values.contains('FinalWeightNoSealed')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Final Weight No Sealed',
              controller: _FinalWeightNoSealedCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                _Chk2Ctrl.text = fnCalcularChk2(
                    _DepthCtrl.text, _WeightDryAirCtrl.text, value);
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Chk')))
              ? labelInput('Chk1')
              : labelInput(''),
          Container(
            child: Visibility(
              visible: (_items.any((element) => element.values.contains('Chk')))
                  ? true
                  : false,
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 14.0, right: 14.0, top: 14.0, bottom: 14.0),
                    prefixIcon: Icon(Icons.list_alt_rounded),
                    hintText: 'Chk1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: (menorque10)
                        ? Colors.red
                        : Color.fromRGBO(221, 221, 221, 50)),
                controller: _Chk1Ctrl,
                //keyboardType: TextInputType.numberWithOptions(decimal: true),
                enabled: false,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Chk1')))
              ? labelInput('Chk2')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any((element) => element.values.contains('Chk1')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Chk2',
              controller: _Chk2Ctrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              disabled: true,
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any(
                  (element) => element.values.contains('SpecificGravity_1')))
              ? labelInput('Specific Gravity 1')
              : labelInput(''),
          Container(
            child: Visibility(
              visible: (_items.any((element) =>
                      element.values.contains('SpecificGravity_1')))
                  ? true
                  : false,
              child: BsInput(
                style: BsInputStyle.outlineRounded,
                size: BsInputSize.md,
                hintText: 'Specific Gravity 1',
                controller: _SpecificGravity_1Ctrl,
                prefixIcon: Icons.list_alt_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                disabled: true,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Vol_1')))
              ? labelInput('Vol 1')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any((element) => element.values.contains('Vol_1')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Vol 1',
              controller: _Vol_1Ctrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                _DifVolCtrl.text =
                    fnCalcularDifVol(_DepthCtrl.text, value, _Vol_2Ctrl.text);
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('Vol_2')))
              ? labelInput('Vol 2')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any((element) => element.values.contains('Vol_2')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Vol 2',
              controller: _Vol_2Ctrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {
                if (int.tryParse(_Vol_2Ctrl.text)! >
                    int.parse(_Vol_1Ctrl.text)) {
                  _DifVolCtrl.text =
                      fnCalcularDifVol(_DepthCtrl.text, _Vol_1Ctrl.text, value);
                }
                setState(() {});
              },
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) => element.values.contains('DifVol')))
              ? labelInput('DifVol')
              : labelInput(''),
          Container(
              child: Visibility(
            visible:
                (_items.any((element) => element.values.contains('DifVol')))
                    ? true
                    : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'DifVol',
              controller: _DifVolCtrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              disabled: true,
              onChange: (value) {
                _SpecificGravity_2Ctrl.text = fnCalcularSpecificGraity2(
                    _DepthCtrl.text, _WeightDryAirCtrl.text, value);
                setState(() {});
              },
            ),
          )),
          SizedBox(height: 10.0),
          (_items.any(
                  (element) => element.values.contains('SpecificGravity_2')))
              ? labelInput('Specific Gravity 2')
              : labelInput(''),
          Container(
              child: Visibility(
            visible: (_items.any(
                    (element) => element.values.contains('SpecificGravity_2')))
                ? true
                : false,
            child: BsInput(
              style: BsInputStyle.outlineRounded,
              size: BsInputSize.md,
              hintText: 'Specific Gravity 2',
              controller: _SpecificGravity_2Ctrl,
              prefixIcon: Icons.list_alt_rounded,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              disabled: true,
              onChange: (value) {},
            ),
          )),
          SizedBox(
            height: 10,
          ),
          (_items.any((element) =>
                  element.values.contains('SpecificGravityComments')))
              ? labelInput('Comments')
              : labelInput(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Visibility(
              visible: (_items.any((element) =>
                      element.values.contains('SpecificGravityComments')))
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
                        await actualizarSpecificGravity();
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
                    'Length',
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text(
                    'Weight Dry Air',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Weight Water',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Weight Water Sealed',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Final Weight No Sealed',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Chk1',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Specific Gravity 1',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Vol 1',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Vol 2',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'DifVol',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Specific Gravity 2',
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
      'Chk': 0,
      'Length': double.tryParse(_LengthCtrl.text.toString()),
      'WeightDryAir': double.tryParse(_WeightDryAirCtrl.text.toString()),
      'WeightWater': double.tryParse(_WeightWaterCtrl.text.toString()),
      'WeigthWaterSealed': double.tryParse(_WeightWaterSealedCtrl.text.toString()),
      'FinalWeightNoSealed': _FinalWeightNoSealedCtrl.text.toString(),
      'Chk1': _Chk1Ctrl.text.toString(),
      'SpecificGravity_1': _SpecificGravity_1Ctrl.text.toString(),
      'Vol_1': _Vol_1Ctrl.text.toString(),
      'Vol_2': _Vol_2Ctrl.text.toString(),
      'DifVol': _DifVolCtrl.text.toString(),
      'SpecificGravity_2': _SpecificGravity_2Ctrl.text.toString(),
      'SpecificGravityComment': _CommentsCtrl.text.toString(),
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
      registerSpecificGravity(valores);
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
              await registerSpecificGravity(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> registerSpecificGravity(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    valores['status_sync'] = 4;
    int response = await _db.fnInsertarRegistro('tb_specificgravity', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarSpecificGravity(widget.holeId);
      _DepthCtrl.clear();
      _LengthCtrl.clear();
      _WeightDryAirCtrl.clear();
      _WeightWaterCtrl.clear();
      _WeightWaterSealedCtrl.clear();
      _FinalWeightNoSealedCtrl.clear();
      _Chk1Ctrl.clear();
      _SpecificGravity_1Ctrl.clear();
      _Vol_1Ctrl.clear();
      _Vol_2Ctrl.clear();
      _DifVolCtrl.clear();
      _SpecificGravity_2Ctrl.clear();
      _CommentsCtrl.clear();
      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'SpecificGravity data has been saved successfully',
      );
    }
  }

  Future<void> actualizarSpecificGravity() async {
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
      'Depth': _DepthCtrl.text,
      'Chk': 0,
      'Length': _LengthCtrl.text,
      'WeightDryAir': _WeightDryAirCtrl.text,
      'WeightWater': _WeightWaterCtrl.text,
      'WeigthWaterSealed': _WeightWaterSealedCtrl.text,
      'FinalWeightNoSealed': _FinalWeightNoSealedCtrl.text,
      'Chk1': _Chk1Ctrl.text,
      'SpecificGravity_1': _SpecificGravity_1Ctrl.text,
      'Vol_1': _Vol_1Ctrl.text,
      'Vol_2': _Vol_2Ctrl.text,
      'DifVol': _DifVolCtrl.text,
      'SpecificGravity_2': _SpecificGravity_2Ctrl.text,
      'SpecificGravityComment': _CommentsCtrl.text,
      'status': 1
    };
    int response = await _db.fnActualizarRegistro(
        'tb_specificgravity', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarSpecificGravity(widget.holeId);
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
        text: 'SpecificGravity data has been updated successfully',
      );
    }
  }

  Future<dynamic> validateRequired(Map<String, Object?> valores) async {
    errors = '';
    int? vol1 = int.tryParse(valores['Vol_1'].toString())??0;
    int? vol2 = int.tryParse(valores['Vol_2'].toString())??0;
    if (valores['Vol_1'] != null) {
      if (vol1 > vol2) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The Vol 1 cannot be gratter than Vol 2');
        return false;
      }
    }

    if (double.tryParse(valores['WeightDryAir'].toString())! > double.parse(valores['WeightWater'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The WeightDryAir cannot be gratter than WeightWater');
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

  Future<void> fnLlenarSpecificGravity(int collarId) async {
    _cells.clear();
    List<SpecificGravityModel> listSpecificGravityModel =
        await new SpecificGravityModel()
            .fnObtenerRegistrosPorCollarId(
                collarId: collarId, orderByCampo: 'Depth')
            .then((value) => value);
    listSpecificGravityModel.forEach((model) {
      _cells.add(
        DataRow(
          cells: [
            DataCell(
              Text('${model.depth.toStringAsFixed(3)}'),
            ),
            /*
            DataCell(
              Text('${model.chk.toStringAsFixed(3)}'),
            ),*/
            DataCell(
              Text('${model.length.toStringAsFixed(3)}'),
            ),
            DataCell(
              Text('${model.weightDryAir.toString()}'),
            ),
            DataCell(
              Text('${model.weightWater.toString()}'),
            ),
            DataCell(
              Text('${model.weightWaterSealed.toString()}'),
            ),
            DataCell(
              Text('${model.finalWeightNoSealed.toString()}'),
            ),
            DataCell(
              Text('${model.chk1.toString()}'),
            ),
            DataCell(
              Text('${model.specificGravity_1.toString()}'),
            ),
            DataCell(
              Text('${model.vol_1.toString()}'),
            ),
            DataCell(
              Text('${model.vol_2.toString()}'),
            ),
            DataCell(
              Text('${model.difvol.toString()}'),
            ),
            DataCell(
              Text('${model.specificGravity_2.toString()}'),
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
                              nombreTabla: 'tb_specificgravity',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _DepthCtrl.text = rows.values.elementAt(2).toString();
                          _LengthCtrl.text =
                              rows.values.elementAt(4).toString();
                          _WeightDryAirCtrl.text =
                              rows.values.elementAt(5).toString();
                          _WeightWaterCtrl.text =
                              rows.values.elementAt(6).toString();
                          _WeightWaterSealedCtrl.text =
                              rows.values.elementAt(7).toString();
                          _FinalWeightNoSealedCtrl.text =
                              rows.values.elementAt(8).toString();
                          _Chk1Ctrl.text = rows.values.elementAt(9).toString();
                          _SpecificGravity_1Ctrl.text =
                              rows.values.elementAt(10).toString();
                          _Vol_1Ctrl.text =
                              rows.values.elementAt(11).toString();
                          _Vol_2Ctrl.text =
                              rows.values.elementAt(12).toString();
                          _DifVolCtrl.text =
                              rows.values.elementAt(13).toString();
                          _SpecificGravity_2Ctrl.text =
                              rows.values.elementAt(14).toString();
                          _CommentsCtrl.text =
                              rows.values.elementAt(15).toString();
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
        fnEliminarSpecificGravity(selectedRow);
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

  Future<void> fnEliminarSpecificGravity(int id) async {
    await new SpecificGravityModel()
        .fnEliminarRegistro(
            nombreTabla: 'tb_specificgravity', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarSpecificGravity(widget.holeId);
      }
    });
  }

  String fnCalcularSpecificGraity1(
      String depth, String weightDryAir, String weightWaterSealed) {
    String result = '0.0';
    if (depth.isEmpty) {
    } else {
      String vWeightDryAir = (weightDryAir.isEmpty ? '0.0' : weightDryAir);
      String vWeightWaterSealed =
          (weightWaterSealed.isEmpty ? '0.0' : weightWaterSealed);
      if (double.parse(vWeightWaterSealed) > 0) {
        result =
            (double.parse(vWeightDryAir) / double.parse(vWeightWaterSealed))
                .toStringAsFixed(2)
                .toString();
      }
    }
    return result;
  }

  String fnCalcularDifVol(String depth, String vol1, String vol2) {
    String result = '0.0';
    if (depth.isEmpty) {
    } else {
      String vVol1 = (vol1.isEmpty ? '0.0' : vol1);
      String vVol2 = (vol2.isEmpty ? '0.0' : vol2);
      result = (double.parse(vVol2) - double.parse(vVol1)).toString();
    }
    _SpecificGravity_2Ctrl.text = fnCalcularSpecificGraity2(
        _DepthCtrl.text, _WeightDryAirCtrl.text, result);
    //print(_DepthCtrl.text);
    _Chk1Ctrl.text = fnCalcularChk1(_DepthCtrl.text,
        _SpecificGravity_1Ctrl.text, _SpecificGravity_2Ctrl.text);
    setState(() {});
    return result;
  }

  String fnCalcularSpecificGraity2(
      String depth, String weightDryAir, String difVol) {
    String result = '0.0';
    if (depth.isEmpty) {
    } else {
      String vWeightDryAir = (weightDryAir.isEmpty ? '0.0' : weightDryAir);
      String vDifVol = (difVol.isEmpty ? '0.0' : difVol);
      if (double.parse(vDifVol) > 0) {
        result = (double.parse(vWeightDryAir) / double.parse(vDifVol))
            .toStringAsFixed(2)
            .toString();
      }
    }
    return result;
  }

  String fnCalcularChk1(String depth, String sg1, String sg2) {
    String result = '0.0';
    if (!depth.isEmpty) {
      String Sg1 = (sg1.isEmpty ? '0.0' : sg1);
      String Sg2 = (sg2.isEmpty ? '0.0' : sg2);
      if (double.parse(Sg2) > 0) {
        double op1 = double.parse(Sg1) - double.parse(Sg2);
        double op2 = 0.5 * (double.parse(Sg1) + double.parse(Sg2));
        double op_tot = (op1 / op2) * 100;
        result = op_tot.abs().round().toString();
      }
    }
    print(result);
    return result;
  }

  Future<bool> fnCargarTabs() async {
    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerCamposActivas(widget.holeId, 'tb_specificgravity');
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

  String fnCalcularChk2(String depth, String pms, String pfs) {
    String result = '0.0';
    if (!depth.isEmpty) {
      String Sg1 = (pms.isEmpty ? '0.0' : pms);
      String Sg2 = (pfs.isEmpty ? '0.0' : pfs);
      if (double.parse(Sg2) > 0) {
        double op_tot = (double.parse(Sg1) - double.parse(Sg2));
        result = op_tot.abs().round().toString();
        if (double.parse(result) > 10) {
          menorque10 = true;
        } else {
          menorque10 = false;
        }
      }
    }
    print(menorque10);
    print(result);
    return result;
  }
}
