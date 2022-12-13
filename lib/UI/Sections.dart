import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/UI/addSection.dart';
import 'package:untitled3/UI/sectionDetail.dart';

import 'Jobs.dart';


class Section extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SectionState();
  }

}

class SectionState extends State<Section> {
  CollectionReference sectionRef = FirebaseFirestore.instance.collection(
      "Section");


  // StreamBuilder<dynamic>(stream: peopleRef.snapshots(),
  // builder:(context,snapshots){
  //
  // if(snapshots.hasError){
  // return Text("erorr");
  // }
  // if(snapshots.hasData){
  // return ListView.builder(
  // scrollDirection: Axis.vertical,
  // shrinkWrap: true,
  // itemCount:snapshots.data.docs!.length,
  // itemBuilder: (context, i) {
  // return
  // InkWell(child: Row(
  // mainAxisAlignment: MainAxisAlignment.spaceAround,
  // crossAxisAlignment: CrossAxisAlignment.end,
  // children:
  // [
  //
  // Text("${snapshots.data.docs[i].data()["name"]}"),
  // Padding(padding: EdgeInsets.all(2)),
  // Text("${snapshots.data.docs[i].data()["age"]}"),
  // Padding(padding: EdgeInsets.all(2)),
  // Text("${snapshots.data.docs[i].data()["faculty"]}"),
  // Padding(padding: EdgeInsets.all(2)),
  // Text("${snapshots.data.docs[i].data()["job"]}"),
  // Padding(padding: EdgeInsets.only(top: 40)),
  //
  // ],
  // ), onTap: () {
  // setState(() {
  // imagefromnetwork = true;
  // imagenetwork = snapshots.data.docs[i].data()["image"];
  // print(imagenetwork);
  // namecontr.text = snapshots.data.docs[i].data()["name"];
  // jobcontr.text = snapshots.data.docs[i].data()["job"];
  // facultycontr.text = snapshots.data.docs[i].data()["faculty"];
  // agecontr.text = (snapshots.data.docs[i].data()["age"]).toString();
  // Id =snapshots.data.docs[i].id;
  // print(Id);
  // });
  // },
  //
  // );
  // });
  // }
  // return Center(child: CircularProgressIndicator(),);
  //
  // }
  //
  // )
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue),
        backgroundColor: Colors.black,
      body: Container(color: Colors.black,child:StreamBuilder<dynamic>(stream: sectionRef.snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr");
              }
              if(snapshots.hasData){
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            //childAspectRatio: 3 / 2,
                          ),
                          itemCount: snapshots.data.docs!.length,
                          itemBuilder: (BuildContext context, int postion) {
                            return  Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 4,
                                padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0, right: 5.0),
                                child: InkWell(
                                  child: Column(children: [
                                    Container(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 5,

                                      //margin: EdgeInsets.only(top: 50),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage("${snapshots.data.docs[postion].data()["image"]}"), fit: BoxFit.fill)),
                                    ),
                                    Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Text(
                                          "${snapshots.data.docs[postion].data()["name"]}" ,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  onTap: () {
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
                                                  Text("Update Section")
                                                ],
                                              )
                                              , onTap: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>SectionDetail(snapshots.data.docs[postion].id,"${snapshots.data.docs[postion].data()["image"]}", "${snapshots.data.docs[postion].data()["name"]}" )));
                                            },
                                            ),
                                            Padding(padding: EdgeInsets.all(10),),
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.work),
                                                  Text("show Jobs")
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs()));
                                              },
                                            )
                                            //onTap: uplodImages(),

                                          ],
                                        );
                                    });

                                  },
                                ));
                            // return _buildCard(
                            // snapshots.data.docs[postion].data()["title"],
                            //  " ${snapshots.data.docs[postion].data()["image"]}",
                            // context);

                          },
                        )),
                    SizedBox(height: 15.0)
                  ],
                );

              }

              return Center(child: CircularProgressIndicator());
            }
        ) ,),
      floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSection()));
    },child: Icon(Icons.add)),

    );
    }

  }