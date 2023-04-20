import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/pages/partials/ctrlBuscarWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

import 'errorWidget.dart';

class SelectedCollarsPage extends StatefulWidget {
  final void Function(String holeId) getSelecterHold;
  const SelectedCollarsPage({Key? key, required this.getSelecterHold})
      : super(key: key);

  @override
  SelectedCollarsPageState createState() => SelectedCollarsPageState();
}

class SelectedCollarsPageState extends State<SelectedCollarsPage> {
  Map<String, bool> _seleccionItems = Map();
  List<Map<String, dynamic>> listaCampos = [];
  List<Map<String, dynamic>> listaCamposfiltrado = [];
  TextEditingController txtBuscarCampoCtrl = TextEditingController();
  bool btnCerrarBusqueda = false;
  DBDataEntry _dbDataEntry = new DBDataEntry();
  String holdId = '';

  @override
  void initState() {
    super.initState();
    fnCargarBarrenos();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0,
      height: MediaQuery.of(context).size.height / 2,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height / 3,
        minWidth: MediaQuery.of(context).size.height / 5,
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      //margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow[600],
                      ),
                    ),
                    Text(
                      'Collar List.',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: DataEntryTheme.deOrangeDark,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          (listaCamposfiltrado.isNotEmpty
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: wCtrlBuscar(
                    context: context,
                    mostrarCheckBox: false,
                    fnFilter: _runFilter,
                    txtBuscarCtrl: txtBuscarCampoCtrl,
                    btnLimpiar: btnCerrarBusqueda,
                    refresh: () {
                      setStateIfMounted(() {});
                    },
                  ),
                )
              : Container()),
          //Divider(),
          Expanded(
            child: (listaCamposfiltrado.isNotEmpty
                ? ListView.builder(
                    itemCount: listaCamposfiltrado.length,
                    itemBuilder: (context, index) {
                      //final item = items[index];
                      return ListTile(
                        title: InkWell(
                          onTap: () {
                            widget.getSelecterHold(
                                listaCamposfiltrado[index]['HoleId']);
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.bookmarks,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(listaCamposfiltrado[index]['HoleId']),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      errorWidget(
                          context: context, mensaje: "No result found."),
                      SizedBox(height: 10.0),
                      /*
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.green),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SincroCollarsPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_download),
                            SizedBox(width: 5.0),
                            Text('Download Collars'),
                          ],
                        ),
                      ),
                      */
                    ],
                  )),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fnCargarBarrenos() async {
    await _dbDataEntry.database.then((db) async {
      listaCampos = await db.query("tb_collar");
    });
    listaCamposfiltrado = listaCampos;
    _seleccionItems.clear();
    setStateIfMounted(() {});
    return listaCampos;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = listaCampos;
      btnCerrarBusqueda = false;
    } else {
      results = listaCampos
          .where((element) => element['HoleId']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      btnCerrarBusqueda = true;
    }
    setStateIfMounted(() {
      listaCamposfiltrado = results;
    });
  }
}
