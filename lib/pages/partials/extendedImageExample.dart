import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:path/path.dart' as Path;

class ExtendedImageExample extends StatefulWidget {
  final String urlFileImage;
  final int id;
  ExtendedImageExample({Key? key, required this.urlFileImage, this.id = 0})
      : super(key: key);

  @override
  _ExtendedImageExampleState createState() => _ExtendedImageExampleState();
}

class _ExtendedImageExampleState extends State<ExtendedImageExample> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  ImageProvider provider = ExtendedExactAssetImageProvider(
    'assets/images/onboard/Construction-bro.png',
    cacheRawData: true,
  );

  late File fileImage;
  String tituloImagen = "Empty";

  @override
  void initState() {
    fileImage = new File(widget.urlFileImage);
    provider = ExtendedFileImageProvider(fileImage, cacheRawData: true);
    tituloImagen = Path.basename(fileImage.path);

    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    super.dispose();
  }

  double x = 0;
  double y = 0;
  double z = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.text_fields,
            color: DataEntryTheme.deGrayDark,
          ),
          title: Text(
            tituloImagen,
            style: TextStyle(color: DataEntryTheme.deOrangeLight),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: DataEntryTheme.deBrownDark,
              ),
            ),
          ],
        ),
        body: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AspectRatio(aspectRatio: 1, child: buildImage()),
            ],
          ),
        ),
        bottomNavigationBar:
            _buildTools() // _buildFunctions(), //_buildFunctions(),
        );
  }

  Widget buildImage() {
    return ExtendedImage(
      image: provider,
      extendedImageEditorKey: editorKey,
      initEditorConfigHandler: (_) => EditorConfig(
        /*maxScale: 8.0,
        cropRectPadding: const EdgeInsets.all(20.0),
        hitTestSize: 20.0,
        cropAspectRatio: 2 / 1,*/
        cropAspectRatio: CropAspectRatios.custom,
      ),
    );
  }

  Widget _buildTools() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
          onPressed: () async {
            await crop();
          },
          icon: Icon(
            Icons.save,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: () {
            flip();
          },
          icon: Icon(Icons.flip),
        ),
        IconButton(
          onPressed: () {
            rotate(false);
          },
          icon: Icon(Icons.rotate_left),
        ),
        IconButton(
          onPressed: () {
            rotate(true);
          },
          icon: Icon(Icons.rotate_right),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.details),
        ),
        IconButton(
          onPressed: () {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              text: "Delete file.",
              confirmBtnText: "Yes, Delete",
              onConfirmBtnTap: () async {
                if (await fileImage.exists()) {
                  unawaited(fileImage.delete());
                  await new DBDataEntry().database.then((db) async {
                    await db.delete('evidencias_local',
                        where: 'id', whereArgs: [0]);
                  });
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Download is required before accessing a collar.",
                  );
                }
              },
            );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ]),
    );
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) {
      return;
    }
    final Rect? rect = state.getCropRect();
    if (rect == null) {
      //showToast('The crop rect is null.');
      print('The crop rect is null.');
      return;
    }
    final EditActionDetails action = state.editAction!;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    // final img = await getImageFromEditorKey(editorKey);
    final Uint8List? img = state.rawImageData;

    if (img == null) {
      //showToast('The img is null.');
      print('The img is null.');
      return;
    }

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.outputFormat = const OutputFormat.png(88);

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('result.length = ${result?.length}');

    final Duration diff = DateTime.now().difference(start);

    print('image_editor time : $diff');
    /*showToast('handle duration: $diff',
        duration: const Duration(seconds: 5), dismissOtherToast: true);*/

    if (result == null) return;

    // # GUARDAR IMAGEN.
    showPreviewDialog(result);
  }

  void flip() {
    editorKey.currentState?.flip();
  }

  void rotate(bool right) {
    editorKey.currentState?.rotate(right: right);
  }

  void showPreviewDialog(Uint8List image) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: Center(
            child: SizedBox.fromSize(
              size: const Size.square(200),
              child: Container(
                child: Image.memory(image),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
