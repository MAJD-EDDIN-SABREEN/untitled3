import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyApplication extends StatefulWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
List applcations=[];
var userPref=FirebaseFirestore.instance.collection("Application");
String ?id;
  getid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   id = prefs.getString('id');





  }
  @override
  void initState() {

   // getDetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body:
        StreamBuilder<dynamic>(
            stream:userPref.where("userid",isEqualTo: id).snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr");
              }
              if (snapshots.hasData){
                return ListView.builder(
                  itemCount: snapshots.data.docs!.length,
                  itemBuilder: (context,i)
                  {

                    return ListTile(//trailing: Icon(Icons.monetization_on),
                      leading: Icon(Icons.settings_applications_outlined),
                     subtitle:Text("${snapshots.data.docs[i].data()["expected salary"]}"),
                      title:Text("${snapshots.data.docs[i].data()["notes"]}") ,
                      onTap:  (){
                      },
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
