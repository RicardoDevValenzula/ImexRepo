import 'package:flutter/material.dart';

class IconSyncroAnimate extends StatefulWidget {
  final double sizeIcon;
  IconSyncroAnimate({Key? key, this.sizeIcon = 24.0}) : super(key: key);
  @override
  _IconSyncroAnimateState createState() => new _IconSyncroAnimateState();
}

class _IconSyncroAnimateState extends State<IconSyncroAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animationController.repeat();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: animationController,
        child: new Container(
            child: Icon(
          Icons.autorenew,
          color: Colors.green,
          size: widget.sizeIcon,
        )),
        builder: (context, child) {
          return new Transform.rotate(
            angle: animationController.value * 6.3,
            child: child,
          );
        },
      ),
    );
  }
}
