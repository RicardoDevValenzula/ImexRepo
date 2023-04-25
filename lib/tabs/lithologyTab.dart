import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/LithologyModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class LithologyTab extends StatefulWidget {
  //late bool chkUpdate;
  final int holeId;
  final double totalDepth;
  final ValueChanged<bool> pageEvent;
  LithologyTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  LithologyTabState createState() => LithologyTabState(pageEvent: pageEvent);
}

class LithologyTabState extends State<LithologyTab> {
  final ValueChanged<bool> pageEvent;
  LithologyTabState({required this.pageEvent});

  final _db = new DBDataEntry();

  TextEditingController _controllerGeolFrom = TextEditingController();
  TextEditingController _controllerGeolTo = TextEditingController();
  TextEditingController _controllerComments = TextEditingController();
  TextEditingController _controllerLithLocal = TextEditingController();
  TextEditingController _controllerLithContact = TextEditingController();
  TextEditingController? _controllerLithology;

  TextEditingController _controllerLith1Abund = TextEditingController();
  TextEditingController _controllerLith1Spec = TextEditingController();
  TextEditingController _controllerLith1Mod = TextEditingController();
  TextEditingController _controllerLith1ColorMod = TextEditingController();
  TextEditingController _controllerLith1Color = TextEditingController();

  TextEditingController _controllerLith2Abund = TextEditingController();
  TextEditingController _controllerLith2Spec = TextEditingController();
  TextEditingController _controllerLith2Mod = TextEditingController();
  TextEditingController _controllerLith2ColorMod = TextEditingController();
  TextEditingController _controllerLith2Color = TextEditingController();

  TextEditingController _controllerLith3Abund = TextEditingController();
  TextEditingController _controllerLith3Spec = TextEditingController();
  TextEditingController _controllerLith3Mod = TextEditingController();
  TextEditingController _controllerLith3ColorMod = TextEditingController();
  TextEditingController _controllerLith3Color = TextEditingController();

  TextEditingController _controllerLith4Abund = TextEditingController();
  TextEditingController _controllerLith4Spec = TextEditingController();
  TextEditingController _controllerLith4Mod = TextEditingController();
  TextEditingController _controllerLith4ColorMod = TextEditingController();
  TextEditingController _controllerLith4Color = TextEditingController();

  TextEditingController _controllerLith5Abund = TextEditingController();
  TextEditingController _controllerLith5Spec = TextEditingController();
  TextEditingController _controllerLith5Mod = TextEditingController();
  TextEditingController _controllerLith5ColorMod = TextEditingController();
  TextEditingController _controllerLith5Color = TextEditingController();

  TextEditingController _controllerLithCategory = TextEditingController();

  late List<Map<String, dynamic>> _itemsLithologyLocal = [];
  late List<Map<String, dynamic>> _itemsLithContact = [];
  //late List<Map<String, dynamic>> _itemsLithAbund = [];
  late List<Map<String, dynamic>> _itemsLithSpec = [];
  late List<Map<String, dynamic>> _itemsLithMod = [];
  late List<Map<String, dynamic>> _itemsLithColorMod = [];
  late List<Map<String, dynamic>> _itemsLithColor = [];
  late List<Map<String, dynamic>> _itemsLithCategory = [];

  String _selectedLithology = '1';
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  List<DataRow> _cells = [];
  String errors = "";
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
  int selectedRow = 0;
  bool onUpdate = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  bool geolFromDifference = false;
  bool geolToDifference = false;
  bool candado = false;

  final List<Map<String, dynamic>> _items_lithology = [
    {
      'value': '1',
      'label': 'Lithology 1',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '2',
      'label': 'Lithology 2',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '3',
      'label': 'Lithology 3',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '4',
      'label': 'Lithology 4',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '5',
      'label': 'Lithology 5',
      'icon': Icon(Icons.filter_list_rounded),
    }
  ];
  @override
  void initState() {
    super.initState();
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_lithlocal').then((rows) {
      setState(() {
        _itemsLithologyLocal = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_lithcontact').then((rows) {
      setState(() {
        _itemsLithContact = rows;
      });
    });

    _db.fnRegistrosValueLabelIcon(tbName: 'cat_lithspec').then((rows) {
      setState(() {
        _itemsLithSpec = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_lithmod').then((rows) {
      setState(() {
        _itemsLithMod = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_lithcolormod').then((rows) {
      setState(() {
        _itemsLithColorMod = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_lithcolor').then((rows) {
      setState(() {
        _itemsLithColor = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(tbName: 'cat_lithology_category')
        .then((rows) {
      setStateIfMounted(() {
        _itemsLithCategory = rows;
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
    fnLlenarLithology(widget.holeId);
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
            'Lithology Tab',
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
                              if (isNumeric(_controllerGeolFrom.text) &&
                                  _lastGeolTo != 0.0 &&
                                  _lastGeolTo !=
                                      double.tryParse(
                                          _controllerGeolFrom.text)) {
                                geolFromDifference = true;
                              }
                              setStateIfMounted(() {});
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
          labelInput('Geology Comments'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: BsInput(
                    maxLines: null,
                    minLines: 4,
                    keyboardType: TextInputType.multiline,
                    style: BsInputStyle.outline,
                    size: BsInputSize.md,
                    hintText: 'Geology Comments',
                    controller: _controllerComments,
                    prefixIcon: Icons.comment)),
          ),
          SizedBox(
            height: 10,
          ),
          sFM(_controllerLithLocal, _itemsLithologyLocal, 'Lithology Local'),
          SizedBox(
            height: 10,
          ),
          sFM(_controllerLithContact, _itemsLithContact, 'Lith Contact'),
          SizedBox(
            height: 15,
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            margin: EdgeInsets.only(bottom: 30.0),
            child: Column(
              children: <Widget>[
                SelectFormField(
                  type: SelectFormFieldType.dialog,
                  controller: _controllerLithology,
                  initialValue: '1',
                  icon: Icon(Icons.tab),
                  labelText: 'Choose a lithology',
                  changeIcon: true,
                  dialogTitle: 'Pick a lithology to add',
                  dialogCancelBtn: 'CANCEL',
                  enableSearch: true,
                  dialogSearchHint: '',
                  items: _items_lithology,
                  key: _key,
                  onChanged: (val) => {
                    setStateIfMounted(() {
                      _selectedLithology = val;
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
                //sFM(_controllerLith1Abund, _itemsLithAbund, 'Lith1Abund'),
                Column(
                  children: [
                    labelInput('Lith1Abund'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Lith1Abund',
                        controller: _controllerLith1Abund,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith1Spec, _itemsLithSpec, 'Lith1Spec'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith1Mod, _itemsLithMod, 'Lith1Mod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith1ColorMod, _itemsLithColorMod,
                    'Lith1ColorMod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith1Color, _itemsLithColor, 'Lith1Color'),
              ],
            ),
            visible: (_selectedLithology == '1') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                //sFM(_controllerLith2Abund, _itemsLithAbund, 'Lith2Abund'),
                Column(
                  children: [
                    labelInput('Lith2Abund'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Lith2Abund',
                        controller: _controllerLith2Abund,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith2Spec, _itemsLithSpec, 'Lith2Spec'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith2Mod, _itemsLithMod, 'Lith2Mod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith2ColorMod, _itemsLithColorMod,
                    'Lith2ColorMod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith2Color, _itemsLithColor, 'Lith2Color'),
              ],
            ),
            visible: (_selectedLithology == '2') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                Column(
                  children: [
                    labelInput('Lith3Abund'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Lith3Abund',
                        controller: _controllerLith3Abund,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
                //sFM(_controllerLith3Abund, _itemsLithAbund, 'Lith3Abund'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith3Spec, _itemsLithSpec, 'Lith3Spec'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith3Mod, _itemsLithMod, 'Lith3Mod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith3ColorMod, _itemsLithColorMod,
                    'Lith3ColorMod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith3Color, _itemsLithColor, 'Lith3Color'),
              ],
            ),
            visible: (_selectedLithology == '3') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                Column(
                  children: [
                    labelInput('Lith4Abund'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Lith4Abund',
                        controller: _controllerLith4Abund,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
                //sFM(_controllerLith4Abund, _itemsLithAbund, 'Lith4Abund'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith4Spec, _itemsLithSpec, 'Lith4Spec'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith4Mod, _itemsLithMod, 'Lith4Mod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith4ColorMod, _itemsLithColorMod,
                    'Lith4ColorMod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith4Color, _itemsLithColor, 'Lith4Color'),
              ],
            ),
            visible: (_selectedLithology == '4') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                //sFM(_controllerLith5Abund, _itemsLithAbund, 'Lith5Abund'),
                Column(
                  children: [
                    labelInput('Lith5Abund'),
                    Container(
                      child: BsInput(
                        style: BsInputStyle.outlineRounded,
                        size: BsInputSize.md,
                        hintText: 'Lith5Abund',
                        controller: _controllerLith5Abund,
                        prefixIcon: Icons.list_alt_rounded,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith5Spec, _itemsLithSpec, 'Lith5Spec'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith5Mod, _itemsLithMod, 'Lith5Mod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith5ColorMod, _itemsLithColorMod,
                    'Lith5ColorMod'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerLith5Color, _itemsLithColor, 'Lith5Color'),
              ],
            ),
            visible: (_selectedLithology == '5') ? true : false,
          ),
          SizedBox(
            height: 15,
          ),
          Divider(),
          sFM(_controllerLithCategory, _itemsLithCategory, 'Lith Category'),
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
                    label: Text('Geology_Comments'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lithology_Local'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('LithContact'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith1Abund'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith1Spec'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith1Mod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith1ColorMod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith1Color'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith2Abund'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith2Spec'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith2Mod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith2ColorMod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith2Color'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith3Abund'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith3Spec'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith3Mod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith3ColorMod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith3Color'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith4Abund'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith4Spec'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith4Mod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith4ColorMod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith4Color'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith5Abund'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith5Spec'),
                  ),
                  DataColumn2(
                    label: Text('Lith5Mod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith5ColorMod'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Lith5Color'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('LithCategory'),
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

  Future<void> insertLithology() async {
    FocusScope.of(context).unfocus();
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );

    int Lit1Abund = 0;
    int Lit2Abund = 0;
    int Lit3Abund = 0;
    int Lit4Abund = 0;
    int Lit5Abund = 0;

    if (_controllerLith1Abund.text.toString() != '' &&
        _controllerLith1Abund.text.toString() != 0) {
      Lit1Abund = int.parse(_controllerLith1Abund.text) + 2;
    }

    if (_controllerLith2Abund.text.toString() != '' &&
        _controllerLith2Abund.text.toString() != 0) {
      Lit2Abund = int.parse(_controllerLith2Abund.text) + 2;
    }
    if (_controllerLith3Abund.text.toString() != '' &&
        _controllerLith3Abund.text.toString() != 0) {
      Lit3Abund = int.parse(_controllerLith3Abund.text) + 2;
    }
    if (_controllerLith4Abund.text.toString() != '' &&
        _controllerLith4Abund.text.toString() != 0) {
      Lit4Abund = int.parse(_controllerLith4Abund.text) + 2;
    }
    if (_controllerLith5Abund.text.toString() != '' &&
        _controllerLith5Abund.text.toString() != 0) {
      Lit5Abund = int.parse(_controllerLith5Abund.text) + 2;
    }

    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _controllerGeolFrom.text,
      'GeolTo': _controllerGeolTo.text,
      'Geology_Comment': _controllerComments.text,
      'Lithology_Local': _controllerLithLocal.text.toString(),
      'LithContact': _controllerLithContact.text.toString(),
      'Lith1Abund': Lit1Abund.toString(),
      'Lith1Spec': _controllerLith1Spec.text.toString(),
      'Lith1Mod': _controllerLith1Mod.text.toString(),
      'Lith1ColorMod': _controllerLith1ColorMod.text.toString(),
      'Lith1Color': _controllerLith1Color.text.toString(),
      'Lith2Abund': Lit2Abund.toString(),
      'Lith2Spec': _controllerLith2Spec.text.toString(),
      'Lith2Mod': _controllerLith2Mod.text.toString(),
      'Lith2ColorMod': _controllerLith2ColorMod.text.toString(),
      'Lith2Color': _controllerLith2Color.text.toString(),
      'Lith3Abund': Lit3Abund.toString(),
      'Lith3Spec': _controllerLith3Spec.text.toString(),
      'Lith3Mod': _controllerLith3Mod.text.toString(),
      'Lith3ColorMod': _controllerLith3ColorMod.text.toString(),
      'Lith3Color': _controllerLith3Color.text.toString(),
      'Lith4Abund': Lit4Abund.toString(),
      'Lith4Spec': _controllerLith4Spec.text.toString(),
      'Lith4Mod': _controllerLith4Mod.text.toString(),
      'Lith4ColorMod': _controllerLith4ColorMod.text.toString(),
      'Lith4Color': _controllerLith4Color.text.toString(),
      'Lith5Abund': Lit5Abund.toString(),
      'Lith5Spec': _controllerLith5Spec.text.toString(),
      'Lith5Mod': _controllerLith5Mod.text.toString(),
      'Lith5ColorMod': _controllerLith5ColorMod.text.toString(),
      'Lith5Color': _controllerLith5Color.text.toString(),
      'Lithology_Category': _controllerLithCategory.text.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
      await registerLithology(valores);
      /*Loader.hide();
      await _addRowTable();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'The Lithology data was saved correctly.',
      );*/
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
              await registerLithology(valores);
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

  Future<void> actualizarLithology() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );

    int Lit1Abund = 0;
    int Lit2Abund = 0;
    int Lit3Abund = 0;
    int Lit4Abund = 0;
    int Lit5Abund = 0;
    if (_controllerLith1Abund.text.toString() != '' &&
        _controllerLith1Abund.text.toString() != 0) {
      Lit1Abund = int.parse(_controllerLith1Abund.text) + 2;
    }

    if (_controllerLith2Abund.text.toString() != '' &&
        _controllerLith2Abund.text.toString() != 0) {
      Lit2Abund = int.parse(_controllerLith2Abund.text) + 2;
    }

    if (_controllerLith3Abund.text.toString() != '' &&
        _controllerLith3Abund.text.toString() != 0) {
      Lit3Abund = int.parse(_controllerLith3Abund.text) + 2;
    }

    if (_controllerLith4Abund.text.toString() != '' &&
        _controllerLith4Abund.text.toString() != 0) {
      Lit4Abund = int.parse(_controllerLith4Abund.text) + 2;
    }

    if (_controllerLith5Abund.text.toString() != '' &&
        _controllerLith5Abund.text.toString() != 0) {
      Lit5Abund = int.parse(_controllerLith5Abund.text) + 2;
    }

    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': double.parse(_controllerGeolFrom.text).toStringAsFixed(3),
      'GeolTo': double.parse(_controllerGeolTo.text).toStringAsFixed(3),
      'Geology_Comment': _controllerComments.text,
      'Lithology_Local': _controllerLithLocal.text.toString(),
      'LithContact': _controllerLithContact.text.toString(),
      'Lith1Abund': Lit1Abund.toString(),
      'Lith1Spec': _controllerLith1Spec.text.toString(),
      'Lith1Mod': _controllerLith1Mod.text.toString(),
      'Lith1ColorMod': _controllerLith1ColorMod.text.toString(),
      'Lith1Color': _controllerLith1Color.text.toString(),
      'Lith2Abund': Lit2Abund.toString(),
      'Lith2Spec': _controllerLith2Spec.text.toString(),
      'Lith2Mod': _controllerLith2Mod.text.toString(),
      'Lith2ColorMod': _controllerLith2ColorMod.text.toString(),
      'Lith2Color': _controllerLith2Color.text.toString(),
      'Lith3Abund': Lit3Abund.toString(),
      'Lith3Spec': _controllerLith3Spec.text.toString(),
      'Lith3Mod': _controllerLith3Mod.text.toString(),
      'Lith3ColorMod': _controllerLith3ColorMod.text.toString(),
      'Lith3Color': _controllerLith3Color.text.toString(),
      'Lith4Abund': Lit4Abund.toString(),
      'Lith4Spec': _controllerLith4Spec.text.toString(),
      'Lith4Mod': _controllerLith4Mod.text.toString(),
      'Lith4ColorMod': _controllerLith4ColorMod.text.toString(),
      'Lith4Color': _controllerLith4Color.text.toString(),
      'Lith5Abund': Lit5Abund.toString(),
      'Lith5Spec': _controllerLith5Spec.text.toString(),
      'Lith5Mod': _controllerLith5Mod.text.toString(),
      'Lith5ColorMod': _controllerLith5ColorMod.text.toString(),
      'Lith5Color': _controllerLith5Color.text.toString(),
      'Lithology_Category': _controllerLithCategory.text.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
      int response = await _db.fnActualizarRegistro(
          'tb_lithology', valores, 'Id', selectedRow);
      if (response > 0) {
        Loader.hide();
        await fnLlenarLithology(widget.holeId);
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
          text: 'Lithology data has been updated successfully',
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

  Future<void> registerLithology(valores) async {
    int response = await _db.fnInsertarRegistro('tb_lithology', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarLithology(widget.holeId);
      _controllerGeolFrom.text = _controllerGeolTo.text;
      _controllerGeolTo.clear();
      _controllerComments.clear();
      _controllerLithLocal.clear();
      _controllerLithContact.clear();
      _controllerLith1Abund.clear();
      _controllerLith1Spec.clear();
      _controllerLith1Mod.clear();
      _controllerLith1ColorMod.clear();
      _controllerLith1Color.clear();
      _controllerLith2Abund.clear();
      _controllerLith2Spec.clear();
      _controllerLith2Mod.clear();
      _controllerLith2ColorMod.clear();
      _controllerLith2Color.clear();
      _controllerLith3Abund.clear();
      _controllerLith3Spec.clear();
      _controllerLith3Mod.clear();
      _controllerLith3ColorMod.clear();
      _controllerLith3Color.clear();
      _controllerLith4Abund.clear();
      _controllerLith4Spec.clear();
      _controllerLith4Mod.clear();
      _controllerLith4ColorMod.clear();
      _controllerLith4Color.clear();
      _controllerLith5Abund.clear();
      _controllerLith5Spec.clear();
      _controllerLith5Mod.clear();
      _controllerLith5ColorMod.clear();
      _controllerLith5Color.clear();
      _controllerLithCategory.clear();
      _selectedLithology = '1';
      _key.currentState?.reset();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Lithology data has been saved successfully',
      );
    }
  }

  Future<bool> validateRequired(Map<String, Object?> valores) async {
    int lithAbund = 0;
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
    print(valores['Lith1Abund']);
    if (isNumeric(valores['Lith1Abund'].toString()) &&
        double.parse(valores['Lith1Abund'].toString()) > 102) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Lith1Abund data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Lith2Abund'].toString()) &&
        double.parse(valores['Lith2Abund'].toString()) > 102) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Lith2Abund data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Lith3Abund'].toString()) &&
        double.parse(valores['Lith3Abund'].toString()) > 102) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Lith3Abund data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Lith4Abund'].toString()) &&
        double.parse(valores['Lith4Abund'].toString()) > 102) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Lith4Abund data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Lith5Abund'].toString()) &&
        double.parse(valores['Lith5Abund'].toString()) > 102) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The Lith5Abund data cannot be greater than 100.');

      return false;
    }
    if (isNumeric(valores['Lith1Abund'].toString())) {
      lithAbund = lithAbund + int.parse(valores['Lith1Abund'].toString());
    }
    if (isNumeric(valores['Lith2Abund'].toString())) {
      lithAbund = lithAbund + int.parse(valores['Lith2Abund'].toString());
    }
    if (isNumeric(valores['Lith3Abund'].toString())) {
      lithAbund = lithAbund + int.parse(valores['Lith3Abund'].toString());
    }
    if (isNumeric(valores['Lith4Abund'].toString())) {
      lithAbund = lithAbund + int.parse(valores['Lith4Abund'].toString());
    }
    if (isNumeric(valores['Lith5Abund'].toString())) {
      lithAbund = lithAbund + int.parse(valores['Lith5Abund'].toString());
    }
    if (lithAbund > 104) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'The LithAbund sum must not exceed 100.');

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
        // #INSERT.
        if (double.parse(valores['GeolFrom'].toString()) >
            double.parse(_lastGeolTo.toString())) {
          errors += '• Your last GeolTo was "' +
              _lastGeolTo.toString() +
              '" and your GeolFrom is "' +
              valores['GeolFrom'].toString() +
              '", so there is a difference.\n';
        }
      } else {
        // #UPDATE.
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
        _controllerGeolFrom.text,
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        _controllerGeolTo.text,
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        _controllerComments.text,
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithlocal', 'id', int.tryParse(_controllerLithLocal.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithcontact', 'id', int.tryParse(_controllerLithContact.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lith1abund', 'id', int.tryParse(_controllerLith1Abund.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithspec', 'id', int.tryParse(_controllerLith1Spec.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithmod', 'id', int.tryParse(_controllerLith1Mod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_lithcolormod', 'id',
            int.tryParse(_controllerLith1ColorMod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithcolor', 'id', int.tryParse(_controllerLith1Color.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lith1abund', 'id', int.tryParse(_controllerLith2Abund.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithspec', 'id', int.tryParse(_controllerLith2Spec.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithmod', 'id', int.tryParse(_controllerLith2Mod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_lithcolormod', 'id',
            int.tryParse(_controllerLith2ColorMod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithcolor', 'id', int.tryParse(_controllerLith2Color.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lith1abund', 'id', int.tryParse(_controllerLith3Abund.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithspec', 'id', int.tryParse(_controllerLith3Spec.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithmod', 'id', int.tryParse(_controllerLith3Mod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_lithcolormod', 'id',
            int.tryParse(_controllerLith3ColorMod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithcolor', 'id', int.tryParse(_controllerLith3Color.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lith1abund', 'id', int.tryParse(_controllerLith4Abund.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithspec', 'id', int.tryParse(_controllerLith4Spec.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithmod', 'id', int.tryParse(_controllerLith4Mod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_lithcolormod', 'id',
            int.tryParse(_controllerLith4ColorMod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithcolor', 'id', int.tryParse(_controllerLith4Color.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lith1abund', 'id', int.tryParse(_controllerLith5Abund.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithspec', 'id', int.tryParse(_controllerLith5Spec.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithmod', 'id', int.tryParse(_controllerLith5Mod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_lithcolormod', 'id',
            int.tryParse(_controllerLith5ColorMod.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_lithcolor', 'id', int.tryParse(_controllerLith5Color.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_lithology_category', 'id',
            int.tryParse(_controllerLithCategory.text)),
        textAlign: TextAlign.center,
      )),
    ]));

    _controllerGeolFrom.text = _controllerGeolTo.text;
    _controllerGeolTo.clear();
    _controllerComments.clear();
    _controllerLithLocal.clear();
    _controllerLithContact.clear();
    _controllerLith1Abund.clear();
    _controllerLith1Spec.clear();
    _controllerLith1Mod.clear();
    _controllerLith1ColorMod.clear();
    _controllerLith1Color.clear();
    _controllerLith2Abund.clear();
    _controllerLith2Spec.clear();
    _controllerLith2Mod.clear();
    _controllerLith2ColorMod.clear();
    _controllerLith2Color.clear();
    _controllerLith3Abund.clear();
    _controllerLith3Spec.clear();
    _controllerLith3Mod.clear();
    _controllerLith3ColorMod.clear();
    _controllerLith3Color.clear();
    _controllerLith4Abund.clear();
    _controllerLith4Spec.clear();
    _controllerLith4Mod.clear();
    _controllerLith4ColorMod.clear();
    _controllerLith4Color.clear();
    _controllerLith5Abund.clear();
    _controllerLith5Spec.clear();
    _controllerLith5Mod.clear();
    _controllerLith5ColorMod.clear();
    _controllerLith5Color.clear();
    _controllerLithCategory.clear();
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

  Future<void> fnLlenarLithology(int collarId) async {
    double _geolTo = 0;
    _cells.clear();
    int currentRow = 0;
    List<LithologyModel> listLithologyModel = await new LithologyModel()
        .fnObtenerRegistrosPorCollarId(collarId: collarId)
        .then((value) => value);
    listLithologyModel.forEach((model) {
      Color cell_color = Colors.black;
      currentRow++;
      if (double.parse(model.geolFrom.toStringAsFixed(3)) > _lastGeolTo ||
          double.parse(model.geolFrom.toStringAsFixed(3)) < _lastGeolTo) {
        cell_color = Colors.red;
      }

      _cells.add(
        DataRow(
          cells: [
            DataCell(Text(
              '${model.geolFrom.toStringAsFixed(3)}',
              style: TextStyle(color: cell_color),
            )),
            DataCell(Text('${model.geolTo.toStringAsFixed(3)}')),
            DataCell(Text('${model.geologyComment}')),
            DataCell(Text('${model.lithLocalName}')),
            DataCell(Text('${model.lithContactName}')),
            DataCell(Text('${model.lithAbund1Name}')),
            DataCell(Text('${model.lithSpec1Name}')),
            DataCell(Text('${model.lithMod1Name}')),
            DataCell(Text('${model.lithColorMod1Name}')),
            DataCell(Text('${model.lithColor1Name}')),
            DataCell(Text('${model.lithAbund2Name}')),
            DataCell(Text('${model.lithSpec2Name}')),
            DataCell(Text('${model.lithMod2Name}')),
            DataCell(Text('${model.lithColorMod2Name}')),
            DataCell(Text('${model.lithColor2Name}')),
            DataCell(Text('${model.lithAbund3Name}')),
            DataCell(Text('${model.lithSpec3Name}')),
            DataCell(Text('${model.lithMod3Name}')),
            DataCell(Text('${model.lithColorMod3Name}')),
            DataCell(Text('${model.lithColor3Name}')),
            DataCell(Text('${model.lithAbund4Name}')),
            DataCell(Text('${model.lithSpec4Name}')),
            DataCell(Text('${model.lithMod4Name}')),
            DataCell(Text('${model.lithColorMod4Name}')),
            DataCell(Text('${model.lithColor4Name}')),
            DataCell(Text('${model.lithAbund5Name}')),
            DataCell(Text('${model.lithSpec5Name}')),
            DataCell(Text('${model.lithMod5Name}')),
            DataCell(Text('${model.lithColorMod5Name}')),
            DataCell(Text('${model.lithColor5Name}')),
            DataCell(Text('${model.lithologyCategoryName}')),
          ],
          onSelectChanged: candado
              ? null
              : (newValue) {
                  _getSelectedRowInfo(model);
                },
        ),
      );
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
                              nombreTabla: 'tb_lithology',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          String lith1Abund =
                              rows.values.elementAt(8).toString();
                          String lith2Abund =
                              rows.values.elementAt(13).toString();
                          String lith3Abund =
                              rows.values.elementAt(18).toString();
                          String lith4Abund =
                              rows.values.elementAt(23).toString();
                          String lith5Abund =
                              rows.values.elementAt(28).toString();

                          _controllerGeolFrom.text =
                              rows.values.elementAt(2).toString();
                          _controllerGeolTo.text =
                              rows.values.elementAt(3).toString();
                          _controllerComments.text =
                              rows.values.elementAt(5).toString();
                          _controllerLithLocal.text =
                              rows.values.elementAt(6).toString();
                          _controllerLithContact.text =
                              rows.values.elementAt(7).toString();

                          if (isNumeric(rows.values.elementAt(8).toString()) &&
                              (rows.values.elementAt(8).toString()) != "103" &&
                              (rows.values.elementAt(8).toString()) != "0") {
                            _controllerLith1Abund.text =
                                (int.parse(lith1Abund) - 2).toString();
                          } else {
                            _controllerLith1Abund.text = "";
                          }
                          _controllerLith1Spec.text =
                              rows.values.elementAt(9).toString();
                          _controllerLith1Mod.text =
                              rows.values.elementAt(10).toString();
                          _controllerLith1ColorMod.text =
                              rows.values.elementAt(11).toString();
                          _controllerLith1Color.text =
                              rows.values.elementAt(12).toString();

                          //_controllerLith2Abund.text = rows.values.elementAt(13).toString();
                          if (isNumeric(rows.values.elementAt(13).toString()) &&
                              (rows.values.elementAt(13).toString()) != "103" &&
                              (rows.values.elementAt(13).toString()) != "0") {
                            _controllerLith2Abund.text =
                                (int.parse(lith2Abund) - 2).toString();
                          } else {
                            _controllerLith2Abund.text = "";
                          }
                          _controllerLith2Spec.text =
                              rows.values.elementAt(14).toString();
                          _controllerLith2Mod.text =
                              rows.values.elementAt(15).toString();
                          _controllerLith2ColorMod.text =
                              rows.values.elementAt(16).toString();
                          _controllerLith2Color.text =
                              rows.values.elementAt(17).toString();

                          ////
                          if (isNumeric(rows.values.elementAt(18).toString()) &&
                              (rows.values.elementAt(18).toString()) != "103" &&
                              (rows.values.elementAt(18).toString()) != "0") {
                            _controllerLith3Abund.text =
                                (int.parse(lith3Abund) - 2).toString();
                          } else {
                            _controllerLith3Abund.text = "";
                          }
                          _controllerLith3Spec.text =
                              rows.values.elementAt(19).toString();
                          _controllerLith3Mod.text =
                              rows.values.elementAt(20).toString();
                          _controllerLith3ColorMod.text =
                              rows.values.elementAt(21).toString();
                          _controllerLith3Color.text =
                              rows.values.elementAt(22).toString();

                          //////
                          if (isNumeric(rows.values.elementAt(23).toString()) &&
                              (rows.values.elementAt(23).toString()) != "103" &&
                              (rows.values.elementAt(23).toString()) != "0") {
                            _controllerLith4Abund.text =
                                (int.parse(lith4Abund) - 2).toString();
                          } else {
                            _controllerLith4Abund.text = "";
                          }
                          _controllerLith4Spec.text =
                              rows.values.elementAt(24).toString();
                          _controllerLith4Mod.text =
                              rows.values.elementAt(25).toString();
                          _controllerLith4ColorMod.text =
                              rows.values.elementAt(26).toString();
                          _controllerLith4Color.text =
                              rows.values.elementAt(27).toString();

                          //////
                          if (isNumeric(rows.values.elementAt(28).toString()) &&
                              (rows.values.elementAt(28).toString()) != "103" &&
                              (rows.values.elementAt(28).toString()) != "0") {
                            _controllerLith5Abund.text =
                                (int.parse(lith5Abund) - 2).toString();
                          } else {
                            _controllerLith5Abund.text = "";
                          }
                          _controllerLith5Spec.text =
                              rows.values.elementAt(29).toString();
                          _controllerLith5Mod.text =
                              rows.values.elementAt(30).toString();
                          _controllerLith5ColorMod.text =
                              rows.values.elementAt(31).toString();
                          _controllerLith5Color.text =
                              rows.values.elementAt(32).toString();

                          _controllerLithCategory.text =
                              rows.values.elementAt(33).toString();
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
        .fnObtenerCamposActivas(widget.holeId, 'tb_sampqc');
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
        fnEliminarLithology(selectedRow);
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

  Future<void> fnEliminarLithology(int id) async {
    await new LithologyModel()
        .fnEliminarRegistro(nombreTabla: 'tb_lithology', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarLithology(widget.holeId);
      }
    });
    /*await new LoggedByModel()
        .fnEliminarRegistro('tb_lithology','Id',id)
        .then((value) => value);*/
    //setState(() {});
  }
}
