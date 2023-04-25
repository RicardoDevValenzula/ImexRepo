import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Angles extends StatefulWidget {
  final String imageUrl;

  const Angles({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _AnglesState createState() => _AnglesState();
}

class _AnglesState extends State<Angles> {
  double _perspective = 1.5;
  bool _rotateX = false;
  bool _rotateY = false;

  void _saveImage() {
    // Aquí implementa la lógica para guardar la imagen editada
    // en el dispositivo o en algún otro lugar.
  }

  void _resetChanges() {
    // Aquí implementa la lógica para deshacer los cambios
    // y regresar la imagen original.
    setState(() {
      _perspective = 0;
    });
  }

  void _toggleRotateX() {
    setState(() {
      _rotateX = !_rotateX;
    });
  }

  void _toggleRotateY() {
    setState(() {
      _rotateY = !_rotateY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, _perspective / 1000) // Apply perspective
              ..rotateX(_rotateX ? math.pi : 0)
              ..rotateY(_rotateY ? math.pi : 0), // Rotate around X axis
            alignment: Alignment.center,
            child: Image(
              image: Image.memory(
                File(widget.imageUrl).readAsBytesSync(),
                fit: BoxFit.fitHeight,
              ).image,
            ),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
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
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleRotateX,
                  child:
                      Text(_rotateX ? 'Detener Rotación en X' : 'Rotar en X'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _toggleRotateY,
                  child:
                      Text(_rotateY ? 'Detener Rotación en Y' : 'Rotar en Y'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
