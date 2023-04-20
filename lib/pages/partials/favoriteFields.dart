import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/pages/partials/ctrlBuscarWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class FavoriteFieldsPage extends StatefulWidget {
  final String nombreTable;
  const FavoriteFieldsPage({Key? key, required String this.nombreTable})
      : super(key: key);

  @override
  _FavoriteFieldsPageState createState() => _FavoriteFieldsPageState();
}

class _FavoriteFieldsPageState extends State<FavoriteFieldsPage> {
  Map<String, bool> _seleccionFavorito = Map();
  List<Map<String, dynamic>> listaCampos = [];
  List<Map<String, dynamic>> listaCamposfiltrado = [];
  TextEditingController txtBuscarCampoCtrl = TextEditingController();
  bool btnCerrarBusqueda = false;
  int maximoValorRepeticion = 999;

  @override
  void initState() {
    super.initState();
    fnCargarCampos();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
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
                      'Favorite Fields.',
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
          Container(
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
          ),
          //Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: listaCamposfiltrado.length,
              itemBuilder: (context, index) {
                //final item = items[index];
                return ListTile(
                    title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          child: Text(
                            listaCamposfiltrado[index]['valor'],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: (_seleccionFavorito[listaCamposfiltrado[index]
                                    ['valor']] ==
                                true
                            ? Colors.yellow[600]
                            : Colors.grey[600]),
                      ),
                      onPressed: () {
                        bool? check = false;
                        if (_seleccionFavorito[listaCamposfiltrado[index]
                                ['valor']] !=
                            null) {
                          check = _seleccionFavorito[listaCamposfiltrado[index]
                              ['valor']];
                        }
                        _seleccionFavorito[listaCamposfiltrado[index]
                            ['valor']] = !(check!);

                        bool favorito = !(check);
                        fnAsignarFavorito(widget.nombreTable,
                            listaCamposfiltrado[index]['id'], favorito);
                        setStateIfMounted(() {});
                      },
                    )
                  ],
                ));
              },
            ),
          ),
          //Divider(),

          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            /*child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),*/
          ),
        ],
      ),
    );
  }

  Future<bool> fnAsignarFavorito(
      String nombreTable, int id, bool favorito) async {
    int resultado = await DBDataEntry().fnActualizarRegistro(nombreTable,
        {'repetitions': (favorito ? maximoValorRepeticion : 0)}, 'Id', '$id');
    return (resultado > 0 ? true : false);
  }

  Future<List<Map<String, dynamic>>> fnCargarCampos() async {
    listaCampos = await DBDataEntry().fnObtenerDatosCatalogo(
        tbName: widget.nombreTable, orderByCampo: 'repetitions DESC');
    listaCamposfiltrado = listaCampos;
    _seleccionFavorito.clear();
    listaCampos.forEach((element) {
      _seleccionFavorito[element.values.elementAt(1)] = false;
      if (element.values.elementAt(2) == maximoValorRepeticion) {
        _seleccionFavorito[element.values.elementAt(1)] = true;
      }
    });
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
          .where((element) => element['valor']
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
