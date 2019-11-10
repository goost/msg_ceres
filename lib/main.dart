import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'RESTClient.dart';
import 'choices.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        primarySwatch: Colors.teal,
        buttonColor: Colors.amber,
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary)),
    home: ChoicesData(),
  ));
}
