import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

Widget errorWidget(
    {required BuildContext context, required String mensaje, String? titulo}) {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(titulo ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: DataEntryTheme.deBrownDark)),
          Image.asset(
            "assets/icon/icon_no_result_found.png",
            height: (MediaQuery.of(context).size.height / 4),
          ),
          Text(mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: DataEntryTheme.deBrownDark)),
        ],
      ),
    ),
  );
}
