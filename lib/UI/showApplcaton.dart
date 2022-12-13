import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ShowApplicaton extends StatefulWidget {
  String sectionId;
  String jobId;

  ShowApplicaton(this.sectionId, this.jobId);

  @override
  State<ShowApplicaton> createState() => _ShowApplicatonState(this.sectionId,this.jobId);
}

class _ShowApplicatonState extends State<ShowApplicaton> {
  String sectionId;
  String jobId;
  String username="";
  String email="";

  getUser(String uid)async{
    var userPref=FirebaseFirestore.instance.collection("Users");
    var query=await userPref.where("id",isEqualTo:uid).get();
    setState(() {
      username=(query.docs[0]["name"]).toString();
      email=(query.docs[0]["email"]).toString();
    });

  }

  _ShowApplicatonState(this.sectionId, this.jobId);

  
  @override
  Widget build(BuildContext context) {
    CollectionReference jobRef =FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs").doc(jobId).collection("applicaions");
    return
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body:
      StreamBuilder<dynamic>(
          stream:jobRef.snapshots(),
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
                    onTap:  ()async{
                      await getUser("${snapshots.data.docs[i].data()["userid"]}");
                      showDialog(context: context, builder: (
                          BuildContext context) {
                        return
                          AlertDialog(
                            title: Text(username),
                            actions: [

                            Text(email)

,Row(children: [ ElevatedButton(onPressed: (){}, child:Text("Acceptable")),ElevatedButton(onPressed: (){}, child:Text("Acceptable"))],
                              )

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

    );
  }
}
