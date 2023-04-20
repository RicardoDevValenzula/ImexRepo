import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

Widget wCtrlBuscar(
    {required BuildContext context,
    required bool mostrarCheckBox,
    required Function fnFilter,
    required TextEditingController txtBuscarCtrl,
    required bool btnLimpiar,
    required Function refresh,
    bool? checkAll,
    Function? fnCheckAll}) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) {
              fnFilter(value);
              if (value.isNotEmpty) {
                btnLimpiar = true;
              } else {
                btnLimpiar = false;
              }
              refresh();
            },
            controller: txtBuscarCtrl,
            decoration: InputDecoration(
              labelText: "Search...",
              hintText: "Search...",
              prefixIcon: Icon(Icons.search),
              suffixIcon: (btnLimpiar
                  ? IconButton(
                      onPressed: () {
                        txtBuscarCtrl.clear();
                        fnFilter('');
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      icon: Icon(Icons.clear),
                    )
                  : null),
            ),
          ),
        ),
        (!mostrarCheckBox
            ? Container()
            : Container(
                child: Checkbox(
                  activeColor: DataEntryTheme.deOrangeLight,
                  value: checkAll,
                  onChanged: (value) {
                    fnCheckAll!(value!);
                  },
                ),
              )),
      ],
    ),
  );
}
