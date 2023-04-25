import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/AlterationTypeModel.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class AlterationTypeTab extends StatefulWidget {
  //late bool chkUpdate;
  final int holeId;
  final double totalDepth;
  final ValueChanged<bool> pageEvent;
  AlterationTypeTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  AlterationTypeTabState createState() =>
      AlterationTypeTabState(pageEvent: pageEvent);
}

class AlterationTypeTabState extends State<AlterationTypeTab> {
  final ValueChanged<bool> pageEvent;
  AlterationTypeTabState({required this.pageEvent});

  final _db = new DBDataEntry();

  TextEditingController _controllerGeolFrom = TextEditingController();
  TextEditingController _controllerGeolTo = TextEditingController();
  TextEditingController _commentsController = new TextEditingController();

  TextEditingController? _controllerAltType;

  TextEditingController _controllerAltType1 = TextEditingController();
  TextEditingController _controllerAltTypeIntensity1 = TextEditingController();
  TextEditingController _controllerAltTypeStyle1 = TextEditingController();

  TextEditingController _controllerAltType2 = TextEditingController();
  TextEditingController _controllerAltTypeIntensity2 = TextEditingController();
  TextEditingController _controllerAltTypeStyle2 = TextEditingController();

  TextEditingController _controllerAltType3 = TextEditingController();
  TextEditingController _controllerAltTypeIntensity3 = TextEditingController();
  TextEditingController _controllerAltTypeStyle3 = TextEditingController();

  TextEditingController _controllerAltType4 = TextEditingController();
  TextEditingController _controllerAltTypeIntensity4 = TextEditingController();
  TextEditingController _controllerAltTypeStyle4 = TextEditingController();

  TextEditingController _controllerAltType5 = TextEditingController();
  TextEditingController _controllerAltTypeIntensity5 = TextEditingController();
  TextEditingController _controllerAltTypeStyle5 = TextEditingController();

  TextEditingController _controllerMetallurgicalType = TextEditingController();

  late List<Map<String, dynamic>> _itemsAltType = [];
  late List<Map<String, dynamic>> _itemsAltTypeIntensity = [];
  late List<Map<String, dynamic>> _itemsAltTypeStyle = [];
  late List<Map<String, dynamic>> _itemsMetallurgicalType = [];

  String _selectedAlterationType = '1';
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  List<DataRow> _cells = [];
  int selectedRow = 0;
  bool onUpdate = false;
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
  bool candado = false;

  bool geolFromDifference = false;
  bool geolToDifference = false;

  final List<Map<String, dynamic>> _items_AlterationType = [
    {
      'value': '1',
      'label': 'Alteration 1',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '2',
      'label': 'Alteration 2',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '3',
      'label': 'Alteration 3',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '4',
      'label': 'Alteration 4',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '5',
      'label': 'Alteration 5',
      'icon': Icon(Icons.filter_list_rounded),
    }
  ];
  @override
  void initState() {
    super.initState();
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_alteration_type').then((rows) {
      setState(() {
        _itemsAltType = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_alttype_intensity').then((rows) {
      setState(() {
        _itemsAltTypeIntensity = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_alttype_style').then((rows) {
      setState(() {
        _itemsAltTypeStyle = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_metallurgial_type').then((rows) {
      setState(() {
        _itemsMetallurgicalType = rows;
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
    fnLlenarAlterationType(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Alteration Type Tab',
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
              /*Expanded(
                child: Column(
                  children: [
                    labelInput('GeolFrom'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'GeolFrom',
                        controller: _controllerGeolFrom,
                        prefixIcon: Icons.label_important,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ),*/
              Expanded(
                child: Column(
                  children: [
                    labelInput('GeolFrom'),
                    Container(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                            controller: _controllerGeolFrom,
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
                              fillColor: Colors.white70,
                              /*
                              (geolFromDifference)
                                  ? Colors.yellow
                                  : Colors.white70,

                               */
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
                              if (isNumeric(_controllerGeolFrom.text) &&
                                  _lastGeolTo != 0.0 &&
                                  _lastGeolTo !=
                                      double.tryParse(
                                          _controllerGeolFrom.text)) {
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
              /*Expanded(
                child: Column(
                  children: [
                    labelInput('GeolTo'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'GeolTo',
                        controller: _controllerGeolTo,
                        prefixIcon: Icons.label_important,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ),*/
              Expanded(
                child: Column(
                  children: [
                    labelInput('GeolTo'),
                    Container(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                            controller: _controllerGeolTo,
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
                              if (isNumeric(_controllerGeolFrom.text) &&
                                  isNumeric(_controllerGeolTo.text)) {
                                if (double.parse(_controllerGeolTo.text) <=
                                    double.parse(_controllerGeolFrom.text)) {
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
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            margin: EdgeInsets.only(bottom: 30.0),
            child: Column(
              children: <Widget>[
                SelectFormField(
                  type: SelectFormFieldType.dialog,
                  controller: _controllerAltType,
                  initialValue: '1',
                  icon: Icon(Icons.tab),
                  labelText: 'Choose a Alteration Type',
                  changeIcon: true,
                  dialogTitle: 'Pick a Alteration Type to add',
                  dialogCancelBtn: 'CANCEL',
                  enableSearch: true,
                  dialogSearchHint: '',
                  items: _items_AlterationType,
                  key: _key,
                  onChanged: (val) => {
                    setState(() {
                      _selectedAlterationType = val;
                    }),
                  },
                ),
              ],
            ),
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltType1, _itemsAltType, 'Alteration_Type1'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeIntensity1, _itemsAltTypeIntensity,
                    'AltType1_Intensity'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeStyle1, _itemsAltTypeStyle,
                    'AltType1_Style'),
              ],
            ),
            visible: (_selectedAlterationType == '1') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltType2, _itemsAltType, 'Alteration_Type2'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeIntensity2, _itemsAltTypeIntensity,
                    'AltType2_Intensity'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeStyle2, _itemsAltTypeStyle,
                    'AltType2_Style'),
              ],
            ),
            visible: (_selectedAlterationType == '2') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltType3, _itemsAltType, 'Alteration_Type3'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeIntensity3, _itemsAltTypeIntensity,
                    'AltType3_Intensity'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeStyle3, _itemsAltTypeStyle,
                    'AltType3_Style'),
              ],
            ),
            visible: (_selectedAlterationType == '3') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltType4, _itemsAltType, 'Alteration_Type4'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeIntensity4, _itemsAltTypeIntensity,
                    'AltType4_Intensity'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeStyle4, _itemsAltTypeStyle,
                    'AltType4_Style'),
              ],
            ),
            visible: (_selectedAlterationType == '4') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltType5, _itemsAltType, 'Alteration_Type5'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeIntensity5, _itemsAltTypeIntensity,
                    'AltType5_Intensity'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltTypeStyle5, _itemsAltTypeStyle,
                    'AltType5_Style'),
              ],
            ),
            visible: (_selectedAlterationType == '5') ? true : false,
          ),
          SizedBox(
            height: 15,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          sFM(_controllerMetallurgicalType, _itemsMetallurgicalType,
              'Metallurgical Type'),
          SizedBox(
            height: 10,
          ),
          labelInput('Comments'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: BsInput(
                maxLines: null,
                minLines: 4,
                keyboardType: TextInputType.multiline,
                style: BsInputStyle.outline,
                size: BsInputSize.md,
                hintText: 'Comments',
                controller: _commentsController,
                prefixIcon: Icons.comment,
                onChange: (text) {
                  setState(() {
                    pageEvent(true);
                  });
                },
              ),
            ),
          ),
          Divider(),
          (!onUpdate)
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton.icon(
                    onPressed: candado
                        ? null
                        : () async {
                            await insertLithology();
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
                        await actualizarLithology();
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
          /*SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton.icon(
              onPressed: () async {
                await insertLithology();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                  primary: DataEntryTheme.deOrangeDark,
                  alignment: Alignment.center),
              icon: Icon(Icons.add_circle_outline, size: 18),
              label: Text("ADD ROW"),
            ),
          ),*/
          SizedBox(
            height: 15,
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
                minWidth: 3000,
                columns: [
                  DataColumn2(
                    label: Text('GeolFrom'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('GeolTo'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Comments'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Alteration_Type1'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType1_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType1_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Alteration_Type2'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType2_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType2_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Alteration_Type3'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType3_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType3_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Alteration_Type4'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType4_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType4_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Alteration_Type5'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType5_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltType5_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Metallurgical_Type'),
                    size: ColumnSize.L,
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
            }
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

  Future<void> actualizarLithology() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _controllerGeolFrom.text,
      'GeolTo': _controllerGeolTo.text,
      'Alteration_Comment': _commentsController.text.toString(),
      'Alteration_Type1': _controllerAltType1.text.toString(),
      'AltType1_Intensity': _controllerAltTypeIntensity1.text.toString(),
      'AltType1_Style': _controllerAltTypeStyle1.text.toString(),
      'Alteration_Type2': _controllerAltType2.text.toString(),
      'AltType2_Intensity': _controllerAltTypeIntensity2.text.toString(),
      'AltType2_Style': _controllerAltTypeStyle2.text.toString(),
      'Alteration_Type3': _controllerAltType3.text.toString(),
      'AltType3_Intensity': _controllerAltTypeIntensity3.text.toString(),
      'AltType3_Style': _controllerAltTypeStyle3.text.toString(),
      'Alteration_Type4': _controllerAltType4.text.toString(),
      'AltType4_Intensity': _controllerAltTypeIntensity4.text.toString(),
      'AltType4_Style': _controllerAltTypeStyle4.text.toString(),
      'Alteration_Type5': _controllerAltType5.text.toString(),
      'AltType5_Intensity': _controllerAltTypeIntensity5.text.toString(),
      'AltType5_Style': _controllerAltTypeStyle5.text.toString(),
      'Metallurgical_Type': _controllerMetallurgicalType.text.toString(),
      'status': 1
    };

    int response = await _db.fnActualizarRegistro(
        'tb_alterationtype', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarAlterationType(widget.holeId);
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
        text: 'Alteration Type data has been updated successfully',
      );
    }
  }

  Future<void> insertLithology() async {
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
      'GeolFrom': _controllerGeolFrom.text,
      'GeolTo': _controllerGeolTo.text,
      'Alteration_Comment': _commentsController.text.toString(),
      'Alteration_Type1': _controllerAltType1.text.toString(),
      'AltType1_Intensity': _controllerAltTypeIntensity1.text.toString(),
      'AltType1_Style': _controllerAltTypeStyle1.text.toString(),
      'Alteration_Type2': _controllerAltType2.text.toString(),
      'AltType2_Intensity': _controllerAltTypeIntensity2.text.toString(),
      'AltType2_Style': _controllerAltTypeStyle2.text.toString(),
      'Alteration_Type3': _controllerAltType3.text.toString(),
      'AltType3_Intensity': _controllerAltTypeIntensity3.text.toString(),
      'AltType3_Style': _controllerAltTypeStyle3.text.toString(),
      'Alteration_Type4': _controllerAltType4.text.toString(),
      'AltType4_Intensity': _controllerAltTypeIntensity4.text.toString(),
      'AltType4_Style': _controllerAltTypeStyle4.text.toString(),
      'Alteration_Type5': _controllerAltType5.text.toString(),
      'AltType5_Intensity': _controllerAltTypeIntensity5.text.toString(),
      'AltType5_Style': _controllerAltTypeStyle5.text.toString(),
      'Metallurgical_Type': _controllerMetallurgicalType.text.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
      await _db.fnInsertarRegistro('tb_alterationtype', valores);
      await fnLlenarAlterationType(widget.holeId);
      Loader.hide();
      _commentsController.clear();
      _controllerAltType1.clear();
      _controllerAltTypeIntensity1.clear();
      _controllerAltTypeStyle1.clear();
      _controllerAltType2.clear();
      _controllerAltTypeIntensity2.clear();
      _controllerAltTypeStyle2.clear();
      _controllerAltType3.clear();
      _controllerAltTypeIntensity3.clear();
      _controllerAltTypeStyle3.clear();
      _controllerAltType4.clear();
      _controllerAltTypeIntensity4.clear();
      _controllerAltTypeStyle4.clear();
      _controllerAltType5.clear();
      _controllerAltTypeIntensity5.clear();
      _controllerAltTypeStyle5.clear();
      _controllerMetallurgicalType.clear();
      _controllerGeolTo.clear();
      _selectedAlterationType = '1';
      _key.currentState?.reset();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'The Alteration Type data was saved correctly.',
      );
    }
  }

  Future<bool> validateRequired(Map<String, Object?> valores) async {
    if (valores['GeolFrom'].toString() == '' ||
        !isNumeric(valores['GeolFrom'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the GeolFrom (numeric)');

      return false;
    }
    if (!isNumeric(valores['GeolTo'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the GeolTo (numeric)');

      return false;
    }
    if (isNumeric(valores['GeolFrom'].toString()) &&
        isNumeric(valores['GeolTo'].toString())) {
      if (double.parse(valores['GeolFrom'].toString()) >
          double.parse(valores['GeolTo'].toString())) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The value of GeolFrom cannot be greater than GeolTo.');

        return false;
      }
      if (double.parse(valores['GeolTo'].toString()) > widget.totalDepth) {
        Loader.hide();
        message(CoolAlertType.error, 'Incorrect data',
            'The value of GeolTo cannot be greater than TotalDepth of Collar.');

        return false;
      }
    }

    return true;
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
/*
  Future<void> _addRowTable() async {
    _cells.add(DataRow(cells: [
      DataCell(Text(
        _controllerGeolFrom.text,
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        _controllerGeolTo.text,
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        _commentsController.text,
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alteration_type', 'id',
            int.tryParse(_controllerAltType1.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_intensity', 'id',
            int.tryParse(_controllerAltTypeIntensity1.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_style', 'id',
            int.tryParse(_controllerAltTypeStyle1.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alteration_type', 'id',
            int.tryParse(_controllerAltType2.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_intensity', 'id',
            int.tryParse(_controllerAltTypeIntensity2.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_style', 'id',
            int.tryParse(_controllerAltTypeStyle2.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alteration_type', 'id',
            int.tryParse(_controllerAltType3.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_intensity', 'id',
            int.tryParse(_controllerAltTypeIntensity3.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_style', 'id',
            int.tryParse(_controllerAltTypeStyle3.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alteration_type', 'id',
            int.tryParse(_controllerAltType4.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_intensity', 'id',
            int.tryParse(_controllerAltTypeIntensity4.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_style', 'id',
            int.tryParse(_controllerAltTypeStyle4.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alteration_type', 'id',
            int.tryParse(_controllerAltType5.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_intensity', 'id',
            int.tryParse(_controllerAltTypeIntensity5.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_alttype_style', 'id',
            int.tryParse(_controllerAltTypeStyle5.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_metallurgial_type', 'id',
            int.tryParse(_controllerMetallurgicalType.text)),
        textAlign: TextAlign.center,
      )),
    ]));

    _controllerGeolFrom.text = _controllerGeolTo.text;
    _controllerGeolTo.clear();
    _controllerAltType1.clear();
    _controllerAltType2.clear();
    _controllerAltType3.clear();
    _controllerAltType4.clear();
    _controllerAltType5.clear();
    _controllerAltTypeIntensity1.clear();
    _controllerAltTypeIntensity2.clear();
    _controllerAltTypeIntensity3.clear();
    _controllerAltTypeIntensity4.clear();
    _controllerAltTypeIntensity5.clear();
    _controllerAltTypeStyle1.clear();
    _controllerAltTypeStyle2.clear();
    _controllerAltTypeStyle3.clear();
    _controllerAltTypeStyle4.clear();
    _controllerAltTypeStyle5.clear();
  }*/

  Future<String> getOptionString(String table, String field, int? where) async {
    String response = "";
    if (where != null) {
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
    }

    return response;
  }

  Future<void> fnLlenarAlterationType(int collarId) async {
    double _geolTo = 0;
    _cells.clear();
    int currentRow = 0;
    List<AlterationTypeModel> listAlterationTypeModel =
        await new AlterationTypeModel()
            .fnObtenerRegistrosPorCollarId(collarId: collarId)
            .then((value) => value);
    listAlterationTypeModel.forEach((model) {
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
      _cells.add(DataRow(
        cells: [
          DataCell(Text('${model.geolFrom.toStringAsFixed(3)}',
              style: TextStyle(color: cell_color))),
          DataCell(Text('${model.geolTo.toStringAsFixed(3)}')),
          DataCell(Text('${model.comments}')),
          DataCell(Text('${model.alterationType1Name}')),
          DataCell(Text('${model.altType1IntensityName}')),
          DataCell(Text('${model.altType1StyleName}')),
          DataCell(Text('${model.alterationType2Name}')),
          DataCell(Text('${model.altType2IntensityName}')),
          DataCell(Text('${model.altType2StyleName}')),
          DataCell(Text('${model.alterationType3Name}')),
          DataCell(Text('${model.altType3IntensityName}')),
          DataCell(Text('${model.altType3StyleName}')),
          DataCell(Text('${model.alterationType4Name}')),
          DataCell(Text('${model.altType4IntensityName}')),
          DataCell(Text('${model.altType4StyleName}')),
          DataCell(Text('${model.alterationType5Name}')),
          DataCell(Text('${model.altType5IntensityName}')),
          DataCell(Text('${model.altType5StyleName}')),
          DataCell(Text('${model.metallurgicalTypeName}')),
        ],
        onSelectChanged: candado
            ? null
            : (newValue) {
                _getSelectedRowInfo(model);
              },
      ));
      //_lastGeolFrom = double.parse(model.geolFrom.toString());
      _lastGeolTo = double.parse(model.geolTo.toString());
      _geolTo = model.geolTo;
      if (_geolTo != 0) {
        _controllerGeolFrom.text = _geolTo.toString();
      }
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
                              nombreTabla: 'tb_alterationtype',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _controllerGeolFrom.text =
                              rows.values.elementAt(2).toString();
                          _controllerGeolTo.text =
                              rows.values.elementAt(3).toString();
                          _commentsController.text =
                              rows.values.elementAt(5).toString();
                          _controllerAltType1.text =
                              rows.values.elementAt(6).toString();
                          _controllerAltTypeIntensity1.text =
                              rows.values.elementAt(7).toString();
                          _controllerAltTypeStyle1.text =
                              rows.values.elementAt(8).toString();
                          _controllerAltType2.text =
                              rows.values.elementAt(9).toString();
                          _controllerAltTypeIntensity2.text =
                              rows.values.elementAt(10).toString();
                          _controllerAltTypeStyle2.text =
                              rows.values.elementAt(11).toString();
                          _controllerAltType3.text =
                              rows.values.elementAt(12).toString();
                          _controllerAltTypeIntensity3.text =
                              rows.values.elementAt(13).toString();
                          _controllerAltTypeStyle3.text =
                              rows.values.elementAt(14).toString();
                          _controllerAltType4.text =
                              rows.values.elementAt(15).toString();
                          _controllerAltTypeIntensity4.text =
                              rows.values.elementAt(16).toString();
                          _controllerAltTypeStyle4.text =
                              rows.values.elementAt(17).toString();
                          _controllerAltType5.text =
                              rows.values.elementAt(18).toString();
                          _controllerAltTypeIntensity5.text =
                              rows.values.elementAt(19).toString();
                          _controllerAltTypeStyle5.text =
                              rows.values.elementAt(20).toString();
                          _controllerMetallurgicalType.text =
                              rows.values.elementAt(21).toString();
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
      onPressed: () async {
        Navigator.pop(context);
        await fnEliminarAlterationType(selectedRow);
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

  Future<void> fnEliminarAlterationType(int id) async {
    await new AlterationTypeModel()
        .fnEliminarRegistro(
            nombreTabla: 'tb_alterationtype', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarAlterationType(widget.holeId);
      }
    });
    /*await new LoggedByModel()
        .fnEliminarRegistro('tb_lithology','Id',id)
        .then((value) => value);*/
    //setState(() {});
  }
}
