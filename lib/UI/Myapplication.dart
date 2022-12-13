import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyApplication extends StatefulWidget {
  const MyApplication({Key? key}) : super(key: key);

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  var userPref=FirebaseFirestore.instance.collection("Application");
String ?id;
  getid()async{
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
print (id);
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

                    return Card(

                      margin: EdgeInsets.all(30),
                      elevation: 5,
                      color: Colors.blue,
child: Column(children:  [
  Card(
    
    elevation: 3,
    child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text("Expected salary"),
          Text(
              "${snapshots.data.docs[i].data()["expected salary"]}")
        ]),
  ),
  Card(
    elevation: 3,
    child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text("Notes"),
          Text(
              "${snapshots.data.docs[i].data()["notes"]}")
        ]),
  ),
  Card(
    elevation: 3,
    child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text("Start At"),
          Text(
              "${snapshots.data.docs[i].data()["Start_at"]}")
        ]),
  ),
  Card(
    elevation: 3,
    child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text("Created At"),
          Text(
              "${snapshots.data.docs[i].data()["created_at"]}")
        ]),
  ),
  Card(
      elevation: 3,
      child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text("Status"),
            if ((snapshots.data.docs[i]
                .data()["status"])
                .toString() ==
                "0")
              Text("Wating")
            else if ((snapshots.data.docs[i]
                .data()["status"])
                .toString() ==
                "1")
              Text("Acceptable")
            else if ((snapshots.data.docs[i]
                  .data()["status"])
                  .toString() ==
                  "2")
                Text("UnAcceptable"),
          ])),


]),
                    );

                    //   ListTile(
                    //   leading: Icon(Icons.settings_applications_outlined),
                    //  subtitle:Text("${snapshots.data.docs[i].data()["expected salary"]}"),
                    //   title:Text("${snapshots.data.docs[i].data()["notes"]}") ,
                    //   onTap:  (){
                    //   },
                    // );
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
