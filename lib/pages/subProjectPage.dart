import 'package:data_entry_app/models/SubProjectModel.dart';
import 'package:data_entry_app/pages/optionsCollar.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/partials/searchCtrlWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

import 'collarTabsPage.dart';

class SubProjectPage extends StatefulWidget {
  final int proyectoId;
  SubProjectPage({Key? key, required this.proyectoId}) : super(key: key);

  @override
  _SubProjectPageState createState() => _SubProjectPageState();
}

class _SubProjectPageState extends State<SubProjectPage> {
  List<SubProjectModel> _listSubProyectos = [];
  List<SubProjectModel> _listSubProyectosFiltrado = [];
  bool visible = false;
  TextEditingController txtBuscarCtrl = TextEditingController();
  int totalSubProyectos = 0;

  @override
  void initState() {
    super.initState();
    fnCargarSubProyectos();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Text("$totalSubProyectos subprojects."),
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
          'Sub Project List.',
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
            return fnCargarSubProyectos();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SearchCtrlWidget(fnFilter: _runFilter, checkBoxShow: false),
                Expanded(
                  child: (_listSubProyectosFiltrado.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.only(bottom: 60.0),
                          shrinkWrap: true,
                          itemCount: _listSubProyectosFiltrado.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return fnCardSubProyecto(
                                _listSubProyectosFiltrado[index]);
                          })
                      : errorWidget(
                          context: context, mensaje: "No result found.")),
                ),
              ],
            ),
          ),
          /*
          FutureBuilder<List<SubProjectModel>>(
              future: _listSubProyectos,
              builder: (BuildContext context,
                  AsyncSnapshot<List<SubProjectModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height,
                        child: Center(
                          child: widgetLoading(context),
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: (_listSubProyectos.length > 0
                                  ? ListView.builder(
                                      padding: EdgeInsets.only(bottom: 60.0),
                                      shrinkWrap: true,
                                      itemCount: _listSubProyectos.length,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return fnCardSubProyecto(
                                            _listSubProyectos[index]);
                                      })
                                  : errorWidget(
                                      context: context,
                                      mensaje:
                                          "No se encontraron resultados.")),
                            ),
                          ],
                        ),
                      );
                    }
                }
              }),*/
        ),
      ),
    );
  }

  fnCargarSubProyectos() async {
    var subProyectoModel = new SubProjectModel();
    _listSubProyectos = await subProyectoModel.getAll(widget.proyectoId);
    _listSubProyectosFiltrado = _listSubProyectos;
    totalSubProyectos = _listSubProyectos.length;
    setState(() {
      visible = true;
    });
    return _listSubProyectos;
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }

  Widget fnCardSubProyecto(SubProjectModel subproyecto) {
    return InkWell(
      onTap: () {
        //fnIrBarreno(widget.proyectoId, subproyecto.id);
        fnIrOpcionesCollar(widget.proyectoId, subproyecto.id);
      },
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.greenAccent,
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
                      Text(subproyecto.name, style: TextStyle(fontSize: 20.0))
                    ]),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.folder_special, size: 12.0),
                            Text(
                              subproyecto.projectName,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text("Proyecto",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fnIrBarreno(int proyectoId, int subProyectoId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CollarTabsPage(
                  proyectoId: proyectoId,
                  subProyectoId: subProyectoId,
                  campaingId: 0,
                )));
    /*
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CollarListPage(
                proyectoId: proyectoId, subProyectoId: subProyectoId, campaingId: 0,)));
     */
    /*
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CampaignPage(subProyectoId: subProyectoId, proyectoId: proyectoId,)));
     */
  }

  fnIrOpcionesCollar(int proyectoId, int subProyectoId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OptionsCollarPage(
                  proyectoId: proyectoId,
                  subProyectoId: subProyectoId,
                  campaingId: 0,
                )));
  }

  void _runFilter(String enteredKeyword) {
    List<SubProjectModel> results;
    if (enteredKeyword.isEmpty) {
      results = _listSubProyectos;
    } else {
      results = _listSubProyectos
          .where((element) =>
              element.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setStateIfMounted(() {
      _listSubProyectosFiltrado = results;
      totalSubProyectos = _listSubProyectosFiltrado.length;
    });
  }
}
