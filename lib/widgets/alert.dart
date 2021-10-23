import 'package:flutter/material.dart';

Future alertSnackbarMessage(context,
    {required GlobalKey<ScaffoldState> key,
    required String text,
    required Color color}) async {
  final SnackBar snackBar = SnackBar(
    content: Text(text),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
