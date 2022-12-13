import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/UI/Sections.dart';
import 'UI/Log_In.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var role=  prefs.getString('role');
  var theme=prefs.getBool('theme');
  runApp(
      MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData.light(),
    routes: <String, WidgetBuilder>{

      '/section': (BuildContext context) => Section(""),

    },
    home:(email==null)?Login():Section(role.toString()),
  ));
}




