import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/UI/EditInfo.dart';
import 'package:untitled3/UI/Myapplication.dart';

import 'Skills.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? email;
  String? image;
  changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = await prefs.getBool('theme');
    if (theme == false)
      await prefs.setBool("theme", true);
    else
      await prefs.setBool("theme", false);
  }
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = await prefs.getString('email');
    print(email);
    setState(() {});
  }

  getDetail() async {
    await getEmail();

    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("email", isEqualTo: email).get();
    setState(() {
      image = query.docs[0]["image"];
    });
  }

  @override
  void initState() {
    getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  image != null
                      ? Container(
                          height: MediaQuery.of(context).size.height / 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: NetworkImage(image!)),
                          ))
                      : Container(
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width / 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Icon(
                            Icons.person,
                            size: MediaQuery.of(context).size.width / 4,
                          )),
                        ),
                  Text(email!)
                ],
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditInfo()));
                    },
                    child: Text("Edit info")),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Row(children: [
                  Icon(
                    Icons.app_registration_outlined,
                    color: Colors.blue,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApplication()));
                        }, child: Text("My applied")),
                  ),
                ]),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Row(children: [
                  Icon(
                    Icons.skateboarding,
                    color: Colors.blue,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child:
                        ElevatedButton(onPressed: () { Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Skills()));}, child: Text("Skills")),
                  ),
                ]),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Row(children: [
                  Icon(
                    Icons.language,
                    color: Colors.blue,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                        onPressed: () {}, child: Text("Language")),
                  ),
                ]),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Row(children: [
                  Icon(
                    Icons.tab_sharp,
                    color: Colors.blue,
                    size: 30,
                  ),
                  Padding(padding: EdgeInsets.only(right: 20)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                        onPressed: () {
                          changeTheme();
                          setState(() {});
                        },
                        child: Text("Theme")),
                  ),
                ]),
              ),
            ],
          )),
    );
  }
}
