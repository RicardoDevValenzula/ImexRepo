import 'package:data_entry_app/pages/collarListPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class ServerCollarPage extends StatefulWidget {
  final int subProyectoId, proyectoId, campaingId;
  ServerCollarPage(
      {Key? key,
      required this.subProyectoId,
      required this.proyectoId,
      required this.campaingId})
      : super(key: key);

  @override
  _ServerCollarPageState createState() => _ServerCollarPageState();
}

class _ServerCollarPageState extends State<ServerCollarPage> {
  @override
  void initState() {
    super.initState();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DataEntryTheme.deBrownDark,
          ),
          onPressed: () {
            fnBackPage();
          },
        ),
        title: Text(
          'Server Collars.',
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      body: new CollarListPage(
        subProyectoId: widget.subProyectoId,
        proyectoId: widget.proyectoId,
        campaingId: widget.campaingId,
        fromServer: true,
      ),
    );
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }
}
