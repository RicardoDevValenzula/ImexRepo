import 'dart:developer';

import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/models/SamplesModel.dart';
import 'package:date_format/date_format.dart';
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

class SamplesTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  final String fechaFinal;
  final String fechaInicio;
  SamplesTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth,
        required this.fechaInicio,
        required this.fechaFinal})
      : super(key: key);

  @override
  SamplesTabState createState() => SamplesTabState(pageEvent: pageEvent);
}

class SamplesTabState extends State<SamplesTab> {
  final ValueChanged<bool> pageEvent;
  SamplesTabState({required this.pageEvent});

  final _db = new DBDataEntry();
  final sampleModel = new SamplesModel();
  TextEditingController _geolFrom = TextEditingController();
  TextEditingController _geolTo = TextEditingController();
  TextEditingController _controllerSampleId = TextEditingController();
  TextEditingController _controllerAquifer = TextEditingController();
  TextEditingController _controllerComments = TextEditingController();
  TextEditingController _controllerLab = TextEditingController();
  TextEditingController _controllerDispatchID = TextEditingController();
  TextEditingController _controllerDispatchDate = TextEditingController();
  TextEditingController _controllerDrillSampType = TextEditingController();
  TextEditingController _controllerSampleMass = TextEditingController();
  TextEditingController _controllerSampler = TextEditingController();
  TextEditingController _controllerSampleDate = TextEditingController();
  TextEditingController _controllerWaterSampType = TextEditingController();
  TextEditingController _controllerWaterContainer = TextEditingController();
  TextEditingController _controllerWaterWellType = TextEditingController();
  TextEditingController _controllerWaterSampEquip = TextEditingController();
  TextEditingController _controllerWaterVolume = TextEditingController();
  TextEditingController _controllerWaterColor = TextEditingController();
  TextEditingController _controllerWaterSmell = TextEditingController();
  TextEditingController _controllerConductivity = TextEditingController();
  TextEditingController _controllerTDSField = TextEditingController();
  TextEditingController _controllerTempField = TextEditingController();
  TextEditingController _controllerPhField = TextEditingController();
  TextEditingController _controllerEhField = TextEditingController();
  TextEditingController _controllerDensityField = TextEditingController();
  TextEditingController _controllerNaClField = TextEditingController();

  DateTime? _dateDispatchDate = DateTime.now();
  DateTime? _dateSampDate = DateTime.now();
  String _dateEndCollar = '';
  String _dateStartCollar = '';
  late List<Map<String, dynamic>> _itemsAquifer = [];
  late List<Map<String, dynamic>> _itemsLab = [];
  late List<Map<String, dynamic>> _itemsDrillSampType = [];
  late List<Map<String, dynamic>> _itemsSamplers = [];
  late List<Map<String, dynamic>> _itemsWaterSampType = [];
  late List<Map<String, dynamic>> _itemsWaterContainer = [];
  late List<Map<String, dynamic>> _itemsWaterWellType = [];
  late List<Map<String, dynamic>> _itemsWaterSampEquip = [];
  late List<Map<String, dynamic>> _itemsWaterVolume = [];
  late List<Map<String, dynamic>> _itemsWaterColor = [];
  late List<Map<String, dynamic>> _itemsWaterSmell = [];

  List<DataRow> _cells = [];
  String errors = "";
  //double _lastGeolFrom = 0.0;
  double _lastGeolTo = 0.0;
  String _lastIdSample = '';
  int selectedRow = 0;
  bool onUpdate = false;

  final List<Map<String, dynamic>> _items = [];
  String _initial_item_field = '';
  String _valueChanged = '';
  bool candado = false;

  bool geolFromDifference = false;
  bool geolToDifference = false;

  @override
  void initState() {
    super.initState();
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_aquifer', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsAquifer = rows;
      });
    });
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
            tbName: 'cat_drillsamptype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsDrillSampType = rows;
      });
    });
    _db
        .fnRegistrosValueGeolog(
            tbName: 'cat_geologist', holeid: widget.holeId)
        .then((rows) {
      setState(() {
        _itemsSamplers = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_watersamptype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterSampType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_watercontainer', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterContainer = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_waterwelltype', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterWellType = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_watersampequip', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterSampEquip = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_watervolume', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterVolume = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_watercolor', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterColor = rows;
      });
    });
    _db
        .fnRegistrosValueLabelIcon(
            tbName: 'cat_watersmell', orderByCampo: 'repetitions')
        .then((rows) {
      setState(() {
        _itemsWaterSmell = rows;
      });
    });
    _db.fnObtenerRegistro(nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId).then((rows){
      setState(() {
        String fechaInicio = rows.values.elementAt(7) ?? '';
        String fechaFinal = rows.values.elementAt(8) ?? '';

        if(rows.values.elementAt(7) != null || rows.values.elementAt(8)!=null){
          _dateStartCollar = fechaInicio;
          _dateEndCollar = fechaFinal;
        }
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
    fnLlenarSamples(widget.holeId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Samples Tab',
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
                                    double.parse(_geolFrom.text)) {
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
          labelInput('SampleId'),
          Container(
            child: Visibility(
              visible:  true ,
                child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerSampleId,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 14.0, right: 14.0, top: 14.0, bottom: 14.0),
                      prefixIcon: Icon(Icons.label_important),
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "SampleId",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any((element ) => element.values.contains('Aquifer'))) ? sFM(_controllerAquifer, _itemsAquifer, 'Aquifer') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Visibility(
                visible: ( _items.any((element ) => element.values.contains('Samp_Comments'))) ? true : false,
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
              )
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any((element ) => element.values.contains('Lab'))) ?  sFM(_controllerLab, _itemsLab, 'Lab') : labelInput('') ,
          SizedBox(
            height: 10,
          ),
           labelInput('Dispatch ID'),
          Container(
            child: Visibility(
              visible: true,
              child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerDispatchID,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 14.0, right: 14.0, top: 14.0, bottom: 14.0),
                      prefixIcon: Icon(Icons.label_important),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Dispatch ID",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          labelInput('Dispatch Date'),
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
                controller: _controllerDispatchDate,
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
                  hintText: 'Dispatch Date',
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
                    _dateDispatchDate = date;


                    pageEvent(true);
                  });
                },
              ),
            )
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element ) => element.values.contains('Drill_SampleType') ) ) ?  sFM(_controllerDrillSampType, _itemsDrillSampType, 'DrillSampType') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element ) => element.values.contains('Sample_Mass') ) ) ? labelInput('Sample_Mass') : labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element ) => element.values.contains('Sample_Mass') ) ) ? true : false,
              child : SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerSampleMass,
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
                      hintText: "Sample_Mass",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element ) => element.values.contains('Sampler') ) ) ? sFM(_controllerSampler, _itemsSamplers, 'Sampler') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          labelInput('Samp_Date'),
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
              child : DateTimeField(
                controller: _controllerSampleDate,
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
                  hintText: 'Samp_Date',
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
                    _dateSampDate = date;


                    pageEvent(true);

                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterSampType'))) ? sFM(_controllerWaterSampType, _itemsWaterSampType, 'WaterSampType') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterContainer'))) ? sFM(_controllerWaterContainer, _itemsWaterContainer, 'WaterContainer') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterWellType'))) ? sFM(_controllerWaterWellType, _itemsWaterWellType, 'WaterWellType') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterSampEquip'))) ? sFM(_controllerWaterSampEquip, _itemsWaterSampEquip, 'WaterSampEquip') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterVolume'))) ? sFM(_controllerWaterVolume, _itemsWaterVolume, 'WaterVolume') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterColor'))) ? sFM(_controllerWaterColor, _itemsWaterColor, 'WaterColor') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('WaterSmell'))) ? sFM(_controllerWaterSmell, _itemsWaterSmell, 'WaterSmell') : labelInput(''),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('ConductivityField'))) ? labelInput('Conductivity') : labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('ConductivityField'))) ? true : false,
             child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerConductivity,
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
                      hintText: "Conductivity",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('TDS_Field'))) ? labelInput('TDS_Field') : labelInput('') ,
          Container(
            child: Visibility(
              visible: (_items.any( (element) => element.values.contains('TDS_Field'))) ? true : false,
                child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerTDSField,
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
                      hintText: "TDS_Field",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Temp_Field'))) ? labelInput('Temp_Field') : labelInput('') ,
          Container(
            child: Visibility(
              visible: (_items.any( (element) => element.values.contains('Temp_Field'))) ? true : false,
              child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerTempField,
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
                      hintText: "Temp_Field",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),

          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('pH_Field'))) ? labelInput('pH_Field') : labelInput(''),
          Container(
            child:Visibility(
              visible: ( _items.any( (element) => element.values.contains('pH_Field'))) ? true : false,
              child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerPhField,
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
                      hintText: "pH_Field",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Eh_Field'))) ? labelInput('Eh_Field') : labelInput(''),
          Container(
            child: Visibility(
              visible : ( _items.any( (element) => element.values.contains('Eh_Field'))) ? true : false,
              child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerEhField,
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
                      hintText: "Eh_Field",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('Density_Field'))) ? labelInput('Density_Field') : labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('Density_Field'))) ? true : false,
              child: SizedBox(
                height: 50,
                child: TextField(
                    controller: _controllerDensityField,
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
                      hintText: "Density_Field",
                      fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 2.1),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                    ),
                    onChanged: (text) {}),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ( _items.any( (element) => element.values.contains('NaCl_Field'))) ? labelInput('NaCl_Field') : labelInput(''),
          Container(
            child: Visibility(
              visible: ( _items.any( (element) => element.values.contains('NaCl_Field'))) ? true : false,
              child:
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _controllerNaClField,
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
                    hintText: "NaCl_Field",
                    fillColor: (geolToDifference) ? Colors.red : Colors.white70,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3), width: 2.1),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    ),
                  ),
                  onChanged: (text) {}),
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
                    onPressed:candado ? null: () async {
                      await insertSamples();
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
                        await actualizarSamples();
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
              minWidth: 4000,
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
                    'SampleId',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Aquifer',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'SampComments',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Lab',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'DispatchID',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'DispatchDate',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'DrillSampType',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'SampMass',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Sampler',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'SampDate',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterSampType',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterContainer',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterWellType',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterSampEquip',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterVolume',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterColor',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'WaterSmell',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Conductivity_Field',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'TDS_Field',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Temp_Field',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'pH_Field',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Eh_Field',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'Density_Field',
                    textAlign: TextAlign.center,
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'NaCl_Field',
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

  Future<void> insertSamples() async {
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
      'GeolFrom': _geolFrom.text,
      'GeolTo': _geolTo.text,
      'Chk': 0,
      'idSample': _controllerSampleId.text.toString(),
      'Aquifer': _controllerAquifer.text,
      'Samp_Comments': _controllerComments.text.toString(),
      'Lab': _controllerLab.text,
      'DisparchID': _controllerDispatchID.text,
      'DispatchDate': _dateDispatchDate.toString(),
      'Drill_SampleType': _controllerDrillSampType.text,
      'Sample_Mass': _controllerSampleMass.text,
      'Sampler': _controllerSampler.text,
      'Samp_Date': _dateSampDate.toString(),
      'WaterSampType': _controllerWaterSampType.text,
      'WaterContainer': _controllerWaterContainer.text,
      'WaterWellType': _controllerWaterWellType.text,
      'WaterSampEquip': _controllerWaterSampEquip.text,
      'WaterVolume': _controllerWaterVolume.text,
      'WaterColor': _controllerWaterColor.text,
      'WaterSmell': _controllerWaterSmell.text,
      'Conductivity_Field': _controllerConductivity.text,
      'TDS_Field': _controllerTDSField.text,
      'Temp_Field': _controllerTempField.text,
      'pH_Field': _controllerPhField.text,
      'Eh_Field': _controllerEhField.text,
      'Density_Field': _controllerDensityField.text,
      'NaCl_Field': _controllerNaClField.text,
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
      registerSamples(valores);
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
              await registerSamples(valores);
            },
            onCancelBtnTap: () => Navigator.pop(context));
      }
    }
  }

  Future<void> registerSamples(valores) async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    int response = await _db.fnInsertarRegistro('tb_sample', valores);
    if (response > 0) {
      Loader.hide();
      await fnLlenarSamples(widget.holeId);
      _geolTo.clear();
      //_controllerSampleId.text = getNextSample(_controllerSampleId.text);
      _controllerComments.clear();
      _controllerSampleMass.clear();
      _controllerConductivity.clear();
      _controllerTDSField.clear();

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

  Future<void> actualizarSamples() async {
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    Map<String, dynamic> valores = {
      'IdCollar': widget.holeId,
      'GeolFrom': _geolFrom.text,
      'GeolTo': _geolTo.text,
      'Chk': 0,
      'idSample': _controllerSampleId.text.toString(),
      'Aquifer': _controllerAquifer.text,
      'Samp_Comments': _controllerComments.text.toString(),
      'Lab': _controllerLab.text,
      'DisparchID': _controllerDispatchID.text,
      'DispatchDate': _dateDispatchDate.toString(),
      'Drill_SampleType': _controllerDrillSampType.text,
      'Sample_Mass': _controllerSampleMass.text,
      'Sampler': _controllerSampler.text,
      'Samp_Date': _dateSampDate.toString(),
      'WaterSampType': _controllerWaterSampType.text,
      'WaterContainer': _controllerWaterContainer.text,
      'WaterWellType': _controllerWaterWellType.text,
      'WaterSampEquip': _controllerWaterSampEquip.text,
      'WaterVolume': _controllerWaterVolume.text,
      'WaterColor': _controllerWaterColor.text,
      'WaterSmell': _controllerWaterSmell.text,
      'Conductivity_Field': _controllerConductivity.text,
      'TDS_Field': _controllerTDSField.text,
      'Temp_Field': _controllerTempField.text,
      'pH_Field': _controllerPhField.text,
      'Eh_Field': _controllerEhField.text,
      'Density_Field': _controllerDensityField.text,
      'NaCl_Field': _controllerNaClField.text,
      'status': 1
    };
    int response =
        await _db.fnActualizarRegistro('tb_sample', valores, 'Id', selectedRow);
    if (response > 0) {
      Loader.hide();
      await fnLlenarSamples(widget.holeId);
      selectedRow = 0;
      onUpdate = false;
      _geolTo.clear();
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

  Future<dynamic> validateRequired(Map<String, Object?> valores) async {
    errors = '';
    bool existe = await sampleModel.existeSample(valores['sampleId'].toString(), widget.holeId);

    if (existe){
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect Data', 'Sample ID is duplicate.');
      return false;
    }

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

      if(valores['Samp_Date'] != ''){
        DateTime dtStart = DateTime.parse(widget.fechaInicio);
        DateTime? dtEnd;
        if(widget.fechaFinal == ''){
          dtEnd = DateTime.now();
        }else{
          dtEnd = DateTime.parse(widget.fechaFinal);
        }
        DateTime dtLogged = DateTime.parse(valores['Samp_Date'].toString());

        if(dtLogged.isBefore(dtStart)){
          Loader.hide();
          message(CoolAlertType.error, 'Incorrect data',
              'The date is before the Date of the collar');
          return false;
        }
        if(dtLogged.isAfter(dtEnd)){
          Loader.hide();
          message(CoolAlertType.error, 'Incorrect data',
              'The date is After the Date of the collar');
          return false;
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

  Future<void> fnLlenarSamples(int collarId) async {
    double _geolTo = 0;
    _cells.clear();
    int currentRow = 0;
    List<SamplesModel> listSamplesModel = await new SamplesModel()
        .fnObtenerRegistrosPorCollarId(
            collarId: collarId, orderByCampo: 'GeolFrom')
        .then((value) => value);
    log('${listSamplesModel}');
    listSamplesModel.forEach((model) {
      Color cell_color = Colors.black;
      currentRow ++;
      if (double.parse(model.geolFrom.toStringAsFixed(3)) > _lastGeolTo || double.parse(model.geolFrom.toStringAsFixed(3)) < _lastGeolTo) {
        if(currentRow==1 && double.parse(model.geolFrom.toStringAsFixed(3)) == 0){cell_color = Colors.black;}else{cell_color = Colors.red;}
      }
      //log(model.dispatchDate);
      String fechaDispatch = '';

      if(model.dispatchDate=='null'){
        //log('hola');
        fechaDispatch = '0000-00-00';
      }else{
        fechaDispatch = formatDate(DateTime.parse(model.dispatchDate), [mm, '/', dd, '/', yyyy]);

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
              Text('${model.idSample}'),
            ),
            DataCell(
              Text('${model.aquiferName}'),
            ),
            DataCell(
              Text('${model.comments}'),
            ),
            DataCell(
              Text('${model.lab}'),
            ),
            DataCell(
              Text('${model.disparchID}'),
            ),
            DataCell(
              Text( fechaDispatch),
              /*Text(formatDate(DateTime.parse(model.dispatchDate),
                  [mm, '/', dd, '/', yyyy])),*/
            ),
            DataCell(
              Text('${model.drillSampleTypeName}'),
            ),
            DataCell(
              Text('${model.sampleMass}'),
            ),
            DataCell(
              Text('${model.samplerName}'),
            ),
            DataCell(
              Text(formatDate(
                  DateTime.parse(model.sampDate), [mm, '/', dd, '/', yyyy])),
              /*Text(formatDate(
                  DateTime.parse(model.sampDate), [mm, '/', dd, '/', yyyy])),*/
            ),
            DataCell(
              Text('${model.waterSampTypeName}'),
            ),
            DataCell(
              Text('${model.waterContainerName}'),
            ),
            DataCell(
              Text('${model.waterWellTypeName}'),
            ),
            DataCell(
              Text('${model.waterSampEquipName}'),
            ),
            DataCell(
              Text('${model.waterVolumeName}'),
            ),
            DataCell(
              Text('${model.waterColorName}'),
            ),
            DataCell(
              Text('${model.waterSmellName}'),
            ),
            DataCell(
              Text('${model.conductivityField}'),
            ),
            DataCell(
              Text('${model.tdsField}'),
            ),
            DataCell(
              Text('${model.tempField}'),
            ),
            DataCell(
              Text('${model.phField}'),
            ),
            DataCell(
              Text('${model.ehField}'),
            ),
            DataCell(
              Text('${model.densityField}'),
            ),
            DataCell(
              Text('${model.naclField}'),
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
      _lastIdSample = model.idSample;
    });
    if (_geolTo != 0) {
      _geolFrom.text = _geolTo.toString();
    }
    if (_lastIdSample != '') {
      _controllerSampleId.text = getNextSample(_lastIdSample);
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
                              nombreTabla: 'tb_sample',
                              campo: 'Id',
                              valor: selectedRow)
                          .then((rows) {
                        setState(() {
                          _geolFrom.text = rows.values.elementAt(2).toString();
                          _geolTo.text = rows.values.elementAt(3).toString();

                          _controllerSampleId.text =
                              rows.values.elementAt(5).toString();
                          _controllerAquifer.text =
                              rows.values.elementAt(6).toString();
                          _controllerComments.text =
                              rows.values.elementAt(7).toString();
                          _controllerLab.text =
                              rows.values.elementAt(8).toString();
                          _controllerDispatchID.text =
                              rows.values.elementAt(9).toString();
                          if (rows.values.elementAt(10).toString() != '') {
                            _controllerDispatchDate.text =
                                DateFormat('MM/dd/yyyy').format(DateTime.parse(
                                    rows.values.elementAt(10).toString()));
                            _dateDispatchDate = DateTime.parse(
                                rows.values.elementAt(10).toString());
                          }
                          _controllerDrillSampType.text =
                              rows.values.elementAt(11).toString();
                          _controllerSampleMass.text =
                              rows.values.elementAt(12).toString();
                          _controllerSampler.text =
                              rows.values.elementAt(13).toString();
                          if (rows.values.elementAt(14).toString() != '') {
                            _controllerSampleDate.text =
                                DateFormat('MM/dd/yyyy').format(DateTime.parse(
                                    rows.values.elementAt(14).toString()));
                            _dateSampDate = DateTime.parse(
                                rows.values.elementAt(14).toString());
                          }
                          _controllerWaterSampType.text =
                              rows.values.elementAt(15).toString();
                          _controllerWaterContainer.text =
                              rows.values.elementAt(16).toString();
                          _controllerWaterWellType.text =
                              rows.values.elementAt(17).toString();
                          _controllerWaterSampEquip.text =
                              rows.values.elementAt(18).toString();
                          _controllerWaterVolume.text =
                              rows.values.elementAt(19).toString();
                          _controllerWaterColor.text =
                              rows.values.elementAt(20).toString();
                          _controllerWaterSmell.text =
                              rows.values.elementAt(21).toString();
                          _controllerConductivity.text =
                              rows.values.elementAt(22).toString();
                          _controllerTDSField.text =
                              rows.values.elementAt(23).toString();
                          _controllerTempField.text =
                              rows.values.elementAt(24).toString();
                          _controllerPhField.text =
                              rows.values.elementAt(25).toString();
                          _controllerEhField.text =
                              rows.values.elementAt(26).toString();
                          _controllerDensityField.text =
                              rows.values.elementAt(27).toString();
                          _controllerNaClField.text =
                              rows.values.elementAt(28).toString();
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
        fnEliminarSamples(selectedRow);
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

  Future<void> fnEliminarSamples(int id) async {
    await new SamplesModel()
        .fnEliminarRegistro(nombreTabla: 'tb_sample', campo: 'Id', valor: id)
        .then((value) {
      if (value == 1) {
        Navigator.pop(context);
        fnLlenarSamples(widget.holeId);
      }
    });
  }

  Future<bool> fnCargarTabs() async {
    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerCamposActivas(widget.holeId, 'tb_sample');
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

  String getNextSample(String sample) {
    int sampleid = int.parse(sample);
    sampleid++;

    return sampleid.toString();

    /*
    int len = sample.length;
    String allButLast = sample.substring(0, len - 1);

    return allButLast +
        String.fromCharCode(sample.codeUnitAt(sample.length - 1) + 1);
  */
  }

}
