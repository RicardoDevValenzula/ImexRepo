import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:data_entry_app/controllers/DBDataEntry.dart';
import 'package:data_entry_app/controllers/SincronizarController.dart';
import 'package:data_entry_app/models/ProfileTabsFieldsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:data_entry_app/controllers/UserController.dart';
import 'package:data_entry_app/models/ResultModel.dart';
import 'package:data_entry_app/pages/partials/loadingWidget.dart';
import 'package:data_entry_app/themes/dataEntryTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_entry_app/pages/HomePage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: DataEntryTheme.lightTheme,
      home: LoginFullPage(),
    );
  }
}

class LoginFullPage extends StatefulWidget {
  @override
  _LoginFullPageState createState() => _LoginFullPageState();
}

class _LoginFullPageState extends State<LoginFullPage> {
  final ctrlUser = TextEditingController();
  final ctrlPassword = TextEditingController();
  final userFocuseNode = FocusNode();
  final passwordFocuseNode = FocusNode();
  DBDataEntry db = new DBDataEntry();
  SincronizarController _sincronizarController = new SincronizarController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 8),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Center(
                        child: Image(
                          image:
                              AssetImage("assets/images/logos/logo-imex.png"),
                          /*width: MediaQuery.of(context).size.width,*/
                          height: MediaQuery.of(context).size.height / 6,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SIGN IN,',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: DataEntryTheme.deGrayDark,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Enter your credentials to continue ...',
                              style: TextStyle(
                                fontSize: 15,
                                color: DataEntryTheme.deGrayDark,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: TextFormField(
                                controller: ctrlUser,
                                focusNode: userFocuseNode,
                                decoration: InputDecoration(
                                  hintText: 'Enter your username ...',
                                  prefixIcon: Icon(Icons.face,
                                      color: DataEntryTheme.deOrangeDark),
                                ),
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return "Please enter your username.";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                controller: ctrlPassword,
                                focusNode: passwordFocuseNode,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password ...',
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure ? Icons.visibility:Icons.visibility_off),
                                    onPressed: (){
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                   ),
                                ),
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return "Enter your password.";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      fnForgotPassword();
                                    },
                                    child: Text(
                                      'Did you forget your password?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: DataEntryTheme.deOrangeDark,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: DataEntryTheme.textButtonPrimary,
                                onPressed: () {
                                  fnLogin();
                                },
                                child: Text('Log in'),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final _userController = new UserController();

  Future<void> fnLogin() async {
    FocusScope.of(context).unfocus();
    Loader.show(
      context,
      isAppbarOverlay: true,
      isBottomBarOverlay: true,
      progressIndicator: widgetLoading(context),
      overlayColor: DataEntryTheme.deGrayMedium.withOpacity(0.7),
    );
    ResultModel resultLogin =
        await _userController.login(ctrlUser.text, ctrlPassword.text);
    if (resultLogin.status) {
      // #ELIMINAR Y CREAR BASE DE DATOS.
      await this.db.deleteDB();
      // #INICIALIZAR TABLAS BASE.
      await this.db.initDBAll();
      // #GUARDAR EN SESION.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs
          .setString('token', resultLogin.data['token'])
          .then((bool success) async {
        prefs.setString('userInfo', json.encode(resultLogin.data['userInfo']));
        // #INICIALIZAR TABLA ONLINE.
        await _sincronizarController.fnDescargarYCrearTablaLocal();
        // #CREAR PERFIL DEFAULT.
        int uId = int.parse(resultLogin.data['userInfo']['id']);
        await new ProfileTabsFieldsModel().fnCrearPerfilDefault(uId);
        // #CERRAR LOADING.
        Loader.hide();
        // #REDIRECCIONAR A HOME.
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }).onError((error, stackTrace) {
        // #CERRAR LOADING.
        Loader.hide();
        CoolAlert.show(
          context: context,
          backgroundColor: DataEntryTheme.deGrayLight,
          confirmBtnColor: DataEntryTheme.deGrayDark,
          confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
          type: CoolAlertType.warning,
          title: "Oops!",
          text: "Token no register.",
        );
      });
    } else {
      // #CERRAR LOADING.
      Loader.hide();
      CoolAlert.show(
        context: context,
        backgroundColor: DataEntryTheme.deGrayLight,
        confirmBtnColor: DataEntryTheme.deGrayDark,
        confirmBtnTextStyle: TextStyle(color: DataEntryTheme.deGrayLight),
        type: CoolAlertType.warning,
        title: "Oops!",
        text: resultLogin.message,
      );
    }
  }

  fnForgotPassword() {
    /*
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ForgotPassPage()));
        */
  }

  fnCrearBaseDatos() {
    FutureBuilder(
      future: this.db.initDB(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return widgetLoading(context);
          default:
            if (snapshot.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${snapshot.error}'),
                ),
              );
              return Text('Error: ${snapshot.error}');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Oopss'),
                ),
              );
              return Text('Oopss');
            }
        }
      },
    );
  }
}
