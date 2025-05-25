import 'package:flutter/material.dart';

ThemeData theme(){
  return ThemeData(
    primaryColor: Colors.deepPurple,
    useMaterial3: true
  );
}

ThemeData darkTheme(){
  return ThemeData.dark(
    useMaterial3: true
  );
}

ThemeMode themeMode(){
  return ThemeMode.light;
}