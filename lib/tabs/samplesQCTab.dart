//import 'package:data_entry_app/tabs/samplesTab.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/models/SampleQCModel.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_table_2/data_table_2.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:select_form_field/select_form_field.dart';

class SamplesQCTab extends StatefulWidget {
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  SamplesQCTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth})
      : super(key: key);

  @override
  SamplesQCTabState createState() => SamplesQCTabState(pageEvent: pageEvent);
}

class SamplesQCTabState extends State<SamplesQCTab> {
  final ValueChanged<bool> pageEvent;
  SamplesQCTabState({required this.pageEvent});

  //Variables
  final _db = new DBDataEntry();
  final samplesModel = new SamplesQCModel();
  bool band = false;
  TextEditingController _controllerComments = TextEditingController();
  TextEditingController _controllerCheckId = TextEditingController();
  TextEditingController _controllerSampleId = TextEditingController();
  TextEditingController _controllerQCType = TextEditingController();
  TextEditingController _controllerStandardId = TextEditingController();
  TextEditingController _controllerLab = TextEditingController();
  bool isDuplicate = false;
  bool candado = false;

  //Arreglos para llenar con datos extraidos de la base de datos.
  late List<Map<String, dynamic>> _itemsLab = [];
  late List<Map<String, dynamic>> _itemsQCType = [];
  late List<Map<String, dynamic>> _itemsStandardId = [];
  String errors = "";

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';

  List<DataRow> _cells = [];
  bool onUpdate = false;
  bool ocultaStandard = false;
  bool ocultaSample = false;
  int selectedRow = 0;

  @override
  void initState() {
    super.initState();

    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_lab', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsLab = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_qctype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsQCType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon3(
            tbName: 'cat_standarid', holeid: widget.holeId)
        .then((rows) {
      setState(() {
        _itemsStandardId = rows;
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
    fnLlenarSamplesQC(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Text(
          'Samples QC Tab',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Divider(),
        SizedBox(
          height: 20,
        ),
        (_items.any((element) => element.values.contains('QCTYPE')))
            ? sFM(_controllerQCType, _itemsQCType, 'QCTYPE')
            : labelInput(''),
        SizedBox(
          height: 20,
        ),
        labelInput('CHECK ID'),
        Container(
          child: SizedBox(
            height: 50,
            child: TextField(
                controller: _controllerCheckId,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: 14.0, right: 14.0, top: 14.0, bottom: 14.0),
                  prefixIcon: Icon(Icons.label_important),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "CHECKID",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.3), width: 2.1),
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                ),
                onChanged: (text) {}),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        if (ocultaSample) labelInput('SAMPLE ID'),
        Visibility(
          visible: (ocultaSample),
          child: SizedBox(
            height: 50,
            child: TextField(
                controller: _controllerSampleId,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 14,
                      right: 14,
                      top: 14,
                      bottom: 14,
                    ),
                    prefixIcon: Icon(Icons.label_important),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: 'SAMPLEID',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius:
                            BorderRadius.all(Radius.circular(100.0)))),
                onChanged: (text) {}),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //labelInput('Standard ID'),
        if (ocultaStandard)
          sFM(_controllerStandardId, _itemsStandardId, 'Standard ID'),
        SizedBox(
          height: 10,
        ),
        (_items.any((element) => element.values.contains('Lab')))
            ? sFM(_controllerLab, _itemsLab, 'Lab')
            : labelInput(''),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Visibility(
            visible:
                (_items.any((element) => element.values.contains('Comments')))
                    ? true
                    : false,
            child: BsInput(
              maxLines: null,
              minLines: 4,
              keyboardType: TextInputType.multiline,
              style: BsInputStyle.outline,
              size: BsInputSize.md,
              hintText: 'Comments',
              controller: _controllerComments,
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
                          await insertSamplesQC();
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
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 18))),
                  )),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Expanded(
                      child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.check,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      await actualizarSamplesQC();
                    },
                    label: Text("Update"),
                    style: ButtonStyle(),
                  ))
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
              //minWidth: 4000,
              columns: [
                DataColumn2(
                  label: Text('CheckId', textAlign: TextAlign.center),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(
                    'SampleId',
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(
                    'QCType',
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(
                    'StandardId',
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(
                    'Lab',
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text(
                    'Comments',
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.L,
                ),
              ],
              rows: _cells,
            ))
      ],
    ));
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
              )
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
                  borderRadius: BorderRadius.all(Radius.circular(100)),
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
                )),
            type: SelectFormFieldType.dialog,
            controller: sfm_controller,
            icon: Icon(Icons.filter_list),
            changeIcon: true,
            dialogTitle: 'Choose a ${sfm_label}',
            dialogCancelBtn: 'CANCEL',
            enableSearch: true,
            dialogSearchHint: 'Search Option',
            items: sfm_items,
            onChanged: (val) async {
              setState(() {
                pageEvent(true);
              });
              _db
                  .fnObtenerRegistro(
                      nombreTabla: 'cat_qctype', campo: 'Id', valor: val)
                  .then((value) {
                if (value.values.elementAt(1).toString() == 'Standard') {
                  ocultaStandard = true;
                } else {
                  ocultaStandard = false;
                }
                if (value.values
                        .elementAt(1)
                        .toString()
                        .contains('Duplicate') ||
                    value.values
                        .elementAt(1)
                        .toString()
                        .contains('duplicate') ||
                    value.values.elementAt(1).toString() == 'Duplicate') {
                  ocultaSample = true;
                } else {
                  ocultaSample = false;
                }
              });
            },
          )
        ],
      ),
    );
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

  bool isNumeric(String string) {
    // Null or empty string is not a number
    if (string.isEmpty) {
      return false;
    }
    final number = double.tryParse(string);

    if (number == null) {
      return false;
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

  Future<dynamic> validateRequired(Map<String, Object?> valores) async {
    print(valores);
    errors = '';
    bool existeQC = await samplesModel.existeSampleQC(
        valores['CheckId'].toString(), widget.holeId);
    bool existeSample = await samplesModel.existeSample(
        valores['CheckId'].toString(), widget.holeId);

    if (existeQC || existeSample) {
      Loader.hide();
      message(
          CoolAlertType.error, 'Incorrect data', 'The SampleId is duplicate');
      return false;
    }

    if (valores['QCType'].toString() == '' ||
        valores['CheckId'].toString() == '') {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data', 'Please enter the QCType');
      return false;
    }
    if (errors != '') {
      return false;
    } else {
      return true;
    }
  }

  void _getSelectedRowInfo(model) {
    selectedRow = model.id;
    setState(() {
      _settingModelBottomSheet(context);
    });
  }

  void _settingModelBottomSheet(context) {
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
                    title: new Text('Edit Record'),
                    onTap: () async {
                      await _db
                          .fnObtenerRegistro(
                              nombreTabla: 'tb_sampqc',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        if (rows.values.elementAt(4).toString() == 'Standard') {
                          ocultaStandard = true;
                        } else {
                          ocultaStandard = false;
                        }
                        if (rows.values
                                .elementAt(4)
                                .toString()
                                .contains('Duplicate') ||
                            rows.values
                                .elementAt(4)
                                .toString()
                                .contains('duplicate')) {
                          ocultaSample = true;
                        } else {
                          ocultaSample = false;
                        }
                        setState(() {
                          _controllerCheckId.text =
                              rows.values.elementAt(2).toString();
                          _controllerSampleId.text =
                              rows.values.elementAt(3).toString();
                          _controllerQCType.text =
                              rows.values.elementAt(4).toString();
                          _controllerStandardId.text =
                              rows.values.elementAt(5).toString();
                          _controllerLab.text =
                              rows.values.elementAt(6).toString();
                          _controllerComments.text =
                              rows.values.elementAt(7).toString();
                        });
                      }).onError((error, stackTrace) {});
                      Navigator.pop(context);
                      onUpdate = true;
                      setState(() {});
                    }),
                new ListTile(
                  leading: new Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  title: new Text('Delete'),
                  onTap: () => {showAlertDialog(context)},
                )
              ],
            ),
          );
        });
  }

  showAlertDialog(BuildContext Context) async {
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
        fnEliminarSamplesQC(selectedRow);
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

  Future<void> fnEliminarSamplesQC(int id) async {
    await new SamplesQCModel()
        .fnEliminarRegistro(nombreTabla: 'tb_sampqc', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarSamplesQC(widget.holeId);
      }
    });
  }

  Future<void> fnLlenarSamplesQC(int collarId) async {
    _cells.clear();
    List<SamplesQCModel> listSamplesQCModel = await new SamplesQCModel()
        .fnObtenerRegistrosPorCollarId(collarId: collarId)
        .then((value) => value);
    listSamplesQCModel.forEach((model) {
      Color cell_color = Colors.black;
      _cells.add(DataRow(
          cells: [
            DataCell(
              Text(
                '${model.CheckId}',
                style: TextStyle(color: cell_color),
              ),
            ),
            DataCell(
              Text('${model.SampleID}'),
            ),
            DataCell(Text('${model.QCType}')),
            DataCell(Text('${model.StandardID.toString()}')),
            DataCell(Text('${model.Lab}')),
            DataCell(Text('${model.QCComment}'))
          ],
          onSelectChanged: candado
              ? null
              : (newValue) {
                  _getSelectedRowInfo(model);
                }));
    });
    setState(() {});
  }

  Future<void> registerSamplesQC(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    int response = await _db.fnInsertarRegistro('tb_sampqc', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarSamplesQC(widget.holeId);
      _controllerQCType.clear();
      _controllerCheckId.clear();
      _controllerSampleId.clear();
      _controllerStandardId.clear();
      _controllerLab.clear();
      _controllerComments.clear();

      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Samples data has been saved successfully',
      );
    }
  }

  Future<void> insertSamplesQC() async {
    FocusScope.of(context).unfocus();
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    String duplicate = '';
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'CheckId': _controllerCheckId.text,
      'SampleId': _controllerSampleId.text,
      'QCType': _controllerQCType.text,
      'StandardId': _controllerStandardId.text,
      'Lab': _controllerLab.text,
      'QCComment': _controllerComments.text.toString(),
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
      registrarSamplesQC(valores);
    } else {
      if (errors != '') {
        Loader.hide();
        CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            backgroundColor: DataEntryTheme.deGrayMedium,
            confirmBtnColor: DataEntryTheme.deGrayDark,
            showCancelBtn: true,
            confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
            cancelBtnText: 'Cancel',
            cancelBtnTextStyle: TextStyle(color: DataEntryTheme.deBlack),
            title: 'Confirmation',
            text: 'The Following errors have benn detected \n\n' +
                errors +
                '\n\nDo you want to proceed to record the data?',
            onConfirmBtnTap: () async {
              Navigator.pop(context);
              await registrarSamplesQC(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> actualizarSamplesQC() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'CheckId': _controllerCheckId.text,
      'SampleId': _controllerSampleId.text,
      'QCType': _controllerQCType.text,
      'StandardId': _controllerStandardId.text,
      'Lab': _controllerLab.text,
      'QCComment': _controllerComments.text.toString()
    };
    int response =
        await _db.fnActualizarRegistro('tb_sampqc', valores, 'Id', selectedRow);
    print(selectedRow);
    print("Este es el reponse del actualizar $response");
    if (response > 0) {
      Loader.hide();
      await fnLlenarSamplesQC(widget.holeId);
      selectedRow = 0;
      onUpdate = false;
      _controllerQCType.clear();
      _controllerCheckId.clear();
      _controllerSampleId.clear();
      _controllerStandardId.clear();
      _controllerLab.clear();
      _controllerComments.clear();
      setState(() {});
      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.success,
        title: "Success!",
        text: 'Samples data has been updated successfully',
      );
    }
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

  Future<void> registrarSamplesQC(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    int response = await _db.fnInsertarRegistro('tb_sampqc', valores);
    //print("Este es el reponse del insert $response");
    if (response > 0) {
      Loader.hide();
      await fnLlenarSamplesQC(widget.holeId);
      _controllerComments.clear();
      _controllerLab.clear();
      _controllerSampleId.clear();
      _controllerCheckId.clear();
      _controllerStandardId.clear();
      CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deBrownLight),
          type: CoolAlertType.success,
          title: "Success!",
          text: 'Samples data has been saved Successfully');
    }
  }
}
