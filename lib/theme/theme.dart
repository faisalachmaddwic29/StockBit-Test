import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';

TextStyle headlineTextStyle = GoogleFonts.poppins(
  fontWeight: bold,
  fontSize: 24,
);
TextStyle primaryTextStyle = GoogleFonts.poppins(
  fontWeight: regular,
  fontSize: 13,
);

// TextStyle secondaryTextStyle = GoogleFonts.poppins(
//   color: secondaryTextColor,
// );

// TextStyle subtitleTextStyle = GoogleFonts.poppins(
//   color: subtitleTextColor,
// );

// TextStyle priceTextStyle = GoogleFonts.poppins(
//   color: priceColor,
// );

// TextStyle blackTextStyle = GoogleFonts.poppins(
//   color: blackTextColor,
// );

// TextStyle purpleTextStyle = GoogleFonts.poppins(
//   color: primaryColor,
// );

// TextStyle alertTextStyle = GoogleFonts.poppins(
//   color: alertColor,
// );

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
// Our light/Primary Theme
ThemeData themeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: lightBodyTextColor,
    scaffoldBackgroundColor: lightScaffoldBackgroundColor,
    backgroundColor: lightScaffoldBackgroundColor,
    // accentColor: Colors.amber,
    iconTheme: IconThemeData(color: lightBodyTextColor),
    // accentIconTheme: const IconThemeData(color: kAccentIconLightColor),
    primaryIconTheme: IconThemeData(color: lightBodyTextColor),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headline6: TextStyle(color: lightBodyTextColor),
      headline2: TextStyle(color: lightBodyTextColor),
      bodyText1: TextStyle(color: lightBodyTextColor),
      bodyText2: TextStyle(color: lightBodyTextColor),
      headline4: TextStyle(color: lightBodyTextColor, fontSize: 32),
      headline1: TextStyle(color: lightBodyTextColor, fontSize: 80),
      button: TextStyle(color: lightBodyTextColor),
    ),
    colorScheme: ColorScheme.light(
      // primary: lightBodyTextColor,
      secondary: lightBodyTextColor,
      // surface: lightBodyTextColor,
      // background: lightBodyTextColor,
      // onBackground: lightBodyTextColor,
      onPrimary: lightBodyTextColor,
    ),

    // textTheme: const TextTheme(
    //   headline6: TextStyle(color: Colors.black),
    //   headline2: TextStyle(color: Colors.black),
    //   headline1: TextStyle(color: Colors.black),
    //   headline4: TextStyle(color: Colors.black),
    //   bodyText1: TextStyle(color: Colors.black),
    //   bodyText2: TextStyle(color: Colors.black),
    //   overline: TextStyle(color: Colors.black),
    // ),
  );
}

// Dark Them
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: darkBodyTextColor,
    scaffoldBackgroundColor: darkScaffoldBackgroundColor,
    appBarTheme: appBarTheme,
    backgroundColor: darkScaffoldBackgroundColor,
    iconTheme: IconThemeData(color: darkBodyTextColor),
    // // accentIconTheme: IconThemeData(color: kAccentIconDarkColor),
    // primaryIconTheme: const IconThemeData(color: kPrimaryIconDarkColor),
    // textTheme: GoogleFonts.latoTextTheme().copyWith(
    //   headline6: const TextStyle(color: Colors.green),
    //   bodyText1: const TextStyle(color: kBodyTextColorDark),
    //   bodyText2: const TextStyle(color: kBodyTextColorDark),
    //   headline4: const TextStyle(color: kTitleTextDarkColor, fontSize: 32),
    //   headline1: const TextStyle(color: kTitleTextDarkColor, fontSize: 80),
    // ),
    colorScheme: ColorScheme.dark(
      primary: darkBodyTextColor,
      primaryVariant: darkBodyTextColor,
      secondary: darkBodyTextColor,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: darkBodyTextColor),
      headline2: TextStyle(color: darkBodyTextColor),
      headline1: TextStyle(color: darkBodyTextColor),
      headline4: TextStyle(color: darkBodyTextColor),
      bodyText1: TextStyle(color: darkBodyTextColor),
      bodyText2: TextStyle(color: darkBodyTextColor),
      overline: TextStyle(color: darkBodyTextColor),
      button: TextStyle(color: darkBodyTextColor),
    ),
  );
}

AppBarTheme appBarTheme =
    const AppBarTheme(color: Colors.transparent, elevation: 0);
