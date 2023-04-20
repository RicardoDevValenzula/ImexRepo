import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

Widget notInternetConection(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.cloud_off_rounded,
        size: MediaQuery.of(context).size.height / 10,
        color: DataEntryTheme.deOrangeLight,
      ),
      Text("Sin conexión a internet."),
    ],
  );
}
