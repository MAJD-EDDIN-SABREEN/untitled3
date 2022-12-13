import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:untitled3/UI/addJob.dart';
import 'package:untitled3/UI/application.dart';
import 'package:untitled3/UI/jobDetail.dart';
import 'package:untitled3/UI/sectionDetail.dart';
import 'package:untitled3/UI/showApplcaton.dart';

class Jobs extends StatefulWidget{
  String sectionId;
  String role;
  Jobs(this.sectionId , this.role);

  @override
  State<StatefulWidget> createState() {
return JobsState(this.sectionId,this.role);
  }

}
class JobsState extends State<Jobs>{
  String sectionId;
  String role;
  TextEditingController _searchController = TextEditingController();
  List documents = [];
  String searchText = '';
  JobsState(this.sectionId,this.role);
   @override
  Widget build(BuildContext context) {
    CollectionReference jobRef =FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs");
   return
     (role=="manger")?
     Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.blue,
       actions: [
         Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width/1.2 ,
         child: SearchField(
           suggestions: documents
               .map(
                 (e) => SearchFieldListItem(
               e["title"],
               item: e,
             ),
           )
               .toList(),
         ),
       )
       ],
     ),
     body:



       StreamBuilder<dynamic>(stream:jobRef.snapshots(),
         builder:(context,snapshots){

           if(snapshots.hasError){
             return Text("erorr");
           }
           if (snapshots.hasData){

             return
               ListView.builder(
               scrollDirection: Axis.vertical,
               itemCount: snapshots.data.docs!.length,
               itemBuilder: (context,i)
               {
                 documents.add(snapshots.data.docs[i].data());
                 print("${snapshots.data.docs[i].data()}");
                 return ListTile(
                   trailing: SizedBox(height: 100,width: 100,child:Row(children: [Text("${snapshots.data.docs[i].data()["salary"]}"),Icon(Icons.monetization_on)]) ,)

                   , title: Text("${snapshots.data.docs[i].data()["title"]}"),
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
                               Navigator.push(context,MaterialPageRoute(builder: (context)=>JobDetail(snapshots.data.docs[i].id, "${snapshots.data.docs[i].data()["image"]}", "${snapshots.data.docs[i].data()["title"]}", "${snapshots.data.docs[i].data()["description"]}", "${snapshots.data.docs[i].data()["salary"]}","${snapshots.data.docs[i].data()["requirement"]}","${snapshots.data.docs[i].data()["age"]}","${snapshots.data.docs[i].data()["status"]}",sectionId,"${snapshots.data.docs[i].data()["lat"]}","${snapshots.data.docs[i].data()["lang"]}")));
                             },
                             ),
                             Padding(padding: EdgeInsets.all(10),),
                             InkWell(
                               child: Row(
                                 children: [
                                   Icon(Icons.padding_rounded),
                                   Text("show applications")
                                 ],
                               )
                               , onTap: () {
                               Navigator.push(context,MaterialPageRoute(builder: (context)=>ShowApplicaton(sectionId, snapshots.data.docs[i].id)));
                             },
                             ),

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
       Navigator.push(context,MaterialPageRoute(builder: (context)=>AddJob(sectionId)));
     },child: Icon(Icons.add)),
   ):
     Scaffold(
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
                   return ListTile(trailing: SizedBox(height: 100,width: 100,child:Row(children: [Text("${snapshots.data.docs[i].data()["salary"]}"),Icon(Icons.monetization_on)]) ,)

                       ,title: Text("${snapshots.data.docs[i].data()["title"]}"),
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
                                     Text("applied for job")
                                   ],
                                 )
                                 , onTap: () {
                                 Navigator.push(context,MaterialPageRoute(builder: (context)=>Application(sectionId, snapshots.data.docs[i].id)));
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

     );
  }

}