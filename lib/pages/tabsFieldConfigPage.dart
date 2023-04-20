import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/models/ProfileTabsFieldsModel.dart';
import 'package:data_entry_app/pages/partials/ctrlBuscarWidget.dart';
import 'package:data_entry_app/pages/partials/errorWidget.dart';
import 'package:data_entry_app/pages/selectTabsFieldsPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class TabsFieldConfigPage extends StatefulWidget {
  TabsFieldConfigPage({Key? key}) : super(key: key);

  @override
  TabsFieldConfigPageState createState() => TabsFieldConfigPageState();
}

class TabsFieldConfigPageState extends State<TabsFieldConfigPage> {
  String titulo = 'List profile tabs';
  TextEditingController txtBuscarCtrl = TextEditingController();
  bool btnLimpiar = false, checkAll = false, fnCheckAll = false;
  List<ProfileTabsFieldsModel> _listProfileTabsFieldsModel = [];

  @override
  void initState() {
    super.initState();

    fnCargarConfiguracionTabs();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: DataEntryTheme.deOrangeDark,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            titulo,
            style: TextStyle(
              color: DataEntryTheme.deBrownDark,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: DataEntryTheme.deOrangeDark,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectTabsFieldsPage(
                          perfilId: 0,
                        )));
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectTabsFieldsPage()));
             */
          },
          child: Icon(Icons.add),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: RefreshIndicator(
            onRefresh: () {
              return fnCargarConfiguracionTabs();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  wCtrlBuscar(
                      context: context,
                      mostrarCheckBox: false,
                      fnFilter: (value) {},
                      txtBuscarCtrl: txtBuscarCtrl,
                      btnLimpiar: btnLimpiar,
                      refresh: setState),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text('List of display profiles.'),
                  ),
                  Expanded(
                    child: (_listProfileTabsFieldsModel.length > 0
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 60.0),
                            shrinkWrap: true,
                            itemCount: _listProfileTabsFieldsModel.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return fnCardPerfil(
                                  _listProfileTabsFieldsModel[index]);
                            },
                          )
                        : errorWidget(
                            context: context,
                            titulo: "No results found.",
                            mensaje:
                                "Click +, to create a new tab and field display profile for a hole.")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // #LISTAR CONFIGURACIONES DE TABS.
  Future<void> fnCargarConfiguracionTabs() async {
    var modal = new ProfileTabsFieldsModel();
    await modal.fnCreateTable();
    _listProfileTabsFieldsModel = await modal.selectActivos();
    setStateIfMounted(() {});
  }

  Widget fnCardPerfil(ProfileTabsFieldsModel modelo) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectTabsFieldsPage(
                        perfilId: modelo.id,
                      )));
        },
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_ind,
                        color: Colors.grey[600],
                      ),
                      Text(
                        modelo.profileName,
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      fnEliminarPerfil(modelo.id);
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fnEliminarPerfil(int id) async {
    bool respuesta = false;
    ProfileTabsFieldsModel modelo = new ProfileTabsFieldsModel();
    respuesta = await modelo.fnEliminarPerfilCompleto(id);
    if (respuesta) {
      fnCargarConfiguracionTabs();
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Profile successfully removed.",
      );
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "An error occurred while deleting the profile.",
      );
    }
  }
}
