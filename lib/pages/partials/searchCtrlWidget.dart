import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class SearchCtrlWidget extends StatefulWidget {
  final Function fnFilter;
  final bool checkBoxShow;
  final String titleText;
  SearchCtrlWidget(
      {Key? key,
      required this.fnFilter,
      required this.checkBoxShow,
      this.titleText = 'Search...'})
      : super(key: key);

  @override
  _SearchCtrlWidgetState createState() => _SearchCtrlWidgetState();
}

class _SearchCtrlWidgetState extends State<SearchCtrlWidget> {
  bool _btnCleanShow = false;
  bool _checkAll = false;
  bool _checkBoxShow = false;
  final txtSearchCtrl = TextEditingController();

  @override
  void initState() {
    _checkBoxShow = widget.checkBoxShow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                fnFilter(value);
              },
              controller: txtSearchCtrl,
              decoration: InputDecoration(
                labelText: widget.titleText,
                hintText: widget.titleText,
                prefixIcon: Icon(Icons.search),
                suffixIcon: (_btnCleanShow
                    ? IconButton(
                        onPressed: () {
                          txtSearchCtrl.clear();
                          fnFilter('');
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        icon: Icon(Icons.clear),
                      )
                    : null),
              ),
            ),
          ),
          (!_checkBoxShow
              ? Container()
              : Container(
                  child: Checkbox(
                    activeColor: DataEntryTheme.deOrangeLight,
                    value: _checkAll,
                    onChanged: (value) {
                      fnCheckAll(value!);
                    },
                  ),
                )),
        ],
      ),
    );
  }

  fnFilter(String textSearch) {
    widget.fnFilter(textSearch);

    if (textSearch.isNotEmpty) {
      _btnCleanShow = true;
    } else {
      _btnCleanShow = false;
    }
    setState(() {});
  }

  fnCheckAll(bool check) {}
}
