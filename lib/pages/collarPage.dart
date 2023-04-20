import 'package:data_entry_app/models/RelProfileTabsFieldsModal.dart';
import 'package:data_entry_app/tabs/mineralisationTab.dart';

import 'package:select_form_field/select_form_field.dart';
import 'package:data_entry_app/tabs/collarTab.dart';
import 'package:data_entry_app/tabs/loggedByTab.dart';
import 'package:data_entry_app/tabs/lithologyTab.dart';
import 'package:data_entry_app/tabs/alterationTypeTab.dart';
import 'package:data_entry_app/tabs/alterationMinsTab.dart';
import 'package:data_entry_app/tabs/structureTab.dart';
import 'package:data_entry_app/tabs/samplesQCTab.dart';
import 'package:data_entry_app/tabs/samplesTab.dart';
import 'package:data_entry_app/tabs/geotech1CoreRunsTab.dart';
import 'package:data_entry_app/tabs/geotechCoreLogTab.dart';
import 'package:data_entry_app/tabs/geotechLostCoreTab.dart';
import 'package:data_entry_app/tabs/downholeSurveysTab.dart';
import 'package:data_entry_app/tabs/diameterTab.dart';
import 'package:data_entry_app/tabs/specificGravityTab.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';

import 'package:flutter/material.dart';

class CollarPage extends StatefulWidget {
  final int holeId;
  CollarPage({Key? key, required this.holeId}) : super(key: key);

  @override
  CollarPageState createState() => CollarPageState();
}

class CollarPageState extends State<CollarPage> {
  final _db = new DBDataEntry();
  Widget wCollar = Container();
  Widget wLoggedBy = Container();
  Widget wLithology = Container();
  Widget wAlterationType = Container();
  Widget wAlterationMins = Container();
  Widget wMineralisation = Container();
  Widget wStructure = Container();
  Widget wSamples = Container();
  Widget wSamplesQC = Container();
  Widget wGeotech1_CoreRuns = Container();
  Widget wGeotech_CoreCoreLog = Container();
  Widget wGeotech1_LostCore = Container();
  Widget wDownhole_Surveys = Container();
  Widget wDiameter = Container();
  Widget wSpecific_Gravity = Container();
  //final _collarModel = new CollarModel();
  TextEditingController? _controller;
  String _valueChanged = 'collar';
  //String _valueToValidate = '';
  //String _valueSaved = '';
  late String _holeName = '';
  double _totalDepth = 0;

  String _dateEndCollar = '';
  String _dateStartCollar = '';

  //bool _chkUpdate = false;
  final List<Map<String, dynamic>> _items = [];
  String _initial_item = 'collar';

  @override
  void initState() {
    super.initState();
    //_valueToValidate = '';
    //_valueSaved = '';
    fnCargarTabs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DataEntryTheme.deBrownDark,
          ),
          onPressed: () {
            fnBackPage();
          },
        ),
        title: Text(
          _holeName,
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: wSelectedTabs(),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: fnBody()
                  ),
               ),
              )
            )
          ],
        ),
      ),

      /*Container(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: wSelectedTabs(),
            ),
            fnBody(),
          ],
        ),
      ),*/
    );
  }

  Widget wSelectedTabs() {
    return (_items.length > 0
        ? Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Choose a tab',
                    style: TextStyle(
                      color: DataEntryTheme.deRedLight,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  color: DataEntryTheme.deRedLight,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0),
                    child: SelectFormField(
                      type: SelectFormFieldType.dialog,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                      controller: _controller,
                      initialValue: _initial_item,
                      icon: Icon(Icons.tab),
                      labelText: 'Choose a tab',
                      changeIcon: true,
                      dialogTitle: 'Pick a tab to show',
                      dialogCancelBtn: 'CANCEL',
                      enableSearch: true,
                      dialogSearchHint: 'Search tab name',
                      items: _items,
                      onChanged: (val) => {
                        setState(() {
                          _valueChanged = val;
                        }),
                      },
                      validator: (val) {
                        //setState(() => _valueToValidate = val ?? '');
                        return null;
                      },
                      onSaved: (val) {
                        //setState(() => _valueSaved = val ?? '');
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container());
  }

  Widget fnBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /*SizedBox(
          height: 30,
        ),*/
        Visibility(
          maintainState: true,
          child: wCollar,
          visible: (_valueChanged == 'collar') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wLoggedBy,
          visible: (_valueChanged == 'loggedby') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wLithology,
          visible: (_valueChanged == 'lithology') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wAlterationType,
          visible: (_valueChanged == 'alterationtype') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wAlterationMins,
          visible: (_valueChanged == 'alterationmins') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wMineralisation,
          visible: (_valueChanged == 'mineralisation') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wStructure,
          visible: (_valueChanged == 'structure') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wSamples,
          visible: (_valueChanged == 'sample') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wSamplesQC,
          visible: (_valueChanged == 'sampqc') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wGeotech1_CoreRuns,
          visible: (_valueChanged == 'geotechcorelog') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wGeotech_CoreCoreLog,
          visible: (_valueChanged == 'geotechcorerun') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wGeotech1_LostCore,
          visible: (_valueChanged == 'lostcore') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wDownhole_Surveys,
          visible: (_valueChanged == 'downholesurveys') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wDiameter,
          visible: (_valueChanged == 'diameter') ? true : false,
        ),
        Visibility(
          maintainState: true,
          child: wSpecific_Gravity,
          visible: (_valueChanged == 'specificgravity') ? true : false,
        ),
      ],
    );
  }

  Future<bool> fnCargarTabs() async {
    await _db
        .fnObtenerRegistro(
            nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId)
        .then((rows) {
      setState(() {
        _holeName = rows.values.elementAt(1);
        _totalDepth =
            (rows.values.elementAt(9) == null) ? 0 : rows.values.elementAt(9);

        _dateStartCollar =
            (rows.values.elementAt(7) == null) ? '' : rows.values.elementAt(7);
        _dateEndCollar =
            (rows.values.elementAt(8) == null) ? '' : rows.values.elementAt(8);
      });
    });

    List<RelProfileTabsFieldsModal> tb = await RelProfileTabsFieldsModal()
        .fnObtenerPestanasActivas(widget.holeId);
    if (tb.length > 0) {
      _initial_item = tb.first.tabName.replaceAll("tb_", "");
      for (RelProfileTabsFieldsModal item in tb) {
        String nombre = item.tabName.replaceAll("tb_", "");
        String capNombre = nombre.toUpperCase();
        if (capNombre == 'GEOTECHCORELOG') {
          capNombre = 'GEOTECH CORE LOG';
        }
        //print(capNombre);
        _items.add({
          'value': nombre,
          'label': capNombre,
          'icon': Icon(Icons.tab_unselected),
        });
      }
      setState(() {
        _initial_item = tb.first.tabName.replaceAll("tb_", "");
        _valueChanged = _initial_item;
      });
    }

    await _createTabs();
    return true;
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }

  Future<void> _updateTabs(bool value) async {
    await _db
        .fnObtenerRegistro(
            nombreTabla: 'tb_collar', campo: 'id', valor: widget.holeId)
        .then((rows) {
      setState(() {
        _totalDepth =
            (rows.values.elementAt(9) == null) ? 0 : rows.values.elementAt(9);
        _dateStartCollar =
            (rows.values.elementAt(7) == null) ? '' : rows.values.elementAt(7);
        _dateEndCollar =
            (rows.values.elementAt(8) == null) ? '' : rows.values.elementAt(8);
      });
    });
    setState(() {});
    await _createTabs();
  }

  //Function to create the tabs
  Future<void> _createTabs() async {
    wCollar = new CollarTab(
        pageEvent: _updateTabs,
        holeId: widget.holeId,
        totalDepth: _totalDepth,
        fechaInicio: _dateStartCollar,
        fechaFinal: _dateEndCollar);
    wLoggedBy = new LoggedByTab(
      pageEvent: _updateTabs,
      holeId: widget.holeId,
      totalDepth: _totalDepth,
      fechaInicio: _dateStartCollar,
      fechaFinal: _dateEndCollar,
    );
    wLithology = new LithologyTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wAlterationType = new AlterationTypeTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wAlterationMins = new AlterationMinsTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wMineralisation = new MineralisationTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wStructure = new StructureTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wSamples = new SamplesTab(
        pageEvent: _updateTabs,
        holeId: widget.holeId,
        totalDepth: _totalDepth,
        fechaInicio: _dateStartCollar,
        fechaFinal: _dateEndCollar);
    wSamplesQC = new SamplesQCTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wGeotech1_CoreRuns = new Geotech1CoreRunsTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wGeotech_CoreCoreLog = new GeotechCoreLogTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wGeotech1_LostCore = new GeoTechLostCoreTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wDownhole_Surveys = new DownholeSurveysTab(
        pageEvent: _updateTabs,
        holeId: widget.holeId,
        totalDepth: _totalDepth,
        fechaInicio: _dateStartCollar,
        fechaFinal: _dateEndCollar);
    wDiameter = new DiameterTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
    wSpecific_Gravity = new SpecificGravityTab(
        pageEvent: _updateTabs, holeId: widget.holeId, totalDepth: _totalDepth);
  }
}
