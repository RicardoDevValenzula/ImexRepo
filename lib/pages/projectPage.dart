import 'dart:async';
import 'dart:convert';

import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/CatalogoController.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/CampaignModel.dart';
import 'package:data_entry_app/models/ProjectModel.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/pages/partials/IconSyncroAnimate.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/partials/searchCtrlWidget.dart';
import 'package:data_entry_app/pages/subProjectPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List<ProjectModel> _listProyectos = [];
  List<ProjectModel> _listProyectosFiltrado = [];

  int totalProyectos = 0;
  bool visible = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, dynamic> _profile = {};
  int estatusProjects = -1, estatusCatalogs = -1;
  late Timer _time;
  bool iniciarTimer = false;

  @override
  void initState() {
    super.initState();

    _time = Timer.periodic(Duration(milliseconds: 500), (timer) {
      estatusProjects = BackgroundController.projects;
      estatusCatalogs = CatalogoController.catalogo;

      if (estatusProjects == 1) {
        iniciarTimer = true;
      } else if (estatusProjects == 0 &&
          estatusCatalogs == 0 &&
          iniciarTimer == true) {
        fnCargarProyectos();
        iniciarTimer = false;
      } else if (estatusProjects == 2) {
        iniciarTimer = false;
        _time.cancel();
      }
      setStateIfMounted(() {});
    });

    _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      _profile = _userInfo;
      fnCargarProyectos();
    });

    DBDataEntry()
        .fnRegistrosValueLabelIcon(tbName: new CampaignModel().tbName)
        .then((value) {});
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Text("$totalProyectos projects."),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: () {
            return fnCargarProyectos();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SearchCtrlWidget(fnFilter: _runFilter, checkBoxShow: false),
                Expanded(
                  child: (estatusProjects == 0 && estatusCatalogs == 0
                      ? (_listProyectosFiltrado.length > 0
                          ? ListView.builder(
                              padding: EdgeInsets.only(bottom: 60.0),
                              shrinkWrap: true,
                              itemCount: _listProyectosFiltrado.length,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return fnCardProyecto(
                                    _listProyectosFiltrado[index]);
                              })
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                errorWidget(
                                    context: context,
                                    mensaje: "No result found."),
                                SizedBox(height: 10.0),
                              ],
                            ))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconSyncroAnimate(
                                sizeIcon:
                                    MediaQuery.of(context).size.height / 6),
                            SizedBox(height: 20.0),
                            Text(
                              "Synchronizing projects and catalogs...",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fnCardProyecto(ProjectModel proyecto) {
    return InkWell(
      onTap: () {
        fnIrSubProyecto(proyecto.id);
      },
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: DataEntryTheme.deOrangeDark,
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
                      Text(proyecto.name, style: TextStyle(fontSize: 20.0))
                    ]),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.business_sharp, size: 12.0),
                            Text(proyecto.company,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: DataEntryTheme.deGrayMedium))
                          ],
                        ),
                        Text("Company",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.engineering, size: 12.0),
                            Text(
                                (proyecto.generalLeader.trim().length > 0
                                    ? proyecto.generalLeader
                                    : 'S/D'),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: DataEntryTheme.deGrayMedium))
                          ],
                        ),
                        Text("General Leader",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: DataEntryTheme.deGrayMedium))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.engineering, size: 12.0),
                            Text(
                                (proyecto.environmentalLeader.trim().length > 0
                                    ? proyecto.environmentalLeader
                                    : 'S/D'),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: DataEntryTheme.deGrayMedium))
                          ],
                        ),
                        Text("Environmental Leader",
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

  fnCargarProyectos() async {
    var proyectoModel = new ProjectModel();

    if (await proyectoModel.fnExiste('tb_projects') == false) {
      ResultModel model =
          await SincronizarController().datosDeTabla('tb_projects');
      if (model.status) {
        await proyectoModel.fnCrearTabla(model.data['create_tabla_sqllite']);
      }
    }

    if (await proyectoModel.fnExiste('tb_subprojects') == false) {
      ResultModel model =
          await SincronizarController().datosDeTabla('tb_projects');
      if (model.status) {
        await proyectoModel.fnCrearTabla(model.data['create_tabla_sqllite']);
      }
    }

    if (await proyectoModel.fnExiste('tb_asignedproject') == false) {
      ResultModel model =
          await SincronizarController().datosDeTabla('tb_asignedproject');
      if (model.status) {
        await proyectoModel.fnCrearTabla(model.data['create_tabla_sqllite']);
      }
    }

    int rolId = int.parse(_profile['id_rol']);
    int userId = int.parse(_profile['id']);

    if (rolId == 2) {
      int companyId = int.parse(_profile['id_company']);
      _listProyectos =
          await proyectoModel.obtnerTodosPorUsuarioComania(userId, companyId);
    } else {
      _listProyectos = await proyectoModel.obtnerTodosPorUsuario(userId);
    }

    totalProyectos = _listProyectos.length;
    _listProyectosFiltrado = _listProyectos;
    setStateIfMounted(() {
      visible = true;
    });
  }

  fnIrSubProyecto(int proyectoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubProjectPage(proyectoId: proyectoId),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<ProjectModel> results;
    if (enteredKeyword.isEmpty) {
      results = _listProyectos;
    } else {
      results = _listProyectos
          .where((element) =>
              element.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setStateIfMounted(() {
      _listProyectosFiltrado = results;
      totalProyectos = _listProyectosFiltrado.length;
    });
  }
}
