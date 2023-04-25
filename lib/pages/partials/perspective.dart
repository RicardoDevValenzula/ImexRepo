import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:data_entry_app/pages/EvidenceConfigPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../controllers/DBDataEntry.dart';

class ImagePerspective extends StatefulWidget {
  final String imageUrl;
  final String nameImage;
  final BuildContext buildContext;

  const ImagePerspective(
      {Key? key,
      required this.imageUrl,
      required this.nameImage,
      required this.buildContext})
      : super(key: key);

  @override
  _ImagePerspectiveState createState() => _ImagePerspectiveState();
}

class _ImagePerspectiveState extends State<ImagePerspective> {
  double _perspective = 1.5;
  GlobalKey _globalKey = GlobalKey();
  DBDataEntry _dbDataEntry = new DBDataEntry();

  Future<void> _saveImage() async {
    int updateId = 0;
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    //print(pngBytes);
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/${widget.nameImage}.png';
    File(path).writeAsBytes(pngBytes);

    await _dbDataEntry.database.then((db) async {
      updateId = await db.update('evidencias_local', {'url': path},
          where: 'name = ?', whereArgs: [widget.nameImage]);
    });
  }

  void _resetChanges() {
    // Aquí implementa la lógica para deshacer los cambios
    // y regresar la imagen original.
    setState(() {
      _perspective = 0;
    });
    Widget newPage = new EvidenceConfigPage();
    Container(
      child: newPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RepaintBoundary(
            key: _globalKey,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, _perspective / 1000) // Apply perspective
                ..rotateX(math.pi * 0.05), // Rotate around X axis
              alignment: Alignment.center,
              child: Image(
                image: Image.memory(
                  File(widget.imageUrl).readAsBytesSync(),
                  fit: BoxFit.fitHeight,
                ).image,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('Perspective'),
              Expanded(
                child: Slider(
                  value: _perspective,
                  min: -3,
                  max: 3,
                  onChanged: (value) {
                    setState(() {
                      _perspective = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _saveImage,
              child: Text('Guardar'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: _resetChanges,
              child: Text('Deshacer'),
            ),
            SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
