import 'package:data_entry_app/controllers/GeneralController.dart';
import 'package:data_entry_app/pages/localCollarPage.dart';
import 'package:data_entry_app/pages/newCollarPage.dart';
import 'package:data_entry_app/pages/projectPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';


import 'dataConfigPage.dart';
import 'serverCollarPage.dart';

class OptionsCollarPage extends StatefulWidget {
  final int subProyectoId, proyectoId, campaingId;

  late void Function(EnumPages value) fnChangeToPage;

 // final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  OptionsCollarPage(
      {Key? key,
      required this.subProyectoId,
      required this.proyectoId,
      required this.campaingId

      })
      : super(key: key);

  @override
  _OptionsCollarPageState createState() => _OptionsCollarPageState();

  
}

class _OptionsCollarPageState extends State<OptionsCollarPage> {
  int width = 2, height = 5;
  EnumPages contentPage = EnumPages.project_List;
  String title = "Project List";
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  @override
  void initState() {
    super.initState();
  }
  

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
          "What would you like to do?",
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      body:

      Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewCollarPage(
                                campaingId: widget.campaingId,
                                proyectoId: widget.proyectoId,
                                subProyectoId: widget.subProyectoId,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / width,
                  height: MediaQuery.of(context).size.height / height,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        /*size: MediaQuery.of(context).size.width / 10,*/
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'New Collar',
                        style: TextStyle(
                            color: DataEntryTheme.deBrownDark, fontSize: 18.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Create new local collar...',
                        style: TextStyle(
                            color: DataEntryTheme.deGrayLight, fontSize: 12.0),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocalCollarPage(
                                campaingId: widget.campaingId,
                                proyectoId: widget.proyectoId,
                                subProyectoId: widget.subProyectoId,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / width,
                  height: MediaQuery.of(context).size.height / height,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Update / Continue',
                        style: TextStyle(
                            color: DataEntryTheme.deBrownDark, fontSize: 18.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Edit local collar...',
                        style: TextStyle(
                            color: DataEntryTheme.deGrayLight, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServerCollarPage(
                                campaingId: widget.campaingId,
                                proyectoId: widget.proyectoId,
                                subProyectoId: widget.subProyectoId,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / width,
                  height: MediaQuery.of(context).size.height / height,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_download),
                      SizedBox(height: 5.0),
                      Text(
                        'Search / Import',
                        style: TextStyle(
                            color: DataEntryTheme.deBrownDark, fontSize: 18.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Import collar from server...',
                        style: TextStyle(
                            color: DataEntryTheme.deGrayLight, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context
                      , MaterialPageRoute(builder: (context) => DataConfigPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / width,
                  height: MediaQuery.of(context).size.height / height,
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sync_sharp),
                      SizedBox(height: 5.0),
                      Text(
                        'SYNC UP',
                        style: TextStyle(
                            color: DataEntryTheme.deBrownDark, fontSize: 18.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Syncronize a Collar',
                        style: TextStyle(
                            color: DataEntryTheme.deGrayLight, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),

      ),

    );
  }

  Widget contentPagesShow(EnumPages page, {dynamic param}) {
    Widget newPage;
    switch (page) {
      case EnumPages.sync_up:
        newPage = new DataConfigPage();
        break;
      default:
        newPage = new ProjectPage();
        break;
    }

    if (_sideMenuKey.currentState != null) {
      _sideMenuKey.currentState!.closeSideMenu();
    }
    setState(() {});
    return newPage;
  }




  void fnBackPage() async {
    Navigator.pop(context);
  }
}
