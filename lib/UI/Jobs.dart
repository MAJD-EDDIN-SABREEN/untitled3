import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:searchfield/searchfield.dart';
import 'package:untitled3/UI/addJob.dart';
import 'package:untitled3/UI/application.dart';
import 'package:untitled3/UI/jobDetail.dart';
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
  bool search = false;
  String ?title;
  GoogleMapController? mapController;
  JobsState(this.sectionId,this.role);
  String ?appnum;
  Future<String?> getUserData(String id) async {

    var userPref = FirebaseFirestore.instance.collection("Application");
    var query = await userPref.where("jobid", isEqualTo: id).get();
 appnum= await query.docs.length.toString();
setState(() {
//print(appnum);
});

return appnum;
  }
  addApllicatonNumber(var id) async {
    var appnum1=await getUserData(id);
    var userspref = FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs").doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.set(
            userspref,
            {
              "appnum": appnum1,
            },
            SetOptions(merge: true));
      } else {
        print("no");
      }
    });
  }
  getAppnum(){

  }
  @override
  void initState() {
    documents=[];
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    CollectionReference jobRef =FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs");
   return
     (role=="manger")?
     Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.black,
       actions: [
         Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width/1.2 ,
         child:
         SearchField(
onSuggestionTap: (e){
  print(e.searchKey);
  setState(() {
    search=true;
    title=e.searchKey;
documents=[];

  });

},
           autoCorrect: true,

           suggestions: documents!.map(
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



     (search==true)?
           StreamBuilder<dynamic>(
               stream:jobRef.where("title",isEqualTo: title).snapshots(),
               builder:(context,snapshots){
                 print(search);
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
                         addApllicatonNumber(snapshots.data.docs[i].id);
                         return Card(
                             elevation: 3,

                             child:
                             Container(decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(100),
                         ),
                         child:
                         InkWell(child: Column(
                           children: [

                             SizedBox(height: MediaQuery.of(context).size.height/10
                                 ,
                                 width: MediaQuery.of(context).size.width
                                 ,child:
                                 Row(
                                   //mainAxisAlignment: MainAxisAlignment.spaceAround,

                                   children: [
                                     Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                     Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/3)),

                                     Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                     ,Text("SAR",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                   ],
                                 )),
                             Center(
                               child:  Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                             ),
                             Center(
                               child:  Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"

                                 ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                             ),

                             Container(padding:EdgeInsets.only(top: 10),
                               height: MediaQuery.of(context).size.height/4,child: GoogleMap(
                                 //Map widget from google_maps_flutter package
                                 zoomGesturesEnabled: true, //enable Zoom in, out on map
                                 initialCameraPosition: CameraPosition(
                                   //innital position in map
                                   target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                   zoom: 14.0,
                                   //initial zoom level
                                 )
                                 ,
                                 markers:<Marker>{
                                   Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                   ),

                                 }

                                 ,
                                 mapType: MapType.normal,
                                 onMapCreated: (controller) {
                                   //method called when map is created
                                   setState(() {
                                     mapController = controller;
                                   });
                                 },

                               ) ,),



                           ],),
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
                         )));
                       }
                       ,

                     );
                 }
                 return Center(child: CircularProgressIndicator(),);
               }
           )

         :
     StreamBuilder<dynamic>(
         stream:jobRef.snapshots(),
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
                addApllicatonNumber(snapshots.data.docs[i].id);
                 return Card(
                   elevation: 20,
                   //color: Colors.,

                   child:
                   Container(padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(100),
                   ),
                   child:
                   InkWell(child: Column(
                     children: [

                     SizedBox(height: MediaQuery.of(context).size.height/10
                         ,
                         width: MediaQuery.of(context).size.width
                         ,child:
                         Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,

                       children: [
                         Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/3)),

                         Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                         ,Text("SAR",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                       ],
                     )),
                     Center(
                      child:  Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                     ),

                       Center(
                         child:  Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"

                           ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                       ),

                       Container(padding:EdgeInsets.only(top: 10),
                         height: MediaQuery.of(context).size.height/4,child: GoogleMap(
                         //Map widget from google_maps_flutter package
                         zoomGesturesEnabled: true, //enable Zoom in, out on map
                         initialCameraPosition: CameraPosition(
                           //innital position in map
                           target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                           zoom: 14.0,
                           //initial zoom level
                         )
                         ,
                         markers:<Marker>{
                       Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                       ),

                       }

                         ,
                         mapType: MapType.normal,
                           onMapCreated: (controller) {
                             //method called when map is created
                             setState(() {
                               mapController = controller;
                             });
                           },

                       ) ,),



                   ],),
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
                   )

                   ),)
                  ;

               }
               ,

             );
           }
           return Center(child: CircularProgressIndicator(),);
         }
     ),

     floatingActionButton: FloatingActionButton(
         backgroundColor: Colors.black,
         onPressed: (){
       Navigator.push(context,MaterialPageRoute(builder: (context)=>AddJob(sectionId)));
     },child: Icon(Icons.add)),
   ):
     Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.blue,
         actions: [
           Container(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width/1.2 ,

             child:
             SearchField(
               onSuggestionTap: (e){
                 print(e.searchKey);
                 setState(() {
                   search=true;
                   title=e.searchKey;
                   documents=[];

                 });

               },
               autoCorrect: true,

               suggestions: documents!.map(
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

       body:  (search==true)?
       StreamBuilder<dynamic>(
           stream:jobRef.where("title",isEqualTo: title).snapshots(),
           builder:(context,snapshots){
             print(search);
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
                     addApllicatonNumber(snapshots.data.docs[i].id);
                     return Card(
                         elevation: 3,

                         child:
                         Container(decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(100),
                         ),
                             child:
                             InkWell(child: Column(
                               children: [

                                 SizedBox(height: MediaQuery.of(context).size.height/10
                                     ,
                                     width: MediaQuery.of(context).size.width
                                     ,child:
                                     Row(
                                       //mainAxisAlignment: MainAxisAlignment.spaceAround,

                                       children: [
                                         Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                         Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/3)),

                                         Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                         ,Text("SAR",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                       ],
                                     )),
                                 Center(
                                   child:  Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                                 ),
                                 Center(
                                   child:  Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"

                                     ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                                 ),

                                 Container(padding:EdgeInsets.only(top: 10),
                                   height: MediaQuery.of(context).size.height/4,child: GoogleMap(
                                     //Map widget from google_maps_flutter package
                                     zoomGesturesEnabled: true, //enable Zoom in, out on map
                                     initialCameraPosition: CameraPosition(
                                       //innital position in map
                                       target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                       zoom: 14.0,
                                       //initial zoom level
                                     )
                                     ,
                                     markers:<Marker>{
                                       Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                       ),

                                     }

                                     ,
                                     mapType: MapType.normal,
                                     onMapCreated: (controller) {
                                       //method called when map is created
                                       setState(() {
                                         mapController = controller;
                                       });
                                     },

                                   ) ,),



                               ],),
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
                     )));
                   }
                   ,

                 );
             }
             return Center(child: CircularProgressIndicator(),);
           }
       )

           :
       StreamBuilder<dynamic>(stream:jobRef.snapshots(),
           builder:(context,snapshots){

             if(snapshots.hasError){
               return Text("erorr");
             }
             if (snapshots.hasData){

               return ListView.builder(
                 itemCount: snapshots.data.docs!.length,
                 itemBuilder: (context,i)
                 {
                   documents.add(snapshots.data.docs[i].data());
                   addApllicatonNumber(snapshots.data.docs[i].id);
                   return Card(
                       elevation: 3,

                       child:
                       Container(decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(100),
                       ),
                           child:
                           InkWell(child: Column(
                             children: [

                               SizedBox(height: MediaQuery.of(context).size.height/10
                                   ,
                                   width: MediaQuery.of(context).size.width
                                   ,child:
                                   Row(
                                     //mainAxisAlignment: MainAxisAlignment.spaceAround,

                                     children: [
                                       Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                       Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/3)),

                                       Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                       ,Text("SAR",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                     ],
                                   )),
                               Center(
                                 child:  Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                               ),
                               Center(
                                 child:  Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"

                                   ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),

                               ),

                               Container(padding:EdgeInsets.only(top: 10),
                                 height: MediaQuery.of(context).size.height/4,child: GoogleMap(
                                   //Map widget from google_maps_flutter package
                                   zoomGesturesEnabled: true, //enable Zoom in, out on map
                                   initialCameraPosition: CameraPosition(
                                     //innital position in map
                                     target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                     zoom: 14.0,
                                     //initial zoom level
                                   )
                                   ,
                                   markers:<Marker>{
                                     Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                     ),

                                   }

                                   ,
                                   mapType: MapType.normal,
                                   onMapCreated: (controller) {
                                     //method called when map is created
                                     setState(() {
                                       mapController = controller;
                                     });
                                   },

                                 ) ,),



                             ],),
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
                   )));
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