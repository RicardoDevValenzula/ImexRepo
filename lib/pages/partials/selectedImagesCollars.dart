import 'dart:io';

import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'errorWidget.dart';
import 'loadingWidget.dart';

class SelectedImagesCollarsPage extends StatefulWidget {
  final String holeId;
  final void Function(Map<String, dynamic> infoImage) setInfoImageSelected;
  const SelectedImagesCollarsPage(
      {Key? key, required this.holeId, required this.setInfoImageSelected})
      : super(key: key);

  @override
  SelectedImagesCollarsPageState createState() =>
      SelectedImagesCollarsPageState();
}

class SelectedImagesCollarsPageState extends State<SelectedImagesCollarsPage> {
  Map<String, bool> _seleccionItems = Map();
  List<Map<String, dynamic>> listaCampos = [];
  List<Map<String, dynamic>> listaCamposfiltrado = [];
  TextEditingController txtBuscarCampoCtrl = TextEditingController();
  bool btnCerrarBusqueda = false;
  DBDataEntry _dbDataEntry = new DBDataEntry();
  List<String> lstUrlAdjuntos = [];
  String nameTableEvidenciasLocal = 'evidencias_local';

  @override
  void initState() {
    super.initState();
    fnCargarImagenes();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
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
                      child: Icon(Icons.image),
                    ),
                    Text(
                      'Images Collar List.',
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
          Divider(),
          Expanded(
            child: (listaCamposfiltrado.isNotEmpty
                ? GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: List.generate(
                      listaCamposfiltrado.length,
                      (index) {
                        return Stack(
                          fit: StackFit.passthrough,
                          children: [
                            Image(
                              image: Image.file(
                                File(listaCamposfiltrado[index]['url']),
                                fit: BoxFit.cover,
                              ).image,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                            new Positioned.fill(
                              child: new Material(
                                color: Colors.transparent,
                                child: new InkWell(
                                  splashColor: DataEntryTheme.deOrangeLight,
                                  onTap: () {
                                    widget.setInfoImageSelected(
                                        listaCamposfiltrado[index]);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : errorWidget(context: context, mensaje: "No result found.")),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    fnSelectImageModalBottomSheet();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      Text('Add Images'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fnCargarImagenes() async {
    await _dbDataEntry.database.then((db) async {
      listaCampos = await db.query(nameTableEvidenciasLocal,
          where: "holeId = ?", whereArgs: [widget.holeId]);
    });

    listaCamposfiltrado = listaCampos;
    _seleccionItems.clear();
    setStateIfMounted(() {});
    return listaCampos;
  }

  void fnSelectImageModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(bottom: 20),
          child: new Wrap(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Actions to do .",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(10.00),
              ),
              Divider(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () async {
                        bool resp = await _openCamera(context);
                        if (resp) {
                          //print(lstUrlAdjuntos.first);
                          await fnGuardarImagenLocal(
                              widget.holeId, lstUrlAdjuntos.first);
                          await fnCargarImagenes();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add_a_photo, color: Colors.green),
                          ),
                          Text('Take a photo'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool resp = await _openGallery(context);
                        if (resp) {
                          //print(lstUrlAdjuntos.first);
                          await fnGuardarImagenLocal(
                              widget.holeId, lstUrlAdjuntos.first);
                          await fnCargarImagenes();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.collections, color: Colors.blue),
                          ),
                          Text('Select from the device'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _openCamera(BuildContext context) async {
    lstUrlAdjuntos.clear();
    bool respuestas = false;
    PickedFile? picture =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    if (picture != null) {
      Directory directory = await getApplicationDocumentsDirectory();
      String urlImage =
          '${directory.path}/${widget.holeId}_${DateTime.now().microsecondsSinceEpoch}${Path.extension(picture.path)}';
      await new File(picture.path).copy(urlImage);
      setState(() {
        lstUrlAdjuntos.add(urlImage);
        respuestas = true;
      });
    }
    Loader.hide();
    return respuestas;
  }

  Future<bool> _openGallery(BuildContext context) async {
    lstUrlAdjuntos.clear();
    bool respuestas = false;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    if (result != null) {
      if (result.files.isNotEmpty) {
        String pathImg = result.files.first.path ?? '';
        Directory directory = await getApplicationDocumentsDirectory();
        String urlImage =
            '${directory.path}/${widget.holeId}_${DateTime.now().microsecondsSinceEpoch}${Path.extension(pathImg)}';
        await new File(pathImg).copy(urlImage);
        setState(() {
          lstUrlAdjuntos.add(urlImage);
          respuestas = true;
        });
      }
    }
    Loader.hide();
    return respuestas;
  }

  Future<bool> fnGuardarImagenLocal(String holeId, String path) async {
    bool respuesta = false;
    try {
      // #OOBTENER NOMBRE DEL ARCHIVO LOCAL.
      String originalName = path.split('/').last;
      int insertId = 0;
      await _dbDataEntry.database.then((db) async {
        int id = await _dbDataEntry.fnObtnerNuevoId(nameTableEvidenciasLocal);
        insertId = await db.insert(
            nameTableEvidenciasLocal,
            {
              'id': id,
              'holeId': holeId,
              'name': '',
              'original_name': originalName,
              'url': path,
              'status': 1
            },
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
      respuesta = (insertId > 0 ? true : false);
    } catch (ex) {
      respuesta = false;
      print(ex);
    }
    return respuesta;
  }
}
