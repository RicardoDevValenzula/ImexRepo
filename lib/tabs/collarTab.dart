import 'dart:developer';

import 'package:data_entry_app/models/CollarModel.dart';
import 'package:intl/intl.dart';

import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:flutter/material.dart';
import 'package:bs_flutter_inputtext/bs_flutter_inputtext.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';

class CollarTab extends StatefulWidget {
  //late bool chkUpdate;
  final ValueChanged<bool> pageEvent;
  final int holeId;
  final double totalDepth;
  final String fechaFinal;
  final String fechaInicio;
  CollarTab(
      {Key? key,
      required this.pageEvent,
      required this.holeId,
      required this.totalDepth,
      required this.fechaInicio,
        required this.fechaFinal})
      : super(key: key);

  @override
  CollarTabState createState() =>
      CollarTabState(pageEvent: pageEvent, holeId: holeId);
}

class CollarTabState extends State<CollarTab> {
  final ValueChanged<bool> pageEvent;
  final int holeId;
  CollarTabState({required this.pageEvent, required this.holeId});

  final _db = new DBDataEntry();

  bool candado = false;


  TextEditingController _campaignController = new TextEditingController();
  TextEditingController _countryController = new TextEditingController();
  TextEditingController _geologistController = new TextEditingController();
  TextEditingController _dateStartCtrl = TextEditingController();
  DateTime? _dateStart = DateTime.now();
  TextEditingController _dateEndCtrl = TextEditingController();
  DateTime? _dateEnd;

  TextEditingController _totalDepthController = new TextEditingController();
  TextEditingController _coordMethodController = new TextEditingController();

  TextEditingController _eastController = new TextEditingController();
  TextEditingController _northController = new TextEditingController();
  TextEditingController _elevationController = new TextEditingController();
  TextEditingController _RLEllipsoidController = new TextEditingController();
  TextEditingController _RLOrthometricController = new TextEditingController();
  TextEditingController _gridNameController = new TextEditingController();

  TextEditingController _azimuthController = new TextEditingController();
  TextEditingController _azimuthMethodController = new TextEditingController();

  TextEditingController _dipController = new TextEditingController();
  TextEditingController _dipMethodController = new TextEditingController();

  TextEditingController _projectCompanyController = new TextEditingController();

  TextEditingController _drillingCompanyController =
      new TextEditingController();

  TextEditingController _rigIDController = new TextEditingController();

  TextEditingController _drillTypeController = new TextEditingController();

  TextEditingController _diameterTypeController = new TextEditingController();

  TextEditingController _casingDiameterController = new TextEditingController();

  TextEditingController _topOfSulphidesController = new TextEditingController();
  TextEditingController _baseOfOxidesController = new TextEditingController();
  TextEditingController _DepthToBedrockController = new TextEditingController();
  TextEditingController _waterPresentController = new TextEditingController();

  TextEditingController _waterTableController = new TextEditingController();
  TextEditingController _commentsController = new TextEditingController();
  //late List<Map<String, dynamic>> _itemsSubprojects = [];
  late List<Map<String, dynamic>> _itemsCampaign = [];
  late List<Map<String, dynamic>> _itemsCountry = [];
  late List<Map<String, dynamic>> _itemsGeologist = [];
  late List<Map<String, dynamic>> _itemsCoordMethod = [];
  late List<Map<String, dynamic>> _itemsGridName = [];
  late List<Map<String, dynamic>> _itemsAzimuthMethod = [];
  late List<Map<String, dynamic>> _itemsdipMethod = [];
  late List<Map<String, dynamic>> _itemsProjectCompany = [];
  late List<Map<String, dynamic>> _itemsDrillingCompany = [];
  late List<Map<String, dynamic>> _itemsRigID = [];
  late List<Map<String, dynamic>> _itemsDrillType = [];
  late List<Map<String, dynamic>> _itemsDiameterType = [];
  late List<Map<String, dynamic>> _itemsCasingDiameter = [];
  late List<Map<String, dynamic>> _itemsWaterPresent = [];

  bool ready = false;

  @override
  void initState() {
    super.initState();

    /*_topOfSulphidesController.text = '';
    _baseOfOxidesController.text = '';
    _DepthToBedrockController.text = 'No data';
    _waterPresentController.text = 'No data';
    _waterTableController.text = '';*/
    _db.fnObtenerRegistro(nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId).then((rows){
      setState(() {
        if(rows.values.elementAt(34) == 1){
          candado = true;
        }
      });
    });
    fnLlenarCollar(widget.holeId);
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return (ready
        ? Column(
            children: [
              Text(
                'Collar Tab',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              /*labelInput('Hole ID'),
        Container(
          child: BsInput(
            style: BsInputStyle.outlineRounded,
            size: BsInputSize.md,
            hintText: 'Hole ID',
            controller: _holeIdController,
            prefixIcon: Icons.info_outlined,
            onChange: (text) {
              setState(() {
                pageEvent(true);
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        labelInput('Project'),
        Container(
          child: BsInput(
            style: BsInputStyle.outlineRounded,
            size: BsInputSize.md,
            hintText: 'Project',
            controller: _projectController,
            prefixIcon: Icons.folder_open,
            onChange: (text) {
              setState(() {
                pageEvent(true);
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        sFM(_subprojectController, _itemsSubprojects, _subprojectChanged,
            _subprojectSaved, _subprojectToValidate, 'Subproject'),
        SizedBox(
          height: 20,
        ),*/
              sFM(_campaignController, _itemsCampaign, 'Campaign'),
              SizedBox(
                height: 20,
              ),
              sFM(_countryController, _itemsCountry, 'Country'),
              SizedBox(
                height: 20,
              ),
              sFM(_geologistController, _itemsGeologist, 'Geologist'),
              SizedBox(
                height: 20,
              ),
              labelInput('Date Start'),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: DateTimeField(
                  initialValue: _dateStart,
                  controller: _dateStartCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.1)),
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
                    hintText: 'Date Start',
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
                    setStateIfMounted(() {
                      _dateStart = date;
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('Date End'),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: DateTimeField(
                  initialValue: _dateEnd,
                  controller: _dateEndCtrl,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.1)),
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
                    hintText: 'Date End',
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
                      firstDate: _dateStart ?? DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                  onChanged: (date) {
                    setStateIfMounted(() {
                      _dateEnd = date;
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('Total Depth'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Total Depth',
                  controller: _totalDepthController,
                  prefixIcon: Icons.timelapse,
                  validators: [BsInputValidators.required],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sFM(_coordMethodController, _itemsCoordMethod,
                  'Coordinate Method'),
              SizedBox(
                height: 20,
              ),
              labelInput('East'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'East',
                  controller: _eastController,
                  prefixIcon: Icons.east_rounded,
                  validators: [BsInputValidators.required],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('North'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'North',
                  controller: _northController,
                  prefixIcon: Icons.north_rounded,
                  validators: [BsInputValidators.required],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('Elevation'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Elevation',
                  controller: _elevationController,
                  prefixIcon: Icons.upcoming_rounded,
                  validators: [BsInputValidators.required],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('RL Orthometric'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'RL Orthometric',
                  controller: _RLOrthometricController,
                  prefixIcon: Icons.list_alt_rounded,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('RL Ellipsoid'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'RL Ellipsoid',
                  controller: _RLEllipsoidController,
                  prefixIcon: Icons.list_alt_rounded,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sFM(_gridNameController, _itemsGridName, 'Grid Name'),
              SizedBox(
                height: 20,
              ),
              labelInput('Azimuth'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Azimuth',
                  controller: _azimuthController,
                  prefixIcon: Icons.list_alt_rounded,
                  validators: [BsInputValidators.required],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChange: (text) {
                    if(double.parse(text) > 360){
                      message(CoolAlertType.error, 'Incorrect data',
                          'Azimuth out of range (0 to 360).');
                      _azimuthController.clear();
                    }
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sFM(_azimuthMethodController, _itemsAzimuthMethod,
                  'Azimuth Method'),
              SizedBox(
                height: 20,
              ),
              labelInput('Dip'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Dip',
                  controller: _dipController,
                  prefixIcon: Icons.list_alt_rounded,
                  validators: [BsInputValidators.required],
                  //keyboardType:4
                  //TextInputType.numberWithOptions(decimal: true),
                  onChange: (text) {
                    if(double.parse(text) > 90){
                      message(CoolAlertType.error, 'Incorrect data',
                          'Dip out of range (0 to 90).');
                      _dipController.clear();
                    }

                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sFM(_dipMethodController, _itemsdipMethod, 'Dip Method'),
              SizedBox(
                height: 20,
              ),
              sFM(_projectCompanyController, _itemsProjectCompany,
                  'Project Company'),
              SizedBox(
                height: 20,
              ),
              sFM(_drillingCompanyController, _itemsDrillingCompany,
                  'Drilling Company'),
              SizedBox(
                height: 20,
              ),
              sFM(_rigIDController, _itemsRigID, 'Rig ID'),
              SizedBox(
                height: 20,
              ),
              sFM(_drillTypeController, _itemsDrillType, 'Drill type'),
              SizedBox(
                height: 20,
              ),
              sFM(_diameterTypeController, _itemsDiameterType, 'Diameter Type'),
              SizedBox(
                height: 20,
              ),
              sFM(_casingDiameterController, _itemsCasingDiameter,
                  'Casing Diameter'),
              SizedBox(
                height: 20,
              ),
              labelInput('Top of Sulplhides'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Top of Sulphides',
                  controller: _topOfSulphidesController,
                  prefixIcon: Icons.list_alt_rounded,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('Base of Oxides'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Base of Oxides',
                  controller: _baseOfOxidesController,
                  prefixIcon: Icons.list_alt_rounded,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              labelInput('Depth to Bedrock'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Depth to Bedrock',
                  controller: _DepthToBedrockController,
                  prefixIcon: Icons.list_alt_rounded,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              sFM(_waterPresentController, _itemsWaterPresent, 'Water Present'),
              SizedBox(
                height: 20,
              ),
              labelInput('Water Table'),
              Container(
                child: BsInput(
                  style: BsInputStyle.outlineRounded,
                  size: BsInputSize.md,
                  hintText: 'Water Table',
                  controller: _waterTableController,
                  prefixIcon: Icons.list_alt_rounded,
                  onChange: (text) {
                    setStateIfMounted(() {
                      pageEvent(true);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
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
                      setStateIfMounted(() {
                        pageEvent(true);
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton.icon(

                  onPressed: candado ? null : () async {
                    await updateCollarData();
                  } ,
                  style: ElevatedButton.styleFrom(
                      primary: DataEntryTheme.deOrangeDark,
                      alignment: Alignment.center),
                  icon: Icon(Icons.check, size: 25),
                  label: Text(
                    "SAVE COLLAR DATA",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          )
        : widgetLoading(context));
  }

  /*Widget _buildBody() {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: 50,
          itemBuilder: (context, index) {
            return Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('$index'),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            width: double.infinity,
            child: TextButton(
                child: Text('FlatButton', style: TextStyle(fontSize: 24)),
                onPressed: () => {}),
          ),
        ),
      ],
    );
  }*/

  Widget sFM(TextEditingController sfm_controller, sfm_items, sfm_label) {
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
          onChanged: (val) => {
            setStateIfMounted(() {
              pageEvent(true);
            }),
            print(val),
          },
          /*validator: (val) {
            setState(() => sfm_value_changed = val ?? '');
            return null;
          },
          onSaved: (val) => setState(() => sfm_value_changed = val ?? ''),*/
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

  Future<void> updateCollarData() async {
    FocusScope.of(context).unfocus();
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    dynamic FechaFinal;
    if(_dateEnd.toString() == 'null'){
      FechaFinal = null;
    }else {
      FechaFinal = _dateEnd.toString();
    }
    Map<String, dynamic> valores = {
      'Campaign': _campaignController.text,
      'Country': _countryController.text,
      'Geologist': _geologistController.text,
      'DateStart': _dateStart.toString() ,
      'DateEnd': FechaFinal,
      'Depth': double.tryParse(_totalDepthController.text)?.toStringAsFixed(3),
      'CoordSyst': _coordMethodController.text,
      'East': double.tryParse(_eastController.text)?.toStringAsFixed(3),
      'North': double.tryParse(_northController.text)?.toStringAsFixed(3),
      'Elevation': double.tryParse(_elevationController.text)?.toStringAsFixed(3),
      'RLOrthometric': _RLOrthometricController.text,
      'RLEllipsoid': _RLEllipsoidController.text,
      'GridName': _gridNameController.text,
      'Azimuth': double.tryParse(_azimuthController.text)?.toStringAsFixed(3),
      'Azimuth_Method': _azimuthMethodController.text,
      'Dip': double.tryParse(_dipController.text)?.toStringAsFixed(3),
      'DipMethod': _dipMethodController.text,
      'DH_Company': _projectCompanyController.text,
      'Drill_Company': _drillingCompanyController.text,
      'RigID': _rigIDController.text,
      'DrillType': _drillTypeController.text,
      'DiameterType': _diameterTypeController.text,
      'CasingSize': _casingDiameterController.text,
      'Top_Od_Sulphides': _topOfSulphidesController.text,
      'Base_Of_Oxides': _baseOfOxidesController.text,
      'Depth_BedRock': _DepthToBedrockController.text,
      'WaterPresent': _waterPresentController.text,
      'WaterTable': _waterTableController.text,
      'Collar_Comment': _commentsController.text,
    };
    if (await validateRequired(valores)) {
      await _db.fnActualizarRegistro('tb_collar', valores, 'id', widget.holeId);
      //widget.totalDepth = double.parse(_dipController.text);
      setStateIfMounted(() {
        pageEvent(true);
      });
      CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
          type: CoolAlertType.success,
          title: "Success!",
          text: 'Collar data has been saved successfully.');
      Loader.hide();
    }
  }

  Future<void> fnLlenarCatalogos() async {
    /*_itemsSubprojects =
        await _db.fnRegistrosValueLabelIcon(tbName: 'tb_subprojects');*/
    _itemsCampaign = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_campaign', orderByCampo: 'repetitions');
    _itemsCountry = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_country', orderByCampo: 'repetitions');
    _itemsGeologist = await _db.fnRegistrosValueGeolog(
        tbName: 'cat_geologist', holeid: widget.holeId);
    _itemsCoordMethod = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_coordsyst', orderByCampo: 'repetitions');
    _itemsGridName = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_gridname', orderByCampo: 'repetitions');
    _itemsAzimuthMethod = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_surveytype', orderByCampo: 'repetitions');
    _itemsdipMethod = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_surveytype', orderByCampo: 'repetitions');
    _itemsRigID = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_rigid', orderByCampo: 'repetitions');
    _itemsDiameterType = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_diametertype', orderByCampo: 'repetitions');
    _itemsCasingDiameter = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_casediameter', orderByCampo: 'repetitions');
    _itemsWaterPresent = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_waterpresent', orderByCampo: 'repetitions');
    _itemsDrillType = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_drilltype', orderByCampo: 'repetitions');
    _itemsProjectCompany = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_companyexploration', orderByCampo: 'repetition');
    _itemsDrillingCompany = await _db.fnRegistrosValueLabelIcon(
        tbName: 'cat_companydrill', orderByCampo: 'repetitions');
    setStateIfMounted(() {});
  }

  Future<void> fnLlenarCollar(int id) async {
    await fnLlenarCatalogos();
    var mCollar = new CollarModel();
    mCollar = await mCollar.getModel(id).then((modal) => modal);
    log('${mCollar.candado}');
    if (mCollar.id > 0) {
      if(mCollar.candado == 1){
        candado = true;
      }

      _campaignController.text = '${mCollar.campaign}';
      _countryController.text = '${mCollar.country}';
      _geologistController.text = '${mCollar.geologist}';
      if (mCollar.dateStart != '') {
        _dateStartCtrl.text =
            DateFormat('MM/dd/yyyy').format(DateTime.parse(mCollar.dateStart));
        _dateStart = DateTime.parse(mCollar.dateStart);
      }
      if (mCollar.dateEnd != '') {
        _dateEndCtrl.text = DateFormat('MM/dd/yyyy')
            .format( DateTime.parse(mCollar.dateEnd ?? null) );
        _dateEnd = DateTime.parse(mCollar.dateEnd);
      }
      _RLOrthometricController.text = '${mCollar.rLOrthometric}';
      _totalDepthController.text = '${mCollar.depth}';
      _coordMethodController.text = '${mCollar.coordSyst}';
      _eastController.text = '${mCollar.east}';
      _northController.text = '${mCollar.north}';
      _elevationController.text = '${mCollar.elevation}';
      _RLEllipsoidController.text = '${mCollar.rLEllipsoid}';
      _gridNameController.text = '${mCollar.gridName}';
      _azimuthController.text = '${mCollar.azimuth}';
      _azimuthMethodController.text = '${mCollar.azimuthMethod}';
      _dipController.text = '${mCollar.dip}';
      _dipMethodController.text = '${mCollar.dipMethod}';
      _projectCompanyController.text = '${mCollar.dHCompany}';
      _drillingCompanyController.text = '${mCollar.drillCompany}';
      _rigIDController.text = '${mCollar.rigID}';
      _drillTypeController.text = '${mCollar.drillType}';
      _diameterTypeController.text = '${mCollar.diameterType}';
      _casingDiameterController.text = '${mCollar.casingSize}';
      _topOfSulphidesController.text =
          '${(mCollar.topOdSulphides == '') ? 'No data' : mCollar.topOdSulphides}';
      _baseOfOxidesController.text =
          '${(mCollar.baseOfOxides == '') ? 'No data' : mCollar.baseOfOxides}';
      _DepthToBedrockController.text =
          '${(mCollar.depthBedRock == '') ? 'No data' : mCollar.depthBedRock}';
      _waterPresentController.text =
          '${(mCollar.waterPresent == '') ? 5 : mCollar.waterPresent}';
      _waterTableController.text =
          '${(mCollar.waterTable == '') ? 'No data' : mCollar.waterTable}';
      _commentsController.text = '${mCollar.collarComment}';

      ready = true;
      setStateIfMounted(() {});
    }
  }

  Future<bool> validateRequired(Map<String, Object?> valores) async {
    if (valores['Depth'].toString() == '' ||
        !isNumeric(valores['Depth'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the Total Depth (numeric)');

      return false;
    }
    if (!isNumeric(valores['Azimuth'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Azimuth value will be numeric.');

      return false;
    } else if (double.parse(valores['Azimuth'].toString()) < 0 ||
        double.parse(valores['Azimuth'].toString()) > 360) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Azimuth out of range (0 to 360).');

      return false;
    }
    if (!isNumeric(valores['Dip'].toString())) {
      Loader.hide();
      message(
          CoolAlertType.error, 'Incorrect data', 'Dip value will be numeric.');

      return false;
    } else if (double.parse(valores['Dip'].toString()) < -90 ||
        double.parse(valores['Dip'].toString()) > 90) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Dip out of range (0 to +- 90).');

      return false;
    }
    if (valores['East'].toString() == '' ||
        !isNumeric(valores['East'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the East (numeric)');

      return false;
    }
    if (valores['North'].toString() == '' ||
        !isNumeric(valores['North'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the North (numeric)');

      return false;
    }
    if (valores['Elevation'].toString() == '' ||
        !isNumeric(valores['Elevation'].toString())) {
      Loader.hide();
      message(CoolAlertType.error, 'Incorrect data',
          'Please enter the Elevation (numeric)');

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
}
