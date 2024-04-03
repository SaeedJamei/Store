import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/src/app.dart';
import 'package:store/src/infrastructure/commons/params.dart';

Future<void> main() async{
  final preferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(preferences);
  Params.isAdmin = preferences.getBool('isAdmin');
  Params.userId = preferences.getInt('id');
  runApp(const App());
}
