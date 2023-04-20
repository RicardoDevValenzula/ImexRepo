import 'package:data_entry_app/pages/collarListPage.dart';
import 'package:data_entry_app/pages/collarPage.dart';
import 'package:data_entry_app/pages/partials/estatusConexionPage.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';

class CollarTabsPage extends StatefulWidget {
  final int subProyectoId, proyectoId, campaingId;
  CollarTabsPage(
      {Key? key,
      required this.subProyectoId,
      required this.proyectoId,
      required this.campaingId})
      : super(key: key);

  @override
  _CollarTabsPageState createState() => _CollarTabsPageState();
}

class _CollarTabsPageState extends State<CollarTabsPage>
    with SingleTickerProviderStateMixin {
  List<Tab> _myTabs = <Tab>[
    Tab(text: 'Started'),
    Tab(text: 'Completed'),
  ];

  late TabController _tabController;
  String optionSelection = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);
    //_tabController.addListener(_handleTabSelection);
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
          'Collar Tabs.',
          style: TextStyle(
            color: DataEntryTheme.deBrownDark,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: _myTabs,
          labelStyle: TextStyle(
            foreground: Paint()..color = Colors.black,
          ),
        ),
        actions: [
          /*IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SincroCollarsPage()));
            },
            icon: Icon(Icons.cloud_download, color: Colors.green),
          ),
          */
          EstatusConexionPage()
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _myTabs.map((Tab tab) {
          final String label = tab.text!.toLowerCase();
          return Center(
            child: fnCollarListShow(label),
          );
        }).toList(),
      ),
    );
  }

  void fnBackPage() async {
    Navigator.pop(context);
  }

  fnIrBarreno(int subproyecto) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CollarPage(holeId: subproyecto)));
  }

  Widget fnCollarListShow(String type) {
    Widget control;
    if (type.trim().toLowerCase() == 'completed') {
      control = CollarListPage(
        subProyectoId: widget.subProyectoId,
        proyectoId: widget.proyectoId,
        campaingId: widget.campaingId,
        collerActive: 0,
      );
    } else {
      control = CollarListPage(
        subProyectoId: widget.subProyectoId,
        proyectoId: widget.proyectoId,
        campaingId: widget.campaingId,
        collerActive: 1,
      );
    }
    return control;
  }
}
