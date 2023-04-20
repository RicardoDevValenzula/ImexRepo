import 'package:flutter/material.dart';

class ShowResumenSyncPage extends StatefulWidget {
  final Map<String, dynamic> infoResumen;
  ShowResumenSyncPage({Key? key, required this.infoResumen}) : super(key: key);

  @override
  _ShowResumenSyncPageState createState() => _ShowResumenSyncPageState();
}

class _ShowResumenSyncPageState extends State<ShowResumenSyncPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '${List<dynamic>.from(widget.infoResumen['resumenOK']).first}'),
            SizedBox(height: 40.0),
            Text('Insert:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '${List<dynamic>.from(widget.infoResumen['res_insert']).length}'),
            SizedBox(height: 20.0),
            Text('Update:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '${List<dynamic>.from(widget.infoResumen['res_update']).length}'),
            SizedBox(height: 20.0),
            Text('Delete:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '${List<dynamic>.from(widget.infoResumen['res_delete']).length}'),
          ],
        ),
      ),
    );
  }
}
