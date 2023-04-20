import 'dart:io';
import 'dart:math' as Math;

import 'package:cool_alert/cool_alert.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/pages/partials/extendedImageExample.dart';
import 'package:data_entry_app/pages/partials/selectedCollars.dart';
import 'package:data_entry_app/pages/partials/selectedImagesCollars.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class EvidenceConfigPage extends StatefulWidget {
  EvidenceConfigPage({Key? key}) : super(key: key);

  @override
  _EvidenceConfigPageState createState() => _EvidenceConfigPageState();
}

class _EvidenceConfigPageState extends State<EvidenceConfigPage> {
  String _selectedHoleId = 'No selected collar';
  bool activarBtnImagen = false, activarToolsImagen = false;
  Map<String, dynamic> _infoImageSelected = Map();
  int imageLocalId = 0;
  var _txtEdtCtrlRenameImage = TextEditingController();
  DBDataEntry _dbDataEntry = new DBDataEntry();
  String nameTableEvidenciasLocal = 'evidencias_local';
  String nameImageToHoleId = 'No name';
  CropController _imageCropCtrl = CropController();

  @override
  void initState() {
    _infoImageSelected['url'] = null;
    _imageCropCtrl = new CropController();
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: null,
        leadingWidth: 0.0,
        title: TextButton(
          onPressed: () async {
            await fnSeleccionarBarreno();
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(Icons.search),
              ),
              Text(_selectedHoleId),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: (activarBtnImagen
                ? () async {
                    await fnSeleccionarImagenesCargadas(_selectedHoleId);
                  }
                : null),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(Icons.collections),
                ),
                Text('Images'),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[400],
                child: Stack(
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: Container(
                        child: Center(
                          child: (_infoImageSelected['url'] == null
                              ? Icon(
                            Icons.hide_image,
                            size: (MediaQuery.of(context).size.height / 5),
                            color: Colors.white,
                          )
                              : contenedorImagen),
                        ),
                      ),
                    ),
                    (activarToolsImagen
                        ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          color: Colors.transparent,
                          child: TextButton(
                            onPressed: () async {
                              await fnRenombrarLaImagen(
                                  imageLocalId, nameImageToHoleId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(child: Text(nameImageToHoleId)),
                                  Icon(Icons.drive_file_rename_outline)
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  DataEntryTheme.deOrangeDark),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: DataEntryTheme.deOrangeLight),
                                ),
                              ),
                            ),
                          )),
                    )
                        : Container()),
                    (activarToolsImagen
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [contenedorHerramentas],
                          ),
                        ),
                      ),
                    )
                        : Container()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: contenedorHerramentas,
    );
/*
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await fnSeleccionarBarreno();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.search),
                      ),
                      Text(_selectedHoleId),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (activarBtnImagen
                      ? () async {
                          await fnSeleccionarImagenesCargadas(_selectedHoleId);
                        }
                      : null),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.collections),
                      ),
                      Text('Images'),
                    ],
                  ),
                ),
                //IconButton(onPressed: () {}, icon: Icon(Icons.grading)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[400],
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Container(
                      child: Center(
                        child: (_infoImageSelected['url'] == null
                            ? Icon(
                                Icons.hide_image,
                                size: (MediaQuery.of(context).size.height / 5),
                                color: Colors.white,
                              )
                            : contenedorImagen),
                      ),
                    ),
                  ),
                  (activarToolsImagen
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              color: Colors.transparent,
                              child: TextButton(
                                onPressed: () async {
                                  await fnRenombrarLaImagen(
                                      imageLocalId, nameImageToHoleId);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(child: Text(nameImageToHoleId)),
                                      Icon(Icons.drive_file_rename_outline)
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          DataEntryTheme.deOrangeDark),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(
                                          color: DataEntryTheme.deOrangeLight),
                                    ),
                                  ),
                                ),
                              )),
                        )
                      : Container()),
                  (activarToolsImagen
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [contenedorHerramentas],
                              ),
                            ),
                          ),
                        )
                      : Container()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    */
  }

  Future<void> fnSeleccionarBarreno() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Dialog(
              child: new SelectedCollarsPage(getSelecterHold: getSelecterHold)),
        );
      },
    );
  }

  Future<void> fnSeleccionarImagenesCargadas(String holeId) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Dialog(
            child: new SelectedImagesCollarsPage(
              holeId: holeId,
              setInfoImageSelected: setInfoImageSelected,
            ),
          ),
        );
      },
    );
  }

  void getSelecterHold(String holeId) {
    setStateIfMounted(() {
      _selectedHoleId = holeId;
      if (_selectedHoleId.isNotEmpty) {
        activarBtnImagen = true;
      }
    });
  }

  Future<void> fnRenombrarLaImagen(int id, String oldName) async {
    _txtEdtCtrlRenameImage.text = oldName;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename Image.'),
          content: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Container(
              child: TextFormField(
                controller: _txtEdtCtrlRenameImage,
                decoration: InputDecoration(
                    labelText: 'Name Image:', hintText: "rename image..."),
                validator: (value) {
                  if (value == null || value == '') {
                    return "enter the name for the image...";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
            TextButton(
              child: Text('Rename'),
              onPressed: () async {
                if (await fnRenombrarImagenLocal(
                    id, _txtEdtCtrlRenameImage.text)) {
                  setStateIfMounted(() {
                    nameImageToHoleId = _txtEdtCtrlRenameImage.text;
                  });
                  Navigator.pop(context);
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Rename OK",
                    confirmBtnText: 'OK',
                  );
                } else {
                  Navigator.pop(context);
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: "Rename KO",
                    confirmBtnText: 'OK',
                  );
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> fnRenombrarImagenLocal(int id, String nombre) async {
    bool respuesta = false;
    try {
      int updateId = 0;
      await _dbDataEntry.database.then((db) async {
        updateId = await db.update(nameTableEvidenciasLocal, {'name': nombre},
            where: 'id = ?', whereArgs: [id]);
      });
      respuesta = (updateId > 0 ? true : false);
    } catch (ex) {
      respuesta = false;
      print(ex);
    }
    return respuesta;
  }

  void setInfoImageSelected(Map<String, dynamic> infoImage) {
    this._infoImageSelected = infoImage;
    this.imageLocalId = infoImage['id'];
    if (_infoImageSelected['name'].toString().isEmpty) {
      nameImageToHoleId = _infoImageSelected['original_name'];
    } else {
      nameImageToHoleId = _infoImageSelected['name'];
    }
    fnTipoVisualizacionImagen(TipoVisualizacionImagen.porDefecto);
    activarToolsImagen = true;
    setStateIfMounted(() {});
  }

  Widget _buildCropImage(String imageFile) {
    return Crop(
      image: File(imageFile).readAsBytesSync(),
      controller: _imageCropCtrl,
      onCropped: (image) async {
        File imageCrop = new File('${_infoImageSelected['url']}');
        await imageCrop.writeAsBytes(image);
        fnTipoVisualizacionImagen(TipoVisualizacionImagen.porDefecto);
      },
    );
  }

  // #METODO PARA CAMBIAR DE VISUALIZACION DE IMAGEN.
  Widget contenedorImagen = Container();
  Widget contenedorHerramentas = Container();

  void fnTipoVisualizacionImagen(
      TipoVisualizacionImagen tipoVisualizacionImagen) {
    if ('${_infoImageSelected['url']}'.isNotEmpty) {
      switch (tipoVisualizacionImagen) {
        case TipoVisualizacionImagen.recortar:
          contenedorImagen = _buildCropImage('${_infoImageSelected['url']}');
          contenedorHerramentas = fnHerramentasDefault();
          break;
        case TipoVisualizacionImagen.flipH:
          contenedorImagen = fnFlipHImage('${_infoImageSelected['url']}');
          // SAVE
          showH = !showH;
          break;
        case TipoVisualizacionImagen.flipV:
          contenedorImagen = fnFlipVImage('${_infoImageSelected['url']}');
          showV = !showV;
          break;
        case TipoVisualizacionImagen.perspectiva:
          contenedorImagen = fnPerspectiva('${_infoImageSelected['url']}');
          showPerspectiva = !showPerspectiva;
          break;
        default:
          /*contenedorImagen =
              ImagesContainer(urlFileImage: '${_infoImageSelected['url']}');*/
          contenedorImagen = ExtendedImageExample(
              urlFileImage: '${_infoImageSelected['url']}');
            contenedorHerramentas = fnHerramentasDefault();
          break;
      }
    } else {
      contenedorImagen = Icon(
        Icons.hide_image,
        size: (MediaQuery.of(context).size.height / 5),
        color: Colors.white,
      );
    }
    setStateIfMounted(() {});
  }

  // #HERRAMENTAS DE LA IMAGEN.
  Widget fnHerramentasDefault() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          elevation: 0,
          onPressed: () {
            fnTipoVisualizacionImagen(TipoVisualizacionImagen.recortar);
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(Icons.crop, size: 24),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
        MaterialButton(
          elevation: 0,
          onPressed: () {
            fnTipoVisualizacionImagen(TipoVisualizacionImagen.flipH);
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(Icons.flip, size: 24),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
        MaterialButton(
          elevation: 0,
          onPressed: () {
            fnTipoVisualizacionImagen(TipoVisualizacionImagen.flipV);
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: Transform.rotate(
              angle: 90 * Math.pi / 180, child: Icon(Icons.flip, size: 24)),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
        MaterialButton(
          elevation: 0,
          onPressed: () {},
          color: Colors.blue,
          textColor: Colors.white,
          child: Icon(Icons.details, size: 24),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
        MaterialButton(
          elevation: 0,
          onPressed: () {},
          color: Colors.red,
          textColor: Colors.white,
          child: Icon(Icons.delete_forever, size: 24),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
      ],
    );
  }

  Widget fnHerramentasRecortar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          elevation: 0,
          onPressed: () {
            // #RECORRTAR Y GUARDAR IMAGEN NUEVA.
            _imageCropCtrl.crop();
            //fnTipoVisualizacionImagen(TipoVisualizacionImagen.porDefecto);
          },
          color: Colors.green,
          textColor: Colors.white,
          child: Icon(Icons.check, size: 24),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
        MaterialButton(
          elevation: 0,
          onPressed: () {
            fnTipoVisualizacionImagen(TipoVisualizacionImagen.porDefecto);
          },
          color: Colors.red,
          textColor: Colors.white,
          child: Icon(Icons.close, size: 24),
          padding: EdgeInsets.all(16),
          shape: CircleBorder(),
        ),
      ],
    );
  }

  Future<bool> fnEliminarImagen() async {
    bool respuesta = false;
    int id = 0;
    try {
      //CoolAlert.show(context: context, type: CoolAlertType.confirm, confirmBtnText: '')
      await _dbDataEntry.database.then((db) async {
        id = await db.delete(nameTableEvidenciasLocal,
            where: 'id = ?', whereArgs: [imageLocalId]);
        respuesta = (id > 0 ? true : false);
      });
    } catch (ex) {
      print(ex);
      respuesta = false;
    }
    return respuesta;
  }

  bool showH = false;

  Widget fnFlipHImage(String urlFileImage) {
    return Transform(
      transform: Matrix4.rotationY((showH ? 0 : -2) * Math.pi / 2),
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        alignment: Alignment.center,
        child: Image(
            image: Image.memory(
          File(urlFileImage).readAsBytesSync(),
          fit: BoxFit.fitHeight,
        ).image),
      ),
    );
  }

  bool showV = false;

  Widget fnFlipVImage(String urlFileImage) {
    return Transform(
      transform: Matrix4.rotationX((showV ? 0 : -2) * Math.pi / 2),
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        alignment: Alignment.center,
        child: Image(
            image: Image.memory(
          File(urlFileImage).readAsBytesSync(),
          fit: BoxFit.fitHeight,
        ).image),
      ),
    );
  }

  bool showPerspectiva = false;

  Widget fnPerspectiva(String urlFileImage) {
    return Transform(
      transform: Matrix4.rotationX((showPerspectiva ? 0 : -2) * Math.pi / 2),
      alignment: Alignment.center,
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        alignment: Alignment.center,
        child: Image(
            image: Image.memory(
              File(urlFileImage).readAsBytesSync(),
              fit: BoxFit.fitHeight,
            ).image),
      ),
    );
  }
}

enum TipoVisualizacionImagen { recortar, porDefecto, flipH, flipV, perspectiva }
