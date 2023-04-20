import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesContainer extends StatefulWidget {
  final String urlFileImage;
  ImagesContainer({Key? key, required this.urlFileImage}) : super(key: key);

  @override
  _ImagesContainerState createState() => _ImagesContainerState();
}

class _ImagesContainerState extends State<ImagesContainer> {
  @override
  void initState() {
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(color: Colors.grey),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: Image.memory(
                File(widget.urlFileImage).readAsBytesSync(),
                fit: BoxFit.fitHeight,
              ).image,
              initialScale: PhotoViewComputedScale.contained * 0.8,
            );
          },
          itemCount: 1,
        ),
      ),
    );
  }
}
