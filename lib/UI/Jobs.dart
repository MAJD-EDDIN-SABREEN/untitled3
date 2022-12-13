import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/UI/addJob.dart';
import 'package:untitled3/UI/jobDetail.dart';
import 'package:untitled3/UI/sectionDetail.dart';

class Jobs extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
return JobsState();
  }

}class JobsState extends State<Jobs>{
  CollectionReference jobRef = FirebaseFirestore.instance.collection(
      "Jobs");
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.blue,
     ),
     body: StreamBuilder<dynamic>(stream:jobRef.snapshots(),
    builder:(context,snapshots){

    if(snapshots.hasError){
    return Text("erorr");
    }
    if (snapshots.hasData){
    return ListView.builder(
    itemCount: snapshots.data.docs!.length,
    itemBuilder: (context,i)
    {
    return ListTile(trailing: Icon(Icons.monetization_on),
    title: Text("${snapshots.data.docs[i].data()["title"]}"),
    subtitle: Text("${snapshots.data.docs[i].data()["description"]}"),
      onTap:  (){
      showDialog(context: context, builder: (
          BuildContext context) {
        return
          AlertDialog(
            title: Text("please select"),
            actions: [
              InkWell(
                child: Row(
                  children: [
                    Icon(Icons.update),
                    Text("Update job")
                  ],
                )
                , onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>JobDetail(snapshots.data.docs[i].id, "${snapshots.data.docs[i].data()["image"]}", "${snapshots.data.docs[i].data()["title"]}", "${snapshots.data.docs[i].data()["description"]}", "${snapshots.data.docs[i].data()["salary"]}")));
              },
              ),
              Padding(padding: EdgeInsets.all(10),),

              //onTap: uplodImages(),

            ],
          );
      });},
    );
    }
    ,

    );
    }
    return Center(child: CircularProgressIndicator(),);
    }
     ),
     floatingActionButton: FloatingActionButton(onPressed: (){
       Navigator.push(context,MaterialPageRoute(builder: (context)=>AddJob()));
     },child: Icon(Icons.add)),
   );
  }

}