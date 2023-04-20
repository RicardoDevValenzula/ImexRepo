import 'package:flutter/material.dart';

class DataEntryTheme {
  static Color deBlack = Color(0xff333333);
  static Color deWhite = Color(0xffffffff);

  static Color deRedLight = Color(0xffC1262D);
  static Color deRedDark = Color(0xff7D251A);

  static Color deGrayLight = Color(0xff999999);
  static Color deGrayMedium = Color(0xff808080);
  static Color deGrayDark = Color(0xff4D4D4D);

  static Color deBrownLight = Color(0xffAB7D4E);
  static Color deBrownDark = Color(0xff89643D);

  static Color deOrangeLight = Color(0xffEA7800);
  static Color deOrangeDark = Color(0xffBB6000);

  static ThemeData get lightTheme {
    return ThemeData(
      //primaryColor: deBrownDark,
      //accentColor: deOrangeDark,
      scaffoldBackgroundColor: deWhite,
      fontFamily: 'RobotoCondensed-Regular',
      inputDecorationTheme: InputDecorationTheme(
          /*
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: DataEntryTheme.deOrangeLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: DataEntryTheme.deOrangeLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: DataEntryTheme.deOrangeLight, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: DataEntryTheme.deOrangeLight, width: 2),
        ),
        */
          ),
    );
  }

  static ButtonStyle get textButtonPrimary {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      foregroundColor: MaterialStateProperty.all(deWhite),
      /*elevation: MaterialStateProperty.all(10),*/
      backgroundColor: MaterialStateProperty.all(deOrangeDark),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16)),
    );
  }
}
