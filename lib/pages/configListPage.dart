import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/CatalogoController.dart';
import 'package:data_entry_app/pages/sincroCatalogosPage.dart';
import 'package:data_entry_app/pages/tabsFieldConfigPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class ConfigListPage extends StatefulWidget {
  ConfigListPage({Key? key}) : super(key: key);

  @override
  _ConfigListPageState createState() => _ConfigListPageState();
}

class _ConfigListPageState extends State<ConfigListPage> {
  int width = 2, height = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabsFieldConfigPage()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / width,
                    height: MediaQuery.of(context).size.height / height,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.tab,
                          /*size: MediaQuery.of(context).size.width / 10,*/
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Tabs/Fields',
                          style: TextStyle(
                              color: DataEntryTheme.deBrownDark,
                              fontSize: 18.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Visible tab/field settings...',
                          style: TextStyle(
                              color: DataEntryTheme.deGrayLight,
                              fontSize: 12.0),
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
                  child: Container(
                    width: MediaQuery.of(context).size.width / width,
                    height: MediaQuery.of(context).size.height / height,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.source,
                          /*size: MediaQuery.of(context).size.width / 10,*/
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Catalogs',
                          style: TextStyle(
                              color: DataEntryTheme.deBrownDark,
                              fontSize: 18.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Update catalogs from the server...',
                          style: TextStyle(
                              color: DataEntryTheme.deGrayLight,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /*
              Card(
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    if (BackgroundController.datosBase == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SincroCollarsPage()));
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
                  child: Container(
                    width: MediaQuery.of(context).size.width / width,
                    height: MediaQuery.of(context).size.height / height,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmarks,
                          /*size: MediaQuery.of(context).size.width / 10,*/
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Collars',
                          style: TextStyle(
                              color: DataEntryTheme.deBrownDark,
                              fontSize: 18.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Download data from the server...',
                          style: TextStyle(
                              color: DataEntryTheme.deGrayLight,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
