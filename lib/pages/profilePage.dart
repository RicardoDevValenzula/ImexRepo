import 'dart:convert';

import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String titulo = 'Profile';
  late Future<Map<String, dynamic>> _profile;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late TextEditingController _ctrlNombre,
      _ctrlUsuario,
      _ctrlEmail,
      _ctrlEmpresa;

  late bool editarCampos = false;

  @override
  void initState() {
    super.initState();
    _profile = _prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> _userInfo =
          json.decode((prefs.getString('userInfo') ?? "not username"));
      return _userInfo;
    });

    _ctrlNombre = new TextEditingController();
    _ctrlUsuario = new TextEditingController();
    _ctrlEmail = new TextEditingController();
    _ctrlEmpresa = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: DataEntryTheme.deOrangeDark,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            titulo,
            style: TextStyle(
              color: DataEntryTheme.deBrownDark,
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
        ),
        floatingActionButton: (editarCampos == false
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    editarCampos = true;
                  });
                },
                backgroundColor: Colors.yellow[800],
                child: Icon(
                  Icons.edit,
                  color: DataEntryTheme.deWhite,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          editarCampos = false;
                        });
                      },
                      backgroundColor: Colors.green[800],
                      child: Icon(
                        Icons.save,
                        color: DataEntryTheme.deWhite,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        setState(() {
                          editarCampos = false;
                        });
                      },
                      backgroundColor: Colors.red[800],
                      child: Icon(
                        Icons.close,
                        color: DataEntryTheme.deWhite,
                      ),
                    ),
                  ),
                ],
              )),
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _profile,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return fnEstructuraPerfil(snapshot);
                      }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget fnEstructuraPerfil(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    _ctrlNombre.text =
        "${snapshot.data!['name'] ?? ''} ${snapshot.data!['middle_name'] ?? ''} ${snapshot.data!['last_name'] ?? ''}";
    _ctrlUsuario.text = snapshot.data!['username'] ?? '';
    _ctrlEmail.text = snapshot.data!['email'] ?? '';
    _ctrlEmpresa.text = snapshot.data!['company'] ?? '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(70.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 7,
                  offset: Offset(2, 3), // Shadow position
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 70,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: DataEntryTheme.deOrangeDark,
                backgroundImage: AssetImage(
                  "assets/icon/icon_profile.png",
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _ctrlNombre,
          enabled: editarCampos,
          textAlign: TextAlign.end,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Nombre...',
            labelText: 'Nombre',
            labelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: DataEntryTheme.deOrangeDark,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: DataEntryTheme.deOrangeDark, style: BorderStyle.solid),
            ),
          ),
          onSaved: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            return (value != null && value.contains('@'))
                ? 'Do not use the @ char.'
                : null;
          },
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _ctrlUsuario,
          enabled: editarCampos,
          textAlign: TextAlign.end,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Usuario...',
            labelText: 'Usuario',
            labelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: DataEntryTheme.deOrangeDark,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: DataEntryTheme.deOrangeDark, style: BorderStyle.solid),
            ),
          ),
          onSaved: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            return (value != null && value.contains('@'))
                ? 'Do not use the @ char.'
                : null;
          },
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _ctrlEmail,
          enabled: editarCampos,
          textAlign: TextAlign.end,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Email...',
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: DataEntryTheme.deOrangeDark,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: DataEntryTheme.deOrangeDark, style: BorderStyle.solid),
            ),
          ),
          onSaved: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            return (value != null && value.contains('@'))
                ? 'Do not use the @ char.'
                : null;
          },
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: _ctrlEmpresa,
          enabled: editarCampos,
          textAlign: TextAlign.end,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Empresa...',
            labelText: 'Empresa',
            labelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: DataEntryTheme.deOrangeDark,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: DataEntryTheme.deOrangeDark, style: BorderStyle.solid),
            ),
          ),
          onSaved: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            return (value != null && value.contains('@'))
                ? 'Do not use the @ char.'
                : null;
          },
        ),
        SizedBox(height: 20.0),
      ],
    );

    /*Text(
      "${snapshot.data!['name']} ${snapshot.data!['middle_name']} ${snapshot.data!['last_name']}",
      style: TextStyle(color: DataEntryTheme.deOrangeDark),
    );*/
  }
}
