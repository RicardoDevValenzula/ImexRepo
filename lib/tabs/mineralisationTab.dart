import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';
import 'package:data_entry_app/models/MineralisationModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class MineralisationTab extends StatefulWidget {
  //late bool chkUpdate;
  final int holeId;
  final double totalDepth;
  final ValueChanged<bool> pageEvent;
  MineralisationTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  MineralisationTabState createState() =>
      MineralisationTabState(pageEvent: pageEvent);
}

class MineralisationTabState extends State<MineralisationTab> {
  final ValueChanged<bool> pageEvent;
  MineralisationTabState({required this.pageEvent});

  final _db = new DBDataEntry();

  TextEditingController _controllerGeolFrom = TextEditingController();
  TextEditingController _controllerGeolTo = TextEditingController();
  TextEditingController _controllerNoQtzVeins = TextEditingController();
  TextEditingController _controllerComments = TextEditingController();
  TextEditingController? _controllerMineralisation;

  TextEditingController _controllerMineral1 = TextEditingController();
  TextEditingController _controllerMineral1Style = TextEditingController();
  TextEditingController _controllerMineral1Percent = TextEditingController();

  TextEditingController _controllerMineral2 = TextEditingController();
  TextEditingController _controllerMineral2Style = TextEditingController();
  TextEditingController _controllerMineral2Percent = TextEditingController();

  TextEditingController _controllerMineral3 = TextEditingController();
  TextEditingController _controllerMineral3Style = TextEditingController();
  TextEditingController _controllerMineral3Percent = TextEditingController();

  TextEditingController _controllerMineral4 = TextEditingController();
  TextEditingController _controllerMineral4Style = TextEditingController();
  TextEditingController _controllerMineral4Percent = TextEditingController();

  TextEditingController _controllerMineral5 = TextEditingController();
  TextEditingController _controllerMineral5Style = TextEditingController();
  TextEditingController _controllerMineral5Percent = TextEditingController();

  TextEditingController _controllerMineral6 = TextEditingController();
  TextEditingController _controllerMineral6Style = TextEditingController();
  TextEditingController _controllerMineral6Percent = TextEditingController();

  TextEditingController _controllerMineral7 = TextEditingController();
  TextEditingController _controllerMineral7Style = TextEditingController();
  TextEditingController _controllerMineral7Percent = TextEditingController();

  TextEditingController _controllerMineral8 = TextEditingController();
  TextEditingController _controllerMineral8Style = TextEditingController();
  TextEditingController _controllerMineral8Percent = TextEditingController();

  TextEditingController _controllerMineral9 = TextEditingController();
  TextEditingController _controllerMineral9Style = TextEditingController();
  TextEditingController _controllerMineral9Percent = TextEditingController();

  TextEditingController _controllerMineral10 = TextEditingController();
  TextEditingController _controllerMineral10Style = TextEditingController();
  TextEditingController _controllerMineral10Percent = TextEditingController();

  TextEditingController _controllerMineral11 = TextEditingController();
  TextEditingController _controllerMineral11Style = TextEditingController();
  TextEditingController _controllerMineral11Percent = TextEditingController();

  TextEditingController _controllerMineral12 = TextEditingController();
  TextEditingController _controllerMineral12Style = TextEditingController();
  TextEditingController _controllerMineral12Percent = TextEditingController();

  late List<Map<String, dynamic>> _itemsMinerals = [];
  late List<Map<String, dynamic>> _itemsMineralStyle = [];

  String _selectedMineralisation = '1';
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
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

  final List<Map<String, dynamic>> _items_mineralisation = [
    /*
    {
      'value': '1',
      'label': 'Mineral 1',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '2',
      'label': 'Mineral 2',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '3',
      'label': 'Mineral 3',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '4',
      'label': 'Mineral 4',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '5',
      'label': 'Mineral 5',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '6',
      'label': 'Mineral 6',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '7',
      'label': 'Mineral 7',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '8',
      'label': 'Mineral 8',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '9',
      'label': 'Mineral 9',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '10',
      'label': 'Mineral 10',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '11',
      'label': 'Mineral 11',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '12',
      'label': 'Mineral 12',
      'icon': Icon(Icons.filter_list_rounded),
    }
     */
  ];
  @override
  void initState() {
    super.initState();
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_mineral').then((rows) {
      setState(() {
        _itemsMinerals = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_mineralstyle').then((rows) {
      setState(() {
        _itemsMineralStyle = rows;
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
    fnLlenarMineralisation(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Mineralisation Tab',
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
          labelInput('Mineral Comments'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: BsInput(
                    maxLines: null,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    style: BsInputStyle.outline,
                    size: BsInputSize.md,
                    hintText: 'Mineral Comments',
                    controller: _controllerComments,
                    prefixIcon: Icons.comment)),
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              labelInput('No_Qtz_veins'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'No_Qtz_Veins',
                  controller: _controllerNoQtzVeins,
                  prefixIcon: Icons.list_alt_rounded,
                  keyboardType: TextInputType.numberWithOptions(),
                ),
              ),
            ],
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            margin: EdgeInsets.only(bottom: 30.0),
            child: Column(
              children: <Widget>[
                SelectFormField(
                  type: SelectFormFieldType.dialog,
                  controller: _controllerMineralisation,
                  initialValue: '1',
                  icon: Icon(Icons.tab),
                  labelText: 'Choose a mineral',
                  changeIcon: true,
                  dialogTitle: 'Pick a mineral to add',
                  dialogCancelBtn: 'CANCEL',
                  enableSearch: true,
                  dialogSearchHint: '',
                  items: _items_mineralisation,
                  key: _key,
                  onChanged: (val) => {
                    setState(() {
                      _selectedMineralisation = val;
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
                sFM(_controllerMineral1, _itemsMinerals, 'Mineral 1'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral1Style, _itemsMineralStyle,
                    'Mineral1_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral1 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral1 %',
                        controller: _controllerMineral1Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                        onEditingComplete: () {
                          if (!GeneralController.fnValidarPorcenaje(
                              _controllerMineral1Percent.text)) {
                            _controllerMineral1Percent.text = '';
                            CoolAlert.show(
                              context: context,
                              backgroundColor: DataEntryTheme.deGrayLight,
                              confirmBtnColor: DataEntryTheme.deGrayDark,
                              confirmBtnTextStyle:
                                  TextStyle(color: DataEntryTheme.deGrayLight),
                              cancelBtnTextStyle:
                                  TextStyle(color: DataEntryTheme.deBlack),
                              type: CoolAlertType.error,
                              title: 'Mineral1 %.',
                              text:
                                  "The field 'Mineral1 %' must be between 0-100.",
                            );
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '1') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral2, _itemsMinerals, 'Mineral 2'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral2Style, _itemsMineralStyle,
                    'Mineral2_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral2 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral2 %',
                        controller: _controllerMineral2Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '2') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral3, _itemsMinerals, 'Mineral 3'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral3Style, _itemsMineralStyle,
                    'Mineral3_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral3 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral3 %',
                        controller: _controllerMineral3Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '3') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral4, _itemsMinerals, 'Mineral 4'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral4Style, _itemsMineralStyle,
                    'Mineral4_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral4 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral4 %',
                        controller: _controllerMineral4Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '4') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral5, _itemsMinerals, 'Mineral 5'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral5Style, _itemsMineralStyle,
                    'Mineral5_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral5 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral5 %',
                        controller: _controllerMineral5Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '5') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral6, _itemsMinerals, 'Mineral 6'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral6Style, _itemsMineralStyle,
                    'Mineral6_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral6 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral6 %',
                        controller: _controllerMineral6Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '6') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral7, _itemsMinerals, 'Mineral 7'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral7Style, _itemsMineralStyle,
                    'Mineral7_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral7 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral7 %',
                        controller: _controllerMineral7Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '7') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral8, _itemsMinerals, 'Mineral 8'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral8Style, _itemsMineralStyle,
                    'Mineral8_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral8 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral8 %',
                        controller: _controllerMineral8Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '8') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral9, _itemsMinerals, 'Mineral 9'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral9Style, _itemsMineralStyle,
                    'Mineral9_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral9 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral9 %',
                        controller: _controllerMineral9Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '9') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral10, _itemsMinerals, 'Mineral 10'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral10Style, _itemsMineralStyle,
                    'Mineral10_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral10 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral10 %',
                        controller: _controllerMineral10Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '10') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral11, _itemsMinerals, 'Mineral 11'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral11Style, _itemsMineralStyle,
                    'Mineral11_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral11 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral11 %',
                        controller: _controllerMineral11Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '11') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerMineral12, _itemsMinerals, 'Mineral 12'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerMineral12Style, _itemsMineralStyle,
                    'Mineral12_Style'),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    labelInput('Mineral12 %'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Mineral12 %',
                        controller: _controllerMineral12Percent,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            visible: (_selectedMineralisation == '12') ? true : false,
          ),
          SizedBox(
            height: 15,
          ),
          (!onUpdate)
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton.icon(
                    onPressed: candado
                        ? null
                        : () async {
                            await insertMineralisation();
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
                        await actualizarMineralisation();
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
                minWidth: 5000,
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
                    label: Text('Mineral_Comments'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('No_Qtz_Veins'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral1'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral1_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral1%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral2'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral2_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral2%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral3'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral3_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral3%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral4'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral4_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral4%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral5'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral5_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral5%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral6'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral6_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral6%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral7'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral7_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral7%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral8'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral8_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral8%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral9'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral9_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral9%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral10'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral10_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral10%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral11'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral11_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral11%'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral12'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral12_Style'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Mineral12%'),
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

  Future<void> insertMineralisation() async {
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
      'Mineral_Comment': _controllerComments.text,
      'No_Qtz_Veins': _controllerNoQtzVeins.text,
      'Mineral1': _controllerMineral1.text,
      'MineralStyle1': _controllerMineral1Style.text,
      'Mineral1_Percent': _controllerMineral1Percent.text,
      'Mineral2': _controllerMineral2.text,
      'MineralStyle2': _controllerMineral2Style.text,
      'Mineral2_Percent': _controllerMineral2Percent.text,
      'Mineral3': _controllerMineral3.text,
      'MineralStyle3': _controllerMineral3Style.text,
      'Mineral3_Percent': _controllerMineral3Percent.text,
      'Mineral4': _controllerMineral4.text,
      'MineralStyle4': _controllerMineral4Style.text,
      'Mineral4_Percent': _controllerMineral4Percent.text,
      'Mineral5': _controllerMineral5.text,
      'MineralStyle5': _controllerMineral5Style.text,
      'Mineral5_Percent': _controllerMineral5Percent.text,
      'Mineral6': _controllerMineral6.text,
      'MineralStyle6': _controllerMineral6Style.text,
      'Mineral6_Percent': _controllerMineral6Percent.text,
      'Mineral7': _controllerMineral7.text,
      'MineralStyle7': _controllerMineral7Style.text,
      'Mineral7_Percent': _controllerMineral7Percent.text,
      'Mineral8': _controllerMineral8.text,
      'MineralStyle8': _controllerMineral8Style.text,
      'Mineral8_Percent': _controllerMineral8Percent.text,
      'Mineral9': _controllerMineral9.text,
      'MineralStyle9': _controllerMineral9Style.text,
      'Mineral9_Percent': _controllerMineral9Percent.text,
      'Mineral10': _controllerMineral10.text,
      'MineralStyle10': _controllerMineral10Style.text,
      'Mineral10_Percent': _controllerMineral10Percent.text,
      'Mineral11': _controllerMineral11.text,
      'MineralStyle11': _controllerMineral11Style.text,
      'Mineral11_Percent': _controllerMineral11Percent.text,
      'Mineral12': _controllerMineral12.text,
      'MineralStyle12': _controllerMineral12Style.text,
      'Mineral12_Percent': _controllerMineral12Percent.text,
      'status': 1
    };
    if (await validateRequired(valores)) {
      await registerMineralisation(valores);
    } else {
      if (errors != '') {
        Loader.hide();
        /*
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
              await registerMineralisation(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
            */
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

  Future<void> actualizarMineralisation() async {
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
      'Mineral_Comment': _controllerComments.text,
      'No_Qtz_Veins': _controllerNoQtzVeins.text.toString(),
      'Mineral1': _controllerMineral1.text.toString(),
      'MineralStyle1': _controllerMineral1Style.text.toString(),
      'Mineral1_Percent': _controllerMineral1Percent.text.toString(),
      'Mineral2': _controllerMineral2.text.toString(),
      'MineralStyle2': _controllerMineral2Style.text.toString(),
      'Mineral2_Percent': _controllerMineral2Percent.text.toString(),
      'Mineral3': _controllerMineral3.text.toString(),
      'MineralStyle3': _controllerMineral3Style.text.toString(),
      'Mineral3_Percent': _controllerMineral3Percent.text.toString(),
      'Mineral4': _controllerMineral4.text.toString(),
      'MineralStyle4': _controllerMineral4Style.text.toString(),
      'Mineral4_Percent': _controllerMineral4Percent.text.toString(),
      'Mineral5': _controllerMineral5.text.toString(),
      'MineralStyle5': _controllerMineral5Style.text.toString(),
      'Mineral5_Percent': _controllerMineral5Percent.text.toString(),
      'Mineral6': _controllerMineral6.text.toString(),
      'MineralStyle6': _controllerMineral6Style.text.toString(),
      'Mineral6_Percent': _controllerMineral6Percent.text.toString(),
      'Mineral7': _controllerMineral7.text.toString(),
      'MineralStyle7': _controllerMineral7Style.text.toString(),
      'Mineral7_Percent': _controllerMineral7Percent.text.toString(),
      'Mineral8': _controllerMineral8.text.toString(),
      'MineralStyle8': _controllerMineral8Style.text.toString(),
      'Mineral8_Percent': _controllerMineral8Percent.text.toString(),
      'Mineral9': _controllerMineral9.text.toString(),
      'MineralStyle9': _controllerMineral9Style.text.toString(),
      'Mineral9_Percent': _controllerMineral9Percent.text.toString(),
      'Mineral10': _controllerMineral10.text.toString(),
      'MineralStyle10': _controllerMineral10Style.text.toString(),
      'Mineral10_Percent': _controllerMineral10Percent.text.toString(),
      'Mineral11': _controllerMineral11.text.toString(),
      'MineralStyle11': _controllerMineral11Style.text.toString(),
      'Mineral11_Percent': _controllerMineral11Percent.text.toString(),
      'Mineral12': _controllerMineral12.text.toString(),
      'MineralStyle12': _controllerMineral12Style.text.toString(),
      'Mineral12_Percent': _controllerMineral12Percent.text.toString(),
      'status': 1
    };
    int response = await _db.fnActualizarRegistro(
        'tb_mineralisation', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarMineralisation(widget.holeId);
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
        text: 'Mineralisation data has been updated successfully',
      );
    }
  }

  Future<void> registerMineralisation(valores) async {
    int response = await _db.fnInsertarRegistro('tb_mineralisation', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarMineralisation(widget.holeId);
      _controllerGeolFrom.text = _controllerGeolTo.text;
      _controllerGeolTo.clear();
      _controllerComments.clear();
      _controllerNoQtzVeins.clear();
      _controllerMineral1.clear();
      _controllerMineral1Style.clear();
      _controllerMineral1Percent.clear();
      _controllerMineral2.clear();
      _controllerMineral2Style.clear();
      _controllerMineral2Percent.clear();
      _controllerMineral3.clear();
      _controllerMineral3Style.clear();
      _controllerMineral3Percent.clear();
      _controllerMineral4.clear();
      _controllerMineral4Style.clear();
      _controllerMineral4Percent.clear();
      _controllerMineral5.clear();
      _controllerMineral5Style.clear();
      _controllerMineral5Percent.clear();
      _controllerMineral6.clear();
      _controllerMineral6Style.clear();
      _controllerMineral6Percent.clear();
      _controllerMineral7.clear();
      _controllerMineral7Style.clear();
      _controllerMineral7Percent.clear();
      _controllerMineral8.clear();
      _controllerMineral8Style.clear();
      _controllerMineral8Percent.clear();
      _controllerMineral9.clear();
      _controllerMineral9Style.clear();
      _controllerMineral9Percent.clear();
      _controllerMineral10.clear();
      _controllerMineral10Style.clear();
      _controllerMineral10Percent.clear();
      _controllerMineral11.clear();
      _controllerMineral11Style.clear();
      _controllerMineral11Percent.clear();
      _controllerMineral12.clear();
      _controllerMineral12Style.clear();
      _controllerMineral12Percent.clear();
      _selectedMineralisation = '1';
      _key.currentState?.reset();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Mineralisation data has been saved successfully',
      );
    }
  }

  Future<bool> validateRequired(Map<String, Object?> valores) async {
    double mineralPercent = 0;
    errors = '';
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

    if (isNumeric(valores['Mineral1_Percent'].toString()) &&
        double.parse(valores['Mineral1_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral1_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral2_Percent'].toString()) &&
        double.parse(valores['Mineral2_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral2_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral3_Percent'].toString()) &&
        double.parse(valores['Mineral3_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral3_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral4_Percent'].toString()) &&
        double.parse(valores['Mineral4_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral4_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral5_Percent'].toString()) &&
        double.parse(valores['Mineral5_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral5_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral6_Percent'].toString()) &&
        double.parse(valores['Mineral6_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral6_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral7_Percent'].toString()) &&
        double.parse(valores['Mineral7_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral7_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral8_Percent'].toString()) &&
        double.parse(valores['Mineral8_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral8_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral9_Percent'].toString()) &&
        double.parse(valores['Mineral9_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral9_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral10_Percent'].toString()) &&
        double.parse(valores['Mineral10_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral10_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral11_Percent'].toString()) &&
        double.parse(valores['Mineral11_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral11_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral12_Percent'].toString()) &&
        double.parse(valores['Mineral12_Percent'].toString()) > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral12_Percent data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Mineral1_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral1_Percent'].toString());
    }
    if (isNumeric(valores['Mineral2_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral2_Percent'].toString());
    }
    if (isNumeric(valores['Mineral3_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral3_Percent'].toString());
    }
    if (isNumeric(valores['Mineral4_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral4_Percent'].toString());
    }
    if (isNumeric(valores['Mineral5_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral5_Percent'].toString());
    }
    if (isNumeric(valores['Mineral6_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral6_Percent'].toString());
    }
    if (isNumeric(valores['Mineral7_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral7_Percent'].toString());
    }
    if (isNumeric(valores['Mineral8_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral8_Percent'].toString());
    }
    if (isNumeric(valores['Mineral9_Percent'].toString())) {
      mineralPercent =
          mineralPercent + double.parse(valores['Mineral9_Percent'].toString());
    }
    if (isNumeric(valores['Mineral10_Percent'].toString())) {
      mineralPercent = mineralPercent +
          double.parse(valores['Mineral10_Percent'].toString());
    }
    if (isNumeric(valores['Mineral11_Percent'].toString())) {
      mineralPercent = mineralPercent +
          double.parse(valores['Mineral11_Percent'].toString());
    }
    if (isNumeric(valores['Mineral12_Percent'].toString())) {
      mineralPercent = mineralPercent +
          double.parse(valores['Mineral12_Percent'].toString());
    }
    if (mineralPercent > 100) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Mineral % sum must not exceed 100.');

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

      if (!onUpdate) {
        if (_lastGeolTo > 0) {
          /*
          if (double.parse(valores['GeolFrom'].toString()) >
              double.parse(_lastGeolTo.toString())) {
            errors += '• Your last GeolTo was "' +
                _lastGeolTo.toString() +
                '" and your GeolFrom is "' +
                valores['GeolFrom'].toString() +
                '", so there is a difference.\n';
          }
           */
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

  Future<void> fnLlenarMineralisation(int collarId) async {
    double _geolTo = 0;
    _cells.clear();
    int currentRow = 0;
    List<MineralisationModel> listMineralisationModel =
        await new MineralisationModel()
            .fnObtenerRegistrosPorCollarId(collarId: collarId)
            .then((value) => value);
    listMineralisationModel.forEach((model) {
      Color cell_color = Colors.black;
      currentRow++;
      if (double.parse(model.geolFrom.toStringAsFixed(3)) > _lastGeolTo ||
          double.parse(model.geolFrom.toStringAsFixed(3)) < _lastGeolTo) {
        if (currentRow == 1) {
          cell_color = Colors.black;
        } else {
          cell_color = Colors.red;
        }
      }
      _cells.add(
        DataRow(
          cells: [
            DataCell(Text(
              '${model.geolFrom.toStringAsFixed(3)}',
              style: TextStyle(color: cell_color),
            )),
            DataCell(Text('${model.geolTo.toStringAsFixed(3)}')),
            DataCell(Text('${model.mineralComments}')),
            DataCell(Text('${model.noQtzVeins}')),
            DataCell(Text('${model.mineral1Name}')),
            DataCell(Text('${model.mineral1StyleName}')),
            DataCell(Text('${model.mineral1Percent}')),
            DataCell(Text('${model.mineral2Name}')),
            DataCell(Text('${model.mineral2StyleName}')),
            DataCell(Text('${model.mineral2Percent}')),
            DataCell(Text('${model.mineral3Name}')),
            DataCell(Text('${model.mineral3StyleName}')),
            DataCell(Text('${model.mineral3Percent}')),
            DataCell(Text('${model.mineral4Name}')),
            DataCell(Text('${model.mineral4StyleName}')),
            DataCell(Text('${model.mineral4Percent}')),
            DataCell(Text('${model.mineral5Name}')),
            DataCell(Text('${model.mineral5StyleName}')),
            DataCell(Text('${model.mineral5Percent}')),
            DataCell(Text('${model.mineral6Name}')),
            DataCell(Text('${model.mineral6StyleName}')),
            DataCell(Text('${model.mineral6Percent}')),
            DataCell(Text('${model.mineral7Name}')),
            DataCell(Text('${model.mineral7StyleName}')),
            DataCell(Text('${model.mineral7Percent}')),
            DataCell(Text('${model.mineral8Name}')),
            DataCell(Text('${model.mineral8StyleName}')),
            DataCell(Text('${model.mineral8Percent}')),
            DataCell(Text('${model.mineral9Name}')),
            DataCell(Text('${model.mineral9StyleName}')),
            DataCell(Text('${model.mineral9Percent}')),
            DataCell(Text('${model.mineral10Name}')),
            DataCell(Text('${model.mineral10StyleName}')),
            DataCell(Text('${model.mineral10Percent}')),
            DataCell(Text('${model.mineral11Name}')),
            DataCell(Text('${model.mineral11StyleName}')),
            DataCell(Text('${model.mineral11Percent}')),
            DataCell(Text('${model.mineral12Name}')),
            DataCell(Text('${model.mineral12StyleName}')),
            DataCell(Text('${model.mineral12Percent}')),
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
                              nombreTabla: 'tb_mineralisation',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _controllerGeolFrom.text =
                              rows.values.elementAt(2).toString();
                          _controllerGeolTo.text =
                              rows.values.elementAt(3).toString();
                          _controllerComments.text =
                              rows.values.elementAt(5).toString();
                          _controllerNoQtzVeins.text =
                              rows.values.elementAt(6).toString();
                          _controllerMineral1.text =
                              rows.values.elementAt(7).toString();
                          _controllerMineral1Style.text =
                              rows.values.elementAt(8).toString();
                          _controllerMineral1Percent.text =
                              rows.values.elementAt(9).toString();
                          _controllerMineral2.text =
                              rows.values.elementAt(10).toString();
                          _controllerMineral2Style.text =
                              rows.values.elementAt(11).toString();
                          _controllerMineral2Percent.text =
                              rows.values.elementAt(12).toString();
                          _controllerMineral3.text =
                              rows.values.elementAt(13).toString();
                          _controllerMineral3Style.text =
                              rows.values.elementAt(14).toString();
                          _controllerMineral3Percent.text =
                              rows.values.elementAt(15).toString();
                          _controllerMineral4.text =
                              rows.values.elementAt(16).toString();
                          _controllerMineral4Style.text =
                              rows.values.elementAt(17).toString();
                          _controllerMineral4Percent.text =
                              rows.values.elementAt(18).toString();
                          _controllerMineral5.text =
                              rows.values.elementAt(19).toString();
                          _controllerMineral5Style.text =
                              rows.values.elementAt(20).toString();
                          _controllerMineral5Percent.text =
                              rows.values.elementAt(21).toString();
                          _controllerMineral6.text =
                              rows.values.elementAt(22).toString();
                          _controllerMineral6Style.text =
                              rows.values.elementAt(23).toString();
                          _controllerMineral6Percent.text =
                              rows.values.elementAt(24).toString();
                          _controllerMineral7.text =
                              rows.values.elementAt(25).toString();
                          _controllerMineral7Style.text =
                              rows.values.elementAt(26).toString();
                          _controllerMineral7Percent.text =
                              rows.values.elementAt(27).toString();
                          _controllerMineral8.text =
                              rows.values.elementAt(28).toString();
                          _controllerMineral8Style.text =
                              rows.values.elementAt(29).toString();
                          _controllerMineral8Percent.text =
                              rows.values.elementAt(30).toString();
                          _controllerMineral9.text =
                              rows.values.elementAt(31).toString();
                          _controllerMineral9Style.text =
                              rows.values.elementAt(32).toString();
                          _controllerMineral9Percent.text =
                              rows.values.elementAt(33).toString();
                          _controllerMineral10.text =
                              rows.values.elementAt(34).toString();
                          _controllerMineral10Style.text =
                              rows.values.elementAt(35).toString();
                          _controllerMineral10Percent.text =
                              rows.values.elementAt(36).toString();
                          _controllerMineral11.text =
                              rows.values.elementAt(37).toString();
                          _controllerMineral11Style.text =
                              rows.values.elementAt(38).toString();
                          _controllerMineral11Percent.text =
                              rows.values.elementAt(39).toString();
                          _controllerMineral12.text =
                              rows.values.elementAt(40).toString();
                          _controllerMineral12Style.text =
                              rows.values.elementAt(41).toString();
                          _controllerMineral12Percent.text =
                              rows.values.elementAt(42).toString();
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
        fnEliminarMineralisation(selectedRow);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure ?"),
      content: Text("The information will be erased and cannot be recovered."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> fnCargarTabs() async {
    int contador = 0;
    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerCamposActivas(widget.holeId, 'tb_mineralisation');
    if (tb.length > 0) {
      for (RelProfileTabsFieldsModal item in tb) {
        String nombre = item.fieldName;
        String capNombre = nombre.toUpperCase();
        if (nombre == 'Mineral1') {
          contador = 1;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral2') {
          contador = 2;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral3') {
          contador = 3;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral4') {
          contador = 4;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral5') {
          contador = 5;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral6') {
          contador = 6;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral6') {
          contador = 6;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral7') {
          contador = 7;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral8') {
          contador = 8;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral9') {
          contador = 9;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral10') {
          contador = 10;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral11') {
          contador = 11;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
        if (nombre == 'Mineral12') {
          contador = 12;
          _items_mineralisation.add({
            'value': contador,
            'label': nombre,
            'icon': Icon(Icons.filter_list_rounded),
          });
        }
      }
      setState(() {
        _initial_item_field = tb.first.fieldName;
        _valueChanged = _initial_item_field;
      });
    }
    return true;
  }

  Future<void> fnEliminarMineralisation(int id) async {
    await new MineralisationModel()
        .fnEliminarRegistro(
            nombreTabla: 'tb_mineralisation', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarMineralisation(widget.holeId);
      }
    });
  }
}
