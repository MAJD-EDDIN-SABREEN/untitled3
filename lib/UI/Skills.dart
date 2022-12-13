import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Skills extends StatefulWidget {
  const Skills({Key? key}) : super(key: key);

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  var userPref=FirebaseFirestore.instance.collection("Users");
  String ?id;
  getid()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('id');
    setState(() {

    });
  }
  @override
  void initState() {

    getid();
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body:
        StreamBuilder<dynamic>(
            stream:userPref.where("id",isEqualTo: id).snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr");
              }
              if (snapshots.hasData){
                return ListView.builder(
                  itemCount: snapshots.data.docs!.length,
                  itemBuilder: (context,i)
                  {

                    return Card(

                      margin: EdgeInsets.all(30),
                      elevation: 5,
                      color: Colors.blue,
                      child:   Card(
                          elevation: 3,
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${snapshots.data.docs[i].data()["skills"]}"),
                                // ListView.builder(itemBuilder: (context,j){
                                //   print(snapshots.data.docs[i].data()["name"]);
                                //  // Text("${snapshots.data.docs[i].data()["skills"][j]}");
                                // })
                              ])),







                    );


                  }
                  ,


                );
              }
              return Center(child: CircularProgressIndicator(),);
            }
        ),

      );
  }
}
