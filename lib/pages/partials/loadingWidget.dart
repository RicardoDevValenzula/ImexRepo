import 'package:flutter/material.dart';

Widget widgetLoading(BuildContext context) {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon/icon_animado.gif",
            height: (MediaQuery.of(context).size.height / 10),
          ),
          /*Text(
            'Loading...',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: DataEntryTheme.deBrownDark),
          ),*/
        ],
      ),
    ),
  );
}
