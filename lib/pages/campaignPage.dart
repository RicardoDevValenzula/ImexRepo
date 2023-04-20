import 'package:data_entry_app/models/CollarModel.dart';
import 'package:data_entry_app/pages/collarListPage.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/partials/searchCtrlWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class CampaignPage extends StatefulWidget {
  final int subProyectoId, proyectoId;
  CampaignPage(
      {Key? key, required this.subProyectoId, required this.proyectoId})
      : super(key: key);

  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<Map<String, dynamic>> _listCampaign = [];
  List<Map<String, dynamic>> _listCampaignFiltrado = [];
  bool visible = false;
  TextEditingController txtBuscarCtrl = TextEditingController();
  int totalCampaign = 0;

  @override
  void initState() {
    super.initState();
    fnCargarCampaign();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Text("$totalCampaign campaign."),
      ),
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
          'Campaign List.',
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () {
            return fnCargarCampaign();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SearchCtrlWidget(fnFilter: _runFilter, checkBoxShow: false),
                Expanded(
                  child: (_listCampaignFiltrado.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.only(bottom: 60.0),
                          shrinkWrap: true,
                          itemCount: _listCampaignFiltrado.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return fnCardSubProyecto(
                                _listCampaignFiltrado[index]);
                          })
                      : errorWidget(
                          context: context,
                          mensaje: "No se encontraron resultados.")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fnCargarCampaign() async {
    var collarModel = new CollarModel();
    _listCampaign =
        await collarModel.fnObtenerListaDeCampanas(widget.subProyectoId);
    _listCampaignFiltrado = _listCampaign;
    totalCampaign = _listCampaign.length;
    setState(() {
      visible = true;
    });
    return _listCampaign;
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }

  Widget fnCardSubProyecto(Map<String, dynamic> comp) {
    return InkWell(
      onTap: () {
        fnIrBarreno(widget.proyectoId, widget.subProyectoId, int.parse(comp['Id'].toString()));
      },
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.redAccent,
                width: 5.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(children: [
                      Text(comp['campaign'], style: TextStyle(fontSize: 20.0))
                    ]),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fnIrBarreno(int proyectoId, int subProjectId, int campaingId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CollarListPage(
                proyectoId: proyectoId,
                subProyectoId: subProjectId,
                campaingId: campaingId)));
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results;
    if (enteredKeyword.isEmpty) {
      results = _listCampaign;
    } else {
      results = _listCampaign
          .where((element) => element['campaign']
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setStateIfMounted(() {
      _listCampaignFiltrado = results;
      totalCampaign = _listCampaignFiltrado.length;
    });
  }
}
