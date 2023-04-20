import 'dart:async';
import 'dart:convert';

import 'package:data_entry_app/controllers/BackgroundController.dart';
import 'package:data_entry_app/controllers/CatalogoController.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/GeneralController.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/pages/EvidenceConfigPage.dart';
import 'package:data_entry_app/pages/configListPage.dart';
import 'package:data_entry_app/pages/dashboardPage.dart';
import 'package:data_entry_app/pages/loginPage.dart';
import 'package:data_entry_app/pages/partials/estatusConexionPage.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/pages/profilePage.dart';
import 'package:data_entry_app/pages/projectPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import 'dataConfigPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  EnumPages contentPage = EnumPages.project_List;
  late Future<Map<String, dynamic>> _profile;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //String title = "Dashboard";
  String title = "Project List";
  bool shouldPop = false;
  int estatusConexion = 0;

  @override
  void initState() {
    //FocusScope.of(context).requestFocus(new FocusNode());
    super.initState();
    _profile = _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      return _userInfo;
    });
    fnCrearTodasLasTablas();
  }

  void setTitle(String titulo) => setState(() => title = titulo);

  void fnChangeToPage(EnumPages ePage) {
    setState(() {
      title = fnTituloPage(ePage);
      contentPage = ePage;
    });
  }

  String fnTituloPage(EnumPages ePage) {
    String titulo = "";
    titulo = ePage.toString().replaceAll('_', '');
    titulo = (title[0].toUpperCase() + title.substring(1));
    return titulo;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      key: _endSideMenuKey,
      inverse: true, // end side menu
      background: DataEntryTheme.deGrayDark,
      type: SideMenuType.slide,
      menu: buildMenu(),
      radius: null,
      child: SideMenu(
        key: _sideMenuKey,
        menu: buildMenu(),
        type: SideMenuType.slide,
        background: DataEntryTheme.deBrownDark,
        radius: null,
        child: WillPopScope(
          onWillPop: () async {
            return shouldPop;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.menu),
                color: DataEntryTheme.deBrownDark,
                onPressed: () {
                  final _state = _sideMenuKey.currentState;
                  if (_state!.isOpened) {
                    _state.closeSideMenu();
                  } else {
                    _state.openSideMenu();
                  }
                },
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: DataEntryTheme.deBrownDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              actions: [
                new EstatusConexionPage(),
              IconButton(onPressed: (){
                contentPage = EnumPages.sync_up;
                setState(() {
                  title = fnTituloPage(contentPage);
                });
              }, icon: Icon(Icons.published_with_changes, color: DataEntryTheme.deBrownDark), )
              ],

            ),
            //extendBodyBehindAppBar: true,
            body:
            Container(
                child: contentPagesShow(contentPage)
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: DataEntryTheme.deBrownDark,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40.0,
                  child: Image.asset("assets/icon/icon_profile.png"),
                ),
                SizedBox(height: 16.0),
                FutureBuilder<Map<String, dynamic>>(
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
                          return Text(
                            "${snapshot.data!['name'] ?? ''} " +
                                "${snapshot.data!['middle_name'] ?? ''} " +
                                "${snapshot.data!['last_name'] ?? ''}",
                            style: TextStyle(color: Colors.white),
                          );
                        }
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            color: DataEntryTheme.deBrownLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextButton(
                      onPressed: fnProfile,
                      child: Row(
                        children: [
                          Icon(
                            Icons.manage_accounts,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          Text(
                            ' Profile',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextButton(
                      onPressed: fnLogOut,
                      child: Row(
                        children: [
                          Text(
                            'Exit ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.logout,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    contentPage = EnumPages.dashboard;
                    setState(() {
                      title = fnTituloPage(contentPage);
                    });
                  },
                  leading: Icon(Icons.home, size: 20.0, color: Colors.white),
                  title: Text(
                    "Dashboard",
                    style: TextStyle(
                      color: DataEntryTheme.deWhite,
                    ),
                  ),
                  dense: true,
                ),
                ListTile(
                  onTap: () {
                    contentPage = EnumPages.project_List;
                    setState(() {
                      title = fnTituloPage(contentPage);
                    });
                  },
                  leading: Icon(Icons.folder_special,
                      size: 20.0, color: Colors.white),
                  title: Text(
                    "Project List",
                    style: TextStyle(
                      color: DataEntryTheme.deWhite,
                    ),
                  ),
                  dense: true,
                ),
                ListTile(
                  onTap: () {
                    /*
                    contentPage = EnumPages.sync_up;
                    setState(() {
                      title = fnTituloPage(contentPage);
                    });
                     */
                    Navigator.push(
                        context
                        , MaterialPageRoute(builder: (context) => DataConfigPage()));
                  },
                  leading: Icon(Icons.published_with_changes,
                      size: 20.0, color: Colors.white),
                  title: Text(
                    "Sync up",
                    style: TextStyle(
                      color: DataEntryTheme.deWhite,
                    ),
                  ),
                  dense: true,
                ),
                ListTile(
                  onTap: () {
                    contentPage = EnumPages.evidence;
                    setState(() {
                      title = fnTituloPage(contentPage);
                    });
                  },
                  leading: Icon(Icons.photo_library,
                      size: 20.0, color: Colors.white),
                  title: Text(
                    "Evidence",
                    style: TextStyle(
                      color: DataEntryTheme.deWhite,
                    ),
                  ),
                  dense: true,
                ),
                ListTile(
                  onTap: () {
                    contentPage = EnumPages.setting;
                    setState(() {
                      title = fnTituloPage(contentPage);
                    });
                  },
                  leading:
                      Icon(Icons.settings, size: 20.0, color: Colors.white),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      color: DataEntryTheme.deWhite,
                    ),
                  ),
                  dense: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fnLogOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> fnProfile() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  Widget contentPagesShow(EnumPages page, {dynamic param}) {
    Widget newPage;
    //title = "Dashboard";

    switch (page) {
      case EnumPages.project_List:
        newPage = new ProjectPage();
        break;
      case EnumPages.setting:
        newPage = new ConfigListPage();
        break;
      case EnumPages.sync_up:
        newPage = new DataConfigPage();
        break;
      case EnumPages.evidence:
        newPage = new EvidenceConfigPage();
        break;
      case EnumPages.dashboard:
        newPage = new DashboardPage(fnChangeToPage: fnChangeToPage);
        break;
      default:
        //newPage = new DashboardPage(fnChangeToPage: fnChangeToPage);
        newPage = new ProjectPage();
        break;
    }

    if (_sideMenuKey.currentState != null) {
      _sideMenuKey.currentState!.closeSideMenu();
    }
    setState(() {});
    return newPage;
  }

  Future<void> fnCrearTodasLasTablas() async {
    // #OBTENER LISTADO DE CATALOGOS ONLINE.
    List<Map<String, dynamic>> _tablasOnline = [];
    ResultModel tablas = await new SincronizarController().listaTablas();
    if (tablas.status) {
      _tablasOnline = (tablas.data["tablas"] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } else {
      _tablasOnline = [];
    }
    for (int i = 0; i < _tablasOnline.length; i++) {
      await new DBDataEntry().database.then((db) async {
        db.execute(_tablasOnline[i]['create_tabla_sqllite']);
      });
    }

    CatalogoController.initCatalogo(Map());
    BackgroundController.initProjects();
  }
}
