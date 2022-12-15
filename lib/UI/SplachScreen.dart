import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Log_In.dart';
import 'Sections.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var email;
  var role;
  var theme;
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
     role=  prefs.getString('role');
     theme=prefs.getBool('theme');
     setState(() {
       
     });
  }
  @override
  void initState() {
getEmail();
   Future.delayed(Duration(seconds:5),(){

     (email==null)?
       Navigator.push(context,
           MaterialPageRoute(builder: (context) => Login()))
         :
     Navigator.push(context,
         MaterialPageRoute(builder: (context) => Section(role.toString())));
   });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/5)),
          Center(child: Text("Jobs" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50),),),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              child:  Lottie.asset("images/splachScreen.json"),
            ),
          ),

        ],
      ),
    );
  }
}
