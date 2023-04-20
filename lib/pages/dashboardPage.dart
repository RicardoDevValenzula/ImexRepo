import 'dart:async';
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/CatalogoController.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dataConfigPage.dart';
import 'partials/IconSyncroAnimate.dart';
import 'sincroCatalogosPage.dart';

class DashboardPage extends StatefulWidget {
  final void Function(EnumPages value) fnChangeToPage;
  DashboardPage({Key? key, required this.fnChangeToPage}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> _profile;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int projectSincro = 0, catalogoSincro = 0;
  List<Map<String, dynamic>> _lstSyncUp = [];

  @override
  void initState() {
    super.initState();
    _profile = _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      return _userInfo;
    });

    fnLoadCollarsSyncUp();

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      projectSincro = BackgroundController.projects;
      catalogoSincro = CatalogoController.catalogo;
      setStateIfMounted(() {});
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _profile,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return widgetLoading(context);
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return fnCardsDashboard(snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget fnCardsDashboard(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    List<Widget> lstWidget = [];
    // #WIDGET DE BIENVENIDA.
    lstWidget.add(Card(
      color: DataEntryTheme.deOrangeLight,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${snapshot.data!['name'] ?? ''}.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'asd a asdasdasd ads asdas d asd asdsa dasd.',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 25.0,
              child: Image.asset("assets/icon/icon_profile.png"),
            ),
          ],
        ),
      ),
    ));

    lstWidget.add(SizedBox(height: 20.0));

    lstWidget.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Card(
            color: Colors.green,
            child: InkWell(
              onTap: () {
                widget.fnChangeToPage(EnumPages.project_List);
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.folder_special,
                      size: MediaQuery.of(context).size.width / 8,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Go to Project list.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Card(
            child: InkWell(
              onTap: () {
                widget.fnChangeToPage(EnumPages.setting);
              },
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.settings,
                        size: MediaQuery.of(context).size.width / 8),
                    SizedBox(height: 10.0),
                    Text('Go to Settings.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));

    lstWidget.add(SizedBox(height: 20.0));

    // #WIDGET DE CATALOGO.
    lstWidget.add(Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.source),
                    Text(
                      ' Catalogs.',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Last update of catalogs: ',
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            (catalogoSincro == 0
                ? IconButton(
                    onPressed: () {
                      if (CatalogoController.catalogo == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SincroCatalogosPage(tipoTabla: 1)));
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text:
                                "At this moment there is a synchronization process. Please try another time.",
                            barrierDismissible: true,
                            confirmBtnText: "Ok",
                            onConfirmBtnTap: () async {
                              Navigator.pop(context);
                            });
                      }
                    },
                    icon: Icon(Icons.open_in_new))
                : Column(
                    children: [
                      new IconSyncroAnimate(),
                      Text(
                        'Updating...',
                        style: TextStyle(fontSize: 10.0, color: Colors.green),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    ));

    //#WIDGET DE BARRENOS.
    lstWidget.add(Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.folder_special),
                    Text(
                      ' Projects.',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Last update of projects: ',
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            (projectSincro == 0
                ? IconButton(
                    onPressed: () {
                      if (BackgroundController.projects == 0) {
                        widget.fnChangeToPage(EnumPages.project_List);
                      } else {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text:
                                "At this moment there is a synchronization process. Please try another time.",
                            barrierDismissible: true,
                            confirmBtnText: "Ok",
                            onConfirmBtnTap: () async {
                              Navigator.pop(context);
                            });
                      }
                    },
                    icon: Icon(Icons.open_in_new))
                : Column(
                    children: [
                      new IconSyncroAnimate(),
                      Text(
                        'Updating...',
                        style: TextStyle(fontSize: 10.0, color: Colors.green),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    ));

    lstWidget.add(SizedBox(height: 20.0));

    // #SINCRONUZACION PENDIENTES O ULTIMA.
    lstWidget.add(Card(
      color: DataEntryTheme.deGrayMedium,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          verticalDirection: VerticalDirection.up,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.published_with_changes,
                      color: Colors.white,
                    ),
                    Text(
                      ' Sync up.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Sincronizacion pendientes...: ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _lstSyncUp
                      .map((e) => Container(
                            child: Row(
                              children: [
                                Icon(Icons.upload, color: Colors.green),
                                Text(
                                  'Hole: ${e.entries.first.key}.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )
              ],
            ),
            IconButton(
              onPressed: () {
                widget.fnChangeToPage(EnumPages.sync_up);
              },
              icon: Icon(
                Icons.open_in_new,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ));

    return Column(children: lstWidget);
  }

  Future<void> fnLoadCollarsSyncUp() async {
    _lstSyncUp =
        await new DataConfigPageState().fnObtenerListaBarrenosSincronizar();
    setStateIfMounted(() {});
  }
}
