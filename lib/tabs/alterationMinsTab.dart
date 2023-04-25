import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/AlterationMinsModel.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:data_table_2/data_table_2.dart';

class AlterationMinsTab extends StatefulWidget {
  //late bool chkUpdate;
  final int holeId;
  final double totalDepth;
  final ValueChanged<bool> pageEvent;
  AlterationMinsTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  AlterationMinsTabState createState() =>
      AlterationMinsTabState(pageEvent: pageEvent);
}

class AlterationMinsTabState extends State<AlterationMinsTab> {
  final ValueChanged<bool> pageEvent;
  AlterationMinsTabState({required this.pageEvent});

  final _db = new DBDataEntry();

  TextEditingController _controllerGeolFrom = TextEditingController();
  TextEditingController _controllerGeolTo = TextEditingController();

  TextEditingController? _controllerAltMin;

  TextEditingController _controllerAltMineral1 = TextEditingController();
  TextEditingController _controllerAltMineral1_Intensity =
      TextEditingController();

  TextEditingController _controllerAltMineral2 = TextEditingController();
  TextEditingController _controllerAltMineral2_Intensity =
      TextEditingController();

  TextEditingController _controllerAltMineral3 = TextEditingController();
  TextEditingController _controllerAltMineral3_Intensity =
      TextEditingController();

  late List<Map<String, dynamic>> _itemsAltMineral = [];
  late List<Map<String, dynamic>> _itemsAltMineralIntensity = [];
  bool candado = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  double _lastGeolTo = 0.0;

  String _selectedAlterationMin = '0';

  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

  String errors = "";

  List<DataRow> _cells = [];

  final List<Map<String, dynamic>> _items_alterationMins = [
    /*
    {
      'value': '1',
      'label': 'AltMineral 1',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '2',
      'label': 'AltMineral 2',
      'icon': Icon(Icons.filter_list_rounded),
    },
    {
      'value': '3',
      'label': 'AltMineral 3',
      'icon': Icon(Icons.filter_list_rounded),
    }
     */
  ];

  @override
  void initState() {
    super.initState();
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_altmineral').then((rows) {
      setState(() {
        _itemsAltMineral = rows;
      });
    });
    _db.fnRegistrosValueLabelIcon(tbName: 'cat_altmin_intensity').then((rows) {
      setState(() {
        _itemsAltMineralIntensity = rows;
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
    fnLlenarAlterationMins(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Alteration Mins Tab',
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
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
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
            child: Visibility(
              visible: true,
              child: Column(
                children: <Widget>[
                  SelectFormField(
                    type: SelectFormFieldType.dialog,
                    controller: _controllerAltMin,
                    initialValue: '1',
                    icon: Icon(Icons.filter_list_rounded),
                    labelText: 'Choose a alteration mineral',
                    changeIcon: true,
                    dialogTitle: 'Pick a alteration mineral to add',
                    dialogCancelBtn: 'CANCEL',
                    enableSearch: true,
                    dialogSearchHint: '',
                    items: _items_alterationMins,
                    key: _key,
                    onChanged: (val) => {
                      setState(() {
                        print(_controllerAltMin);
                        _selectedAlterationMin = val;
                      }),
                    },
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltMineral1, _itemsAltMineral, 'AltMineral1'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltMineral1_Intensity, _itemsAltMineralIntensity,
                    'AltMineral1_Intensity'),
              ],
            ),
            visible: (_selectedAlterationMin == '1') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltMineral2, _itemsAltMineral, 'AltMineral2'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltMineral2_Intensity, _itemsAltMineralIntensity,
                    'AltMineral2_Intensity'),
              ],
            ),
            visible: (_selectedAlterationMin == '2') ? true : false,
          ),
          Visibility(
            maintainState: true,
            child: Column(
              children: [
                sFM(_controllerAltMineral3, _itemsAltMineral, 'AltMineral3'),
                SizedBox(
                  height: 20,
                ),
                sFM(_controllerAltMineral3_Intensity, _itemsAltMineralIntensity,
                    'AltMineral3_Intensity'),
              ],
            ),
            visible: (_selectedAlterationMin == '3') ? true : false,
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
                        await actualizarAlterationMins();
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
                minWidth: 1500,
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
                    label: Text('AltMineral1'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltMinera1_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltMineral2'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltMinera2_Intensity'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltMineral3'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('AltMinera3_Intensity'),
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
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _controllerGeolFrom.text,
      'GeolTo': _controllerGeolTo.text,
      'AltMineral1': _controllerAltMineral1.text.toString(),
      'AltMin1_Intensity': _controllerAltMineral1_Intensity.text.toString(),
      'AltMineral2': _controllerAltMineral2.text.toString(),
      'AltMin2_Intensity': _controllerAltMineral2_Intensity.text.toString(),
      'AltMineral3': _controllerAltMineral3.text.toString(),
      'AltMin3_Intensity': _controllerAltMineral3_Intensity.text.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
      await _db.fnInsertarRegistro('tb_alterationmins', valores);
      Loader.hide();
      await fnLlenarAlterationMins(widget.holeId);

      _controllerGeolTo.clear();
      _controllerAltMineral1.clear();
      _controllerAltMineral1_Intensity.clear();
      _controllerAltMineral2.clear();
      _controllerAltMineral2_Intensity.clear();
      _controllerAltMineral3.clear();
      _controllerAltMineral3_Intensity.clear();
      _selectedAlterationMin = '1';
      _key.currentState?.reset();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: "The 'AlterationMins' data was saved correctly.",
      );
    }
  }

  Future<void> actualizarAlterationMins() async {
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
      'AltMineral1': _controllerAltMineral1.text.toString(),
      'AltMin1_Intensity': _controllerAltMineral1_Intensity.text.toString(),
      'AltMineral2': _controllerAltMineral2.text.toString(),
      'AltMin2_Intensity': _controllerAltMineral2_Intensity.text.toString(),
      'AltMineral3': _controllerAltMineral3.text.toString(),
      'AltMin3_Intensity': _controllerAltMineral3_Intensity.text.toString(),
      'status': 1
    };
    if (await validateRequired(valores)) {
      int response = await _db.fnActualizarRegistro(
          'tb_alterationmins', valores, 'Id', selectedRow);
      if (response > 0) {
        await fnLlenarAlterationMins(widget.holeId);
        selectedRow = 0;
        onUpdate = false;
        _controllerGeolTo.clear();
        setState(() {});
        Loader.hide();
        CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
          type: CoolAlertType.success,
          title: "Success!",
          text: 'AlterationMins data has been updated successfully',
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
    if (string.isEmpty) {
      return false;
    }
    final number = double.tryParse(string);
    if (number == null) {
      return false;
    }
    return true;
  }

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
        await getOptionString(
            'cat_altmineral', 'id', int.tryParse(_controllerAltMineral1.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_altmin_intensity', 'id',
            int.tryParse(_controllerAltMineral1_Intensity.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_altmineral', 'id', int.tryParse(_controllerAltMineral2.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_altmin_intensity', 'id',
            int.tryParse(_controllerAltMineral2_Intensity.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString(
            'cat_altmineral', 'id', int.tryParse(_controllerAltMineral3.text)),
        textAlign: TextAlign.center,
      )),
      DataCell(Text(
        await getOptionString('cat_altmin_intensity', 'id',
            int.tryParse(_controllerAltMineral3_Intensity.text)),
        textAlign: TextAlign.center,
      )),
    ]));

    _controllerGeolFrom.text = _controllerGeolTo.text;
    _controllerGeolTo.clear();
    _controllerAltMineral1.clear();
    _controllerAltMineral1_Intensity.clear();
    _controllerAltMineral2.clear();
    _controllerAltMineral2_Intensity.clear();
    _controllerAltMineral3.clear();
    _controllerAltMineral3_Intensity.clear();
    _selectedAlterationMin = '1';
    _key.currentState?.reset();
  }

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

  Future<void> fnLlenarAlterationMins(int collarId) async {
    _cells.clear();
    double _geolTo = 0;
    int currentRow = 0;
    List<AlterationMinsModel> listLithologyModel =
        await new AlterationMinsModel()
            .fnObtenerRegistrosPorCollarId(collarId: collarId)
            .then((value) => value);
    listLithologyModel.forEach(
      (model) {
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
              DataCell(Text('${model.geolFrom}',
                  style: TextStyle(color: cell_color))),
              DataCell(Text('${model.geolTo}')),
              DataCell(Text('${model.altMineral1Name}')),
              DataCell(Text('${model.altMin1IntensityName}')),
              DataCell(Text('${model.altMineral2Name}')),
              DataCell(Text('${model.altMin2IntensityName}')),
              DataCell(Text('${model.altMineral3Name}')),
              DataCell(Text('${model.altMin3IntensityName}')),
            ],
            onSelectChanged: (newValue) {
              _getSelectedRowInfo(model);
            },
          ),
        );
        _lastGeolTo = double.parse(model.geolTo.toString());
        _geolTo = model.geolTo;
        if (_geolTo != 0) {
          _controllerGeolFrom.text = _geolTo.toString();
        }
      },
    );

    setState(() {});
  }

  int selectedRow = 0;

  void _getSelectedRowInfo(model) {
    selectedRow = model.id;
    setState(() {});
    if (!candado) {
      _settingModalBottomSheet(context);
    }
  }

  bool onUpdate = false;

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
                              nombreTabla: 'tb_alterationmins',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          print(rows);
                          _controllerGeolFrom.text =
                              rows.values.elementAt(2).toString();
                          _controllerGeolTo.text =
                              rows.values.elementAt(3).toString();

                          _controllerAltMin?.text = '1';

                          _controllerAltMineral1.text =
                              rows.values.elementAt(5).toString();
                          _controllerAltMineral1_Intensity.text =
                              rows.values.elementAt(6).toString();

                          _controllerAltMineral2.text =
                              rows.values.elementAt(7).toString();
                          _controllerAltMineral2_Intensity.text =
                              rows.values.elementAt(8).toString();

                          _controllerAltMineral3.text =
                              rows.values.elementAt(9).toString();
                          _controllerAltMineral3_Intensity.text =
                              rows.values.elementAt(10).toString();
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
        fnEliminarAlterationMins(selectedRow);
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
        .fnObtenerCamposActivas(widget.holeId, 'tb_alterationmins');
    if (tb.length > 0) {
      for (RelProfileTabsFieldsModal item in tb) {
        String nombre = item.fieldName;
        String capNombre = nombre.toUpperCase();
        if (nombre.contains('AltMineral')) {
          if (nombre == 'AltMineral1') {
            contador = 1;
            _items_alterationMins.add({
              'value': contador,
              'label': nombre,
              'icon': Icon(Icons.filter_list_rounded),
            });
          }
          if (nombre == 'AltMineral2') {
            contador = 2;
            _items_alterationMins.add({
              'value': contador,
              'label': nombre,
              'icon': Icon(Icons.filter_list_rounded),
            });
          }
          if (nombre == 'AltMineral3') {
            contador = 3;
            _items_alterationMins.add({
              'value': contador,
              'label': nombre,
              'icon': Icon(Icons.filter_list_rounded),
            });
          }
        }
      }
      setState(() {
        _initial_item_field = tb.first.fieldName;
        _valueChanged = _initial_item_field;
      });
    }
    return true;
  }

  Future<void> fnEliminarAlterationMins(int id) async {
    await new AlterationMinsModel()
        .fnEliminarRegistro(campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarAlterationMins(widget.holeId);
      }
    });
  }
}
